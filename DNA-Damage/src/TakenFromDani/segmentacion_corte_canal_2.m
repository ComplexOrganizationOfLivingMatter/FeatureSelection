function [celulanovalida, Diapositiva] = segmentacion_corte_canal_2(nameFile, canal,cell,rect)

    %% Datos
    load(nameFile);

    Diapositiva = 0;
    im=imagesOfSerieByChannel;
    pl=imagesOfSerieByChannel(:, canal+1);
    [H,W,~]=size(im{1,1});
    Long=size(im, 1);

    canal=num2str(canal);

    %% Proyeccion de todos los planos
    proyeccionb=pl{1,1};
    for k=1:Long-1
        maximo = max(proyeccionb,pl{1+k});
        proyeccionb=maximo;
    end
    proyb=proyeccionb;
    %% Transformaciones morfologicas para obtener forma de cada celula(Se utilizará para detectar automaticamente el numero de celulas por imagen y asi evitar el recorte)

    % Binarizo la imagen proyeccion
    proyb_eq=histeq(proyb);
    BW=im2bw(proyb_eq,0.82);
    %figure;imshow(BW)
    % BW=im2bw(proyb,0.145);%%%%%%%%%%%%%%%%%%%%%%%%%% CAMBIO ESTE UMBRAL ANTES A 0.045
    %figure, imshow(BW), title('Binarizada')

    % Elimino pequeños objetos
    BW = bwareaopen(BW,10);
    %figure, imshow(BW), title('elimino pequeños')

    % Relleno huecos
    BW = imfill(BW,'holes');
    %figure, imshow(BW), title('relleno')


    %Apertura para eliminar puntos y dividir celulas
    se = strel('disk',10);
    BWcelulas = imopen(BW,se);
    %figure, imshow(BWcelulas), title('Celulas')
    masc_celulas=BWcelulas;

    L1 = bwlabel(BWcelulas,8);  % etiqueto zonas conexas
    L = label2rgb(L1);  %les doy color para representar
    %figure, imshow(L)

    mascara_validatoria=imcrop(L1,rect); % Si por proximidad tenemos la exigencia de coger un trozo pequeño de otra celula, aplicando esta máscara la eliminamos
    Area_cell_previo = regionprops(mascara_validatoria,'Area');
    Area_cell_previo = cat(1, Area_cell_previo.Area);

    [v ix]=max(Area_cell_previo);
    mascara_validatoria(mascara_validatoria~=ix)=0;
    mascara_validatoria=logical(mascara_validatoria);
    %%
    proyb_rect=imcrop(proyb,rect);
    proyb_rect=proyb_rect.*mascara_validatoria;
    h=fspecial('gaussian',[7 7], 1.5);
    imfilt=imfilter(proyb_rect,h);
    %figure, imshow(imfilt)
    BG=medfilt2(proyb_rect,[60 60]);%
    %figure, imshow(BG)

    dif=imfilt-BG;
    %figure, imshow(dif)
    umbral=graythresh(dif);
    BW=im2bw(dif,umbral*1.5);
    %figure, imshow(BW),title('Binarizamos la imagen')

    % Eliminacion de objetos formados por 4 pixeles o menos
    aux=bwareaopen(BW,5);
    %figure,imshow(aux);title('Eliminacion de objetos formados por 4 pixeles o menos')

    % Suavizamos contornos y rompemos conexiones debiles
    h=strel('diamond',1);
    aux=imopen(aux,h);
    %figure,imshow(aux);title('Suavizamos contornos y rompemos conexiones debiles')

    % Rellenamos huecos
    aux=imfill(aux,'holes');
    mascara=aux;
    proy_bin_azul=aux;
    %figure,imshow(aux);title('Rellenamos los huecos')


    %Umbral para detectar la heterocromatina de forma generalizada
    for corte=1:Long
        capa=imcrop(pl{corte},rect);
        capa=capa.*mascara_validatoria;
        h=fspecial('gaussian',[7 7], 1.5);
        capa=imfilter(capa,h);
        capa=capa.*mascara;
        umbral(corte)=graythresh(capa);
    end
    %plot(1:length(umbral),umbral)
    umbral_fin=max(umbral);
    umbral_fin=umbral_fin*0.75;


    for corte=1:Long
        % Detecta la heterocromatina de una celula determinada en cada uno de los cortes
        capa=imcrop(pl{corte},rect);
        capa=capa.*mascara_validatoria;
        capa=imadjust(capa,[0 max(max(capa))], [0 1]);
        h=fspecial('gaussian',[7 7], 1.5);
        capa=imfilter(capa,h);
        capa=capa.*mascara;
        % Binarizamos la imagen
        BW=im2bw(capa,umbral_fin);
        %figure, imshow(BW),title('Binarizamos la imagen')

        % Eliminacion de objetos formados por 15 pixeles o menos
        aux=bwareaopen(BW,15);
        %figure,imshow(aux);title('Eliminacion de objetos formados por 10 pixeles o menos')

        % Suavizamos contornos y rompemos conexiones debiles
        h=strel('diamond',1);
        aux=imopen(aux,h);
        %figure,imshow(aux);title('Suavizamos contornos y rompemos conexiones debiles')


        % Rellenamos huecos
        aux=imfill(aux,'holes');
        %     figure,subplot(1,2,1);imshow(capa);title('Heterocromatina')
        %     subplot(1,2,2);imshow(aux);title(strcat('Rellenamos los huecos-',num2str(corte)))
        mask_Hetero{1,corte}=aux;

        % Determina los bordes de una celula en cada uno de los cortes
        %% Tamaño de la celula en cada corte
        La=bwlabel(aux,8);
        med=unique(La);
        numobj=length(med)-1;
        capa=imcrop(pl{corte},rect);
        capa=capa.*mascara_validatoria;
        %figure;imshow(capa)
        % Binarizo la imagen proyeccion
        if numobj~=0
            umbral=graythresh(capa);
            BW=im2bw(capa,umbral*0.045);
        else
            BW=im2bw(capa,0.15);
        end


        % figure, imshow(BW), title(strcat('Binarizada-',num2str(corte)))

        se = strel('disk',5);
        BW = imclose(BW,se);

        % Elimino pequeños objetos
        BW = bwareaopen(BW,10);
        %figure, imshow(BW), title('elimino pequeños')

        % Relleno huecos
        BW = imfill(BW,'holes');
        %figure, imshow(BW), title('relleno')


        %Apertura para eliminar puntos y dividir celulas
        se = strel('disk',10);
        BWcell{1,corte} = imopen(BW,se);

        %         figure,subplot(1,2,1);imshow(capa);title('Celulas')
        %         subplot(1,2,2);imshow(BWcell{1,corte});title(strcat('Forma celula-', num2str(corte)))
        %
        Bord = regionprops(BWcell{1,corte}, 'Extrema'); % centroides de G de las zonas conexas
        Bordes{corte,1} = struct2cell(Bord);

    end

    objeto_primer=0;
    ocont=0;
    for N_corte=1:Long
        obj_num = bwlabel(mask_Hetero{1,N_corte});
        ind_obj=unique(obj_num);
        ind_obj=ind_obj(2:end);

        %Recopilacion de datos del corte N_corte para todos los objetos
        Area = regionprops(obj_num, 'Area'); % centroides de G de las zonas conexas
        Area = struct2cell(Area);
        Area = cell2mat(Area);

        Peri = bwperim(obj_num,4);
        PERIMETRO = regionprops(Peri, 'PixelList'); % centroides de G de las zonas conexas
        PERIMETRO = struct2cell(PERIMETRO);

        pos_obj = regionprops(obj_num, 'PixelList');
        pos_obj = struct2cell(pos_obj);
        if isempty(ind_obj)==0 % En caso de que en el corte N_corte haya objetos
            for i=1:length(ind_obj)
                col=1;
                repe=0;
                numero=1;
                objeto=0;
                %Recopilacion de datos del corte N_corte para el objeto i
                %Fase de comprobacion de repeticion de objetos
                if N_corte~=1 && objeto_primer==0
                    Pos_obj_actual=pos_obj{i};
                    for k=1:size(Recopilacion,1)
                        if Recopilacion{k,2}==(N_corte-1)
                            Pos_obj_ant = Recopilacion{k,5};
                            for npobact=1:size(Pos_obj_actual,1)
                                sit1=find(Pos_obj_actual(npobact,1)==Pos_obj_ant(:,1));
                                if isempty(sit1)==0
                                    sit2=find(Pos_obj_actual(npobact,2)==Pos_obj_ant(sit1,2));
                                    if isempty(sit2)==0
                                        repe=1;
                                        objeto(numero)=Recopilacion{k,1};
                                        numero=numero+1;
                                    end
                                end
                            end
                        end
                    end
                    objs=unique(objeto);
                    if repe==1
                        ocont=ocont+1;
                        if length(objs)==1
                            Recopilacion{ocont,1}=objs;
                        elseif length(objs)>=1
                            objs_min=min(objs);
                            Recopilacion{ocont,1}=objs_min;
                            for recorrer=1:ocont-1
                                for prosigue=1:length(objs)
                                    if Recopilacion{recorrer,1}==objs(prosigue)
                                        Recopilacion{recorrer,1}=objs_min;
                                    end
                                end
                            end


                        end
                        Recopilacion{ocont,2}=N_corte;
                        Recopilacion{ocont,3}=ind_obj(i);
                        Recopilacion{ocont,4}=Area(i);
                        Recopilacion{ocont,5}=pos_obj{i};
                        Recopilacion{ocont,6}=PERIMETRO{i};
                    elseif repe==0
                        ocont=ocont+1;
                        Recopilacion{ocont,1}=max(cell2mat({Recopilacion{:,1}}))+1;
                        Recopilacion{ocont,2}=N_corte;
                        Recopilacion{ocont,3}=ind_obj(i);
                        Recopilacion{ocont,4}=Area(i);
                        Recopilacion{ocont,5}=pos_obj{i};
                        Recopilacion{ocont,6}=PERIMETRO{i};
                    end
                else
                    ocont=ocont+1;
                    Recopilacion{ocont,1}=ind_obj(i); %indice del objeto
                    Recopilacion{ocont,2}=N_corte;
                    Recopilacion{ocont,3}=ind_obj(i);
                    Recopilacion{ocont,4}=Area(i);
                    Recopilacion{ocont,5}=pos_obj{i};
                    Recopilacion{ocont,6}=PERIMETRO{i};
                    objeto_primer=0;
                end
            end
        elseif N_corte==1
            objeto_primer=1;

        end

    end
    Matriz_resultado=sortrows(Recopilacion,[1 2]); %PARA ORDENAR LAS CELDAS ATENDIENDO AL OBJETO Y AL CORTE
    %Renumeramos los objetos

    objeto=1;
    cambio=0;
    Med=size(Matriz_resultado,1);
    for x=1:Med-1
        if  Matriz_resultado{x,1}~=Matriz_resultado{x+1,1}
            cambio=1;
        end
        Matriz_resultado{x,1}=objeto;
        if cambio==1
            objeto=objeto+1;
            cambio=0;
        end
    end
    Matriz_resultado{Med,1}=objeto;

    %Calculamos perimetro de cada objeto en cada corte
    n_obj=length(unique(cell2mat(Matriz_resultado(:,1))));
    n_datos=length(cell2mat(Matriz_resultado(:,1)));
    for fragmento=1:n_datos
        mask=zeros(rect(4)+1,rect(3)+1);
        coords=Matriz_resultado{fragmento,5};
        for i=1:size(coords,1)
            mask(coords(i,2),coords(i,1))=1;
        end
        mask=logical(mask);
        se = strel('diamond',1);
        maskD=imdilate(mask,se);
        Perimetro = regionprops(maskD, 'Perimeter');
        Perimetro = struct2cell(Perimetro);
        Perimetro = cell2mat(Perimetro);
        Matriz_resultado{fragmento,7}=Perimetro;
    end


    nameFileSplitted = strsplit(nameFile, '\');
    directory = strcat(nameFileSplitted{1}, '\segmentation\', nameFileSplitted{3});
    if isdir(directory)~=1
        mkdir(directory)
    end
    fichero=strcat(directory, '\segmentacion_ch_', canal,'_celula_', cell, '_', nameFileSplitted{end});
    save (fichero,'mascara_validatoria','proyeccionb','proyb_rect','proy_bin_azul','mask_Hetero','Matriz_resultado','masc_celulas','Bordes','BWcell')

    %%%%%%%%%%%%%%%%%%%%%%% CHANNEL 0 %%%%%%%%%%%%%%%%%%%%%%%
    canal = str2num(canal);
    canal = canal - 1;
    proyb=proyeccionb;
    BWcelulas=masc_celulas;
    pl=imagesOfSerieByChannel(:, canal+1);
    recorte=rect;
    
    
    canal=num2str(canal);

    %% Proyeccion de todos los planos
    proyecciong=pl{1};
    for k=1:Long-1
        maximo = max(proyecciong,pl{1+k});
        proyecciong=maximo;
    end
    %figure, imshow(proyecciong),title('Proyeccion de todo los planos')
    proyg=proyecciong;

    % Recorte de la proteccion de la capa verde de la celula
    proyg_rect1=imcrop(proyg,recorte);
    proyg_rect1=proyg_rect1.*mascara_validatoria;
    %figure, imshow(proyg_rect),title('Proyeccion del recorte')
    h=fspecial('gaussian',[7 7], 1.5);
    proyg_rect=imfilter(proyg_rect1,h);

    % Binarizamos la imagen
    umbral=graythresh(proyg_rect);
    BW=im2bw(proyg_rect,umbral);
    %figure, imshow(BW),title('Binarizamos la imagen')

    % Eliminacion de objetos formados por 4 pixeles o menos
    aux=bwareaopen(BW,4);
    %figure,imshow(aux);title('Eliminacion de objetos formados por 4 pixeles o menos')

    % Suavizamos contornos y rompemos conexiones debiles
    h=strel('diamond',1);
    aux=imopen(aux,h);
    %figure,imshow(aux);title('Suavizamos contornos y rompemos conexiones debiles')

    % Rellenamos huecos
    aux=imfill(aux,'holes');
    mascara=aux;
    proy_bin=aux;
    %figure,imshow(aux);title('Rellenamos los huecos verdes')

    % Buscamos todos los picos sobre la imagen recortada
    lo=logical(aux);
    L = bwlabel(aux);
    ind=unique(L);
    ind=ind(2:end);
    pix = regionprops(lo, 'PixelList');
    pix = struct2cell(pix);
    M_G = regionprops(lo, proyg_rect, 'MeanIntensity'); % centroides de G de las zonas conexas
    M_G = struct2cell(M_G);
    M_G = cell2mat(M_G);

    h=fspecial('gaussian',[30 30], 0.5);
    proyg_rect_suv=imfilter(proyg_rect,h);
    celulanovalida=0;
    picos=zeros(recorte(4)+1,recorte(3)+1);
    for i=1:length(ind)
        for j=1:size(pix{1,i},1)
            fil=pix{1,i}(j,2);
            col=pix{1,i}(j,1);
            intmax=proyg_rect_suv(fil,col);
            if fil~=1 && fil~=recorte(4) && col~=1 && col~=recorte(3)
                if (proyg_rect_suv(fil-1,col-1)<=intmax && proyg_rect_suv(fil-1,col)<=intmax && proyg_rect_suv(fil-1,col+1)<=intmax && proyg_rect_suv(fil,col-1)<=intmax && proyg_rect_suv(fil,col+1)<=intmax && proyg_rect_suv(fil+1,col-1)<=intmax && proyg_rect_suv(fil+1,col)<=intmax && proyg_rect_suv(fil+1,col+1)<=intmax && intmax>=M_G(1,i))
                    picos(fil,col)=1;
                end
            else
                celulanovalida=1;
                close all
                string=strcat('Alerta : Celula-',cell,' no valida');
                disp(string)
                break
            end

        end
        if celulanovalida==1
            break
        end

    end
    if celulanovalida==0
        picos_proy=picos;
        %figure,imshow(picos_proy);title('picos de gH2AX')

        %Representaciones
        proy_bin1=proy_bin;
        proy_bin(picos_proy==1)=0;

        PR=zeros(recorte(4)+1,recorte(3)+1);
        PG=PR;
        PB=PG;
        PR(proy_bin==1)=1;
        PG(proy_bin1==1)=1;
        PB(proy_bin==1)=1;

        MSK_proy_bin=cat(3,PR,PG,PB);
        figure;subplot(1,2,1),imshow(proyg_rect1);title('Proyeccion del plano verde')
        subplot(1,2,2),imshow(MSK_proy_bin);title('Picos de gH2AX sobre proyeccion binarizada')

        %%%BORRAR EN CUANTO TERMINE %%%%%%

        P=proy_bin_azul;
        P1=proy_bin_azul;
        P(picos_proy==1)=1;
        PR=zeros(recorte(4)+1,recorte(3)+1);
        PG=PR;
        PB=PG;
        PR(P1==1)=1;
        PG(P==1)=1;
        PB(P1==1)=1;
        MSK_P=cat(3,PR,PG,PB);
        % figure,subplot(1,2,2);imshow(MSK_P);title('Picos de gH2AX sobre proyeccion binarizada azul')
        % subplot(1,2,1);imshow(proyb_rect);title('Proyeccion del plano azul')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        fileNameNoExtension = strsplit(nameFileSplitted{end}, '.');
        stringres=strcat(directory, '\Proyeccion_General_Plano-verde', fileNameNoExtension{1} ,'.tiff');

        Diapositiva=Diapositiva+1;
        Diapositivach=num2str(Diapositiva);
        numeracion=strcat('-f',Diapositivach);
        print(numeracion,'-dtiff',stringres)
        
        aux1=zeros(recorte(4)+1,recorte(3)+1);

        for corte=1:Long
            capa=imcrop(pl{corte},rect);
            capa=capa.*mascara_validatoria;
            h=fspecial('gaussian',[7 7], 1.5);
            capa=imfilter(capa,h);
            capa=capa.*mascara;
            umbral(corte)=graythresh(capa);
        end
        % figure;plot(1:Long,umbral)
        umbral_fin=findpeaks(umbral,'SORTSTR','descend');
        umbral_fin=umbral_fin(find(umbral_fin>0.03));
        umbral_fin=min(umbral_fin)*1.2;


        for corte=1:Long
            % Recorte de la celula
            capa=imcrop(pl{corte},recorte);
            capa=capa.*mascara_validatoria;
            h=fspecial('gaussian',[7 7], 1.5);
            capa=imfilter(capa,h);
            capa=capa.*mascara;

            % Binarizamos la imagen
            BW=im2bw(capa,umbral_fin);
            %figure, imshow(BW),title('Binarizamos la imagen')

            % Eliminacion de objetos formados por 4 pixeles o menos
            aux=bwareaopen(BW,4);
            %figure,imshow(aux);title('Eliminacion de objetos formados por 4 pixeles o menos')

            % Suavizamos contornos y rompemos conexiones debiles
            h=strel('diamond',1);
            aux=imopen(aux,h);
            %figure,imshow(aux);title('Suavizamos contornos y rompemos conexiones debiles')

            % Rellenamos huecos
            aux=imfill(aux,'holes');
            mask=aux;
            %figure,imshow(aux);title('Rellenamos los huecos')

            mask1=mask;
            mask(picos_proy==1)=0;
            aux1=aux1+aux;

            PR=zeros(recorte(4)+1,recorte(3)+1);
            PG=PR;
            PB=PG;
            PR(mask1==1)=1;
            PG(mask==1)=1;
            PB(mask==1)=1;

            MSK=cat(3,PR,PG,PB);



            %Representaciones
            %             titulo=strcat('Picos de gH2AX sobre mascara en corte -', num2str(corte));
            %             figure;subplot(1,2,1),imshow(capa)
            %             subplot(1,2,2),imshow(MSK);title(titulo)
            %
            mask_fosi{1,corte}=aux;
            mask_fosi_pico{1,corte}=MSK;

        end

        %figure;imshow(aux1)

        % Eliminamos puntos adquiridos como picos de focis que no se encuentren
        % sobre ningun objeto de la imagen proyeccion de las distintas capas
        % segmentadas
        mask=aux1;
        %figure;imshow(picos_proy);title('antes')
        picos_proy(mask==0)=0;
        % figure;imshow(picos_proy);title('despues')

        PR=zeros(recorte(4)+1,recorte(3)+1);
        PR=PR+mask;
        PG=PR;
        PB=PG;

        PR(picos_proy==1)=1;
        PG(picos_proy==1)=0;
        PB(picos_proy==1)=0;

        MSK_general=cat(3,PR,PG,PB);

        %Representaciones
        %figure,imshow(MSK_general);title('Picos de gH2AX sobre mascara general')

        %Numeramos picos de la proyeccion
        picos_num = bwlabel(picos_proy);
        ind_picos=unique(picos_num);
        ind_picos=ind_picos(2:end);
        pos_seed = regionprops(picos_num, 'PixelList');
        pos_seed = struct2cell(pos_seed);
        objeto_primer=0;
        ocont=0;
        for N_corte=1:Long

            obj_num = bwlabel(mask_fosi{1,N_corte});
            ind_obj=unique(obj_num);
            ind_obj=ind_obj(2:end);

            %Recopilacion de datos del corte N_corte para todos los objetos
            Area = regionprops(obj_num, 'Area'); % centroides de G de las zonas conexas
            Area = struct2cell(Area);
            Area = cell2mat(Area);

            Peri = bwperim(obj_num,4);
            PERIMETRO = regionprops(Peri, 'PixelList'); % centroides de G de las zonas conexas
            PERIMETRO = struct2cell(PERIMETRO);

            pos_obj = regionprops(obj_num, 'PixelList');
            pos_obj = struct2cell(pos_obj);

            if isempty(ind_obj)==0 % En caso de que en el corte N_corte haya objetos
                for i=1:length(ind_obj)
                    col=1;
                    repe=0;
                    numero=1;
                    objeto=0;
                    %Recopilacion de datos del corte N_corte para el objeto i

                    peak=0;
                    for j=1:length(ind_picos)
                        [p]=pos_seed{1,j};
                        if obj_num(p(1,2),p(1,1))==i
                            peak(1,col)=j;
                            col=col+1;
                        end

                    end


                    %Fase de comprobacion de repeticion de objetos


                    if N_corte~=1 && objeto_primer==0
                        Pos_obj_actual=pos_obj{i};
                        for k=1:size(Recopilacion,1)
                            if Recopilacion{k,2}==(N_corte-1)
                                Pos_obj_ant = Recopilacion{k,5};
                                for npobact=1:size(Pos_obj_actual,1)
                                    sit1=find(Pos_obj_actual(npobact,1)==Pos_obj_ant(:,1));
                                    if isempty(sit1)==0
                                        sit2=find(Pos_obj_actual(npobact,2)==Pos_obj_ant(sit1,2));
                                        if isempty(sit2)==0
                                            repe=1;
                                            objeto(numero)=Recopilacion{k,1};
                                            numero=numero+1;
                                        end
                                    end
                                end
                            end
                        end
                        objs=unique(objeto);
                        if repe==1
                            ocont=ocont+1;
                            if length(objs)==1
                                Recopilacion{ocont,1}=objs;
                            elseif length(objs)>=1
                                objs_min=min(objs);
                                Recopilacion{ocont,1}=objs_min;
                                for recorrer=1:ocont-1
                                    for prosigue=1:length(objs)
                                        if Recopilacion{recorrer,1}==objs(prosigue)
                                            Recopilacion{recorrer,1}=objs_min;
                                        end
                                    end
                                end


                            end
                            Recopilacion{ocont,2}=N_corte;
                            Recopilacion{ocont,3}=Area(i);
                            Recopilacion{ocont,4}=peak;
                            Recopilacion{ocont,5}=pos_obj{i};
                            Recopilacion{ocont,11}=PERIMETRO{i};
                        elseif repe==0
                            ocont=ocont+1;
                            Recopilacion{ocont,1}=max(cell2mat({Recopilacion{:,1}}))+1;
                            Recopilacion{ocont,2}=N_corte;
                            Recopilacion{ocont,3}=Area(i);
                            Recopilacion{ocont,4}=peak;
                            Recopilacion{ocont,5}=pos_obj{i};
                            Recopilacion{ocont,11}=PERIMETRO{i};
                        end
                    else
                        ocont=ocont+1;
                        Recopilacion{ocont,1}=ind_obj(i); %indice del objeto
                        Recopilacion{ocont,2}=N_corte;
                        Recopilacion{ocont,3}=Area(i);
                        Recopilacion{ocont,4}=peak;
                        Recopilacion{ocont,5}=pos_obj{i};
                        Recopilacion{ocont,11}=PERIMETRO{i};
                        objeto_primer=0;
                    end
                end
            elseif N_corte==1
                objeto_primer=1;

            end
        end
        Recopilacion_ord=sortrows(Recopilacion,[1 2]); %PARA ORDENAR LAS CELDAS ATENDIENDO AL OBJETO Y AL CORTE

        % Eliminamos todos los objetos que en ninguna de sus capas tengan un pico
        Nobj=unique(cell2mat({Recopilacion_ord{:,1}}));
        tam=length(Nobj);
        datos=cell2mat({Recopilacion_ord{:,1}});
        for x=1:tam
            valido=0;
            indices=find(Nobj(x)==datos);
            for y=1:length(indices)
                comp= find(cell2mat({Recopilacion_ord{indices(y),4}})==0);
                if isempty(comp)==1
                    valido=1;
                end
            end
            if valido==0

                for i=indices(1):indices(end)
                    Recopilacion_ord{i,1}=[];
                    Recopilacion_ord{i,2}=[];
                    Recopilacion_ord{i,3}=[];
                    Recopilacion_ord{i,4}=[];
                    Recopilacion_ord{i,5}=[];
                    Recopilacion_ord{i,11}=[];
                end
            end
        end

        %Reordenamos objetos de la matriz
        Med=size(Recopilacion_ord,1);
        Ult_Numero=0;
        %Matriz_resultado=cell(1,1);
        clear Matriz_resultado
        for x=1:Med
            Numero=Recopilacion_ord{x,1};
            if isempty(Numero)==0

                Matriz_resultado{Ult_Numero+1,1}=Recopilacion_ord{x,1};
                Matriz_resultado{Ult_Numero+1,2}=Recopilacion_ord{x,2};
                Matriz_resultado{Ult_Numero+1,3}=Recopilacion_ord{x,3};
                Matriz_resultado{Ult_Numero+1,4}=Recopilacion_ord{x,4};
                Matriz_resultado{Ult_Numero+1,5}=Recopilacion_ord{x,5};
                Matriz_resultado{Ult_Numero+1,11}=Recopilacion_ord{x,11};
                Ult_Numero=Ult_Numero+1;
            end

        end

        %Renumeramos los objetos

        objeto=1;
        cambio=0;
        Med=size(Matriz_resultado,1);
        for x=1:Med-1
            if  Matriz_resultado{x,1}~=Matriz_resultado{x+1,1}
                cambio=1;
            end
            Matriz_resultado{x,1}=objeto;
            if cambio==1
                objeto=objeto+1;
                cambio=0;
            end
        end
        Matriz_resultado{Med,1}=objeto;
        
        fichero=strcat(directory, '\segmentacion_ch_', canal,'_celula_', cell, '_', nameFileSplitted{end});
        save (fichero,'mascara_validatoria','proyeccionb','proy_bin_azul','masc_celulas','proyecciong','mask_fosi','mask_fosi_pico','MSK_general','Matriz_resultado','pos_seed','Bordes','BWcell','picos_proy')
        cd ..
    end

end