%%PCA_2_cc

function PCA_2_cc(m_t1,m_t2,n_t1,n_t2)


%Seleccionamos las caracter�sticas que queramos: 

CARACT=1:81; %69 cc de estructura celular + 12 cc de n�cleos.


% Grupo 1. Asignamos al grupo 1 la matriz elegida en la funci�n.

matriz_t1=m_t1;
n_img_tipo1=size(matriz_t1,1);


%Grupo 2. Asignamos al grupo 2 la matriz elegida en la funci�n.


matriz_t2=m_t2;
n_img_tipo2=size(matriz_t2,1);




vector_todas_caracteristicas=[matriz_t1;matriz_t2];


%% numero de imagenes y numero de cc

n_imagenes=n_img_tipo1+n_img_tipo2;
n_cc_totales=length(CARACT);


%% Vector de clases. hay tantas columnas como clases, en la primera column pongo a 1 las
% imagenes q pertenecen y en la segunda a 1 los que pertenecen a la clase
% 2, y asi sucesivamente

vector_clases=zeros([n_imagenes,2]);
vector_clases(1:n_img_tipo1,1)=1;
vector_clases(n_img_tipo1+1:n_imagenes,2)=1;

%Comando que sirve simplemnte para medir el tiempo de ejecuci�n. (se cierra con toc)

Niteracion=1;
tic

%% Calculamos las combinaciones iniciales de 2 caracteristicas

for cc1=1:n_cc_totales-1
    for cc2=cc1+1:n_cc_totales
    
         %Voy incluyendo caracteristica
         vectores_caracteristicas(:,1:2)=[vector_todas_caracteristicas(:,cc1) ,vector_todas_caracteristicas(:,cc2)];
        
         %Normalizamos los vectores
         for cc=1:2
             
            vectores_caracteristicas(:,cc)=vectores_caracteristicas(:,cc)-min(vectores_caracteristicas(:,cc));
            vectores_caracteristicas(:,cc)=vectores_caracteristicas(:,cc)/max(vectores_caracteristicas(:,cc));  
             
         end
         
         vectores_caracteristicas(isnan(vectores_caracteristicas))=0;% PARA HACER 0 TODOS LOS NAN

        
         %% Realizamos PCA
         
         X=vectores_caracteristicas';
          
         %Calculamos la media
         Media=mean(X,2);
          
         %Le resto la media a cada imagen
         for i = 1:size(X,2)
            X(:,i) = X(:,i) - Media;
         end
        
         L = X'*X;

        % C�lculo de los autovalores/autovesctores
        [Vectors,Values] = eig(L);
        [lambda,ind]=sort(diag(Values),'descend');   % se ordenan los autovalores
        V = Vectors(:,ind);
        
        V = X * V;
        
		sum_X = sum(V .^ 2, 2);
		D = bsxfun(@plus, sum_X, bsxfun(@plus, sum_X', -2 * (V * V')));
		
		% Compute joint probabilities
		perplexity = 30;
		P = d2p(D, perplexity, 1e-5); % compute affinities using fixed perplexity
		clear D
		
        no_dims = n_img_tipo1 + n_img_tipo2;
		V = tsne_p(P, [], no_dims);
        
        %Hasta aqui est� bien
        
        W{1,Niteracion}=V'*X;  %Proyecciones
        
        %%%% Obtencion de numeros a partir de graficas metodo3 (LUCIANO)
        label=[ones(1, n_img_tipo1), 2*ones(1,n_img_tipo2)];
        [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(W{1,Niteracion}',label,2);
        C=sinterluc/sintraluc;
        Ratio_pca(1,Niteracion)=trace(C);
        Ratio_pca(2,Niteracion)=cc1;
        Ratio_pca(3,Niteracion)=cc2;
        
        Niteracion=Niteracion+1;
        
          
        %%%%-----$$$$------PROBAR DIRECTAMENTE EL COMANDO PCA DE MATLAB y  observar DIFERENCIAS-----$$$$----%%%%
        
        
         
        
    end
end

%% Calculamos las 10 mejores PCA y sus 3 cc iniciales

auxiliar=Ratio_pca(1,:);
for i=1:10
    [Mejores(i,1) num]=max(auxiliar);
    Mejores(i,2)=Ratio_pca(2,num);
    Mejores(i,3)=Ratio_pca(3,num);
    Proy{i,1}=W{1,num};
    auxiliar(1,num)=0;
end

%Incrementamos el n� de cc a las que queramos. Nosotros nos quedamos con 
%el vector expansi�n de este modo ya que seguimos un proceso:

expansion=[1 5 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

% 1-Bucle anterior: Ya hemos testeado las 10 mejores parejas que separan
% mejor. Ahora les a�adimos una cc para que sean los 10 mejores trios que
% mejor separen.

% Seguidamente:

% 2-Comparamos cada cc individual contra los 10 tr�os, y nos
% quedamos con los 5 mejores descriptores de PCA de cada tr�o. De esta manera
% manejaremos 50 cuartetos de cc (5x10)

% 3-Repetimos el proceso anterior y nos quedamos con las 2 mejores cc.
% Tratar�amos con 100 quintetos de cc (5x10x2)

% Finalmente seguimos a�adiendo una 'cc' hasta que se obtienen 7 cc o el
% descriptor de PCA es menor al del paso anterior.

add_cc=1;
Mejores_ant=Mejores;
Proy_ant=Proy;
Mejores_des=Mejores;
Mejores_ant_des=Mejores_des;

%El proceso sigue ejecutandose hasta que el descriptor de PCA es menor al
%del paso anterior o hasta que se expanden las cc 4 veces. Es decir, como
%m�ximo se realizar�n 4 expansiones.

while Mejores(1,1)>=Mejores_ant(1,1) && add_cc<=5
    Mejores_ant=Mejores;
    Mejores_ant_des=Mejores_des;
    Proy_ant=Proy;
    clear Proy
    [Mejores,Mejores_des,Proy]=anadir_cc(Mejores_ant,Mejores_ant_des,vector_todas_caracteristicas,expansion(add_cc),n_img_tipo1,n_img_tipo2);
    % Ordenamos Mejores de mejor a peor PCA
    [Mejores orden]=sortrows(Mejores,-1);
    
    for i=1:size(orden,1)
        Proyb{i,1}=Proy{orden(i),1};
        Mejores_des_aux(i,:)=Mejores_des(orden(i),:);
    end
    Proy=Proyb;
    clear Proyb
    Mejores_des=Mejores_des_aux;
    clear Mejores_des_aux
    %Eliminamos de Mejores las cc que se repitan
    i=1;
    Tam=size(Mejores,1);
    while i<=Tam-1
        if length(find(sort(Mejores(i,2:end))==sort(Mejores(i+1,2:end))))==size(Mejores,2)-1
            cuenta=1;
            while length(find(sort(Mejores(i,2:end))==sort(Mejores(i+cuenta,2:end))))==size(Mejores,2)-1
                Mejores(i,2:end)=sort(Mejores(i,2:end));
                Mejores(i+cuenta,:)=[];
                Proy(i+cuenta,:)=[];
                Mejores_des(i+cuenta,:)=[];
                if i+cuenta < size(Mejores,1)
                    cuenta=cuenta+1;
                else
                    break
                end
                Tam=Tam-1;
            end
        else
            Mejores(i,2:end)=sort(Mejores(i,2:end));
        end
        if i+1 < size(Mejores,1)
            i=i+1;
        else
            break
        end
    end
    
    add_cc=add_cc+1;
end


% entra_bucle_while=0;
% 
% 
% %%Si se da el caso en el que los mejores descriptores de PCA del ultimo
% %%paso del bucle while no son mejores a los del paso anterior. Volvemos a
% %%obtener los mejores del paso anterior 
% if Mejores(1,1)<Mejores_ant(1,1)
%     Mejores=Mejores_ant;
%     Mejores_des=Mejores_ant_des;
%     Proy=Proy_ant;
% else
%     
%     %%incrementamos cc hasta que
%     
%     while Mejores(1,1)-Mejores_ant(1,1)>0.1
%         entra_bucle_while=1;
%         Mejores_ant=Mejores;
%         Mejores_ant_des=Mejores_des;
%         Proy_ant=Proy;
%         clear Proy
%         [Mejores,Mejores_des,Proy]=anadir_cc(Mejores_ant,Mejores_ant_des,vector_todas_caracteristicas,expansion(add_cc),n_img_tipo1,n_img_tipo2);
%         % Ordenamos Mejores de mejor a peor PCA
%         [Mejores orden]=sortrows(Mejores,-1);
%         
%         for i=1:size(orden,1)
%             Proyb{i,1}=Proy{orden(i),1};
%             Mejores_des_aux(i,:)=Mejores_des(orden(i),:);
%         end
%         Proy=Proyb;
%         clear Proyb
%         Mejores_des=Mejores_des_aux;
%         clear Mejores_des_aux
%         %Eliminamos de Mejores las cc que se repitan
%         i=1;
%         Tam=size(Mejores,1);
%         while i<=Tam-1
%             if length(find(sort(Mejores(i,2:end))==sort(Mejores(i+1,2:end))))==size(Mejores,2)-1
%                 cuenta=1;
%                 while length(find(sort(Mejores(i,2:end))==sort(Mejores(i+cuenta,2:end))))==size(Mejores,2)-1
%                     Mejores(i,2:end)=sort(Mejores(i,2:end));
%                     Mejores(i+cuenta,:)=[];
%                     Proy(i+cuenta,:)=[];
%                     Mejores_des(i+cuenta,:)=[];
%                     if i+cuenta < size(Mejores,1)
%                         cuenta=cuenta+1;
%                     else
%                         break
%                     end
%                     Tam=Tam-1;
%                 end
%             else
%                 Mejores(i,2:end)=sort(Mejores(i,2:end));
%             end
%             if i+1 < size(Mejores,1)
%                 i=i+1;
%             else
%                 break
%             end
%         end
%         
%         add_cc=add_cc+1;
%     end
% end
% if entra_bucle_while==1
%     Mejores=Mejores_ant;
%     Mejores_des=Mejores_ant_des;
%     Proy=Proy_ant;
% end

%% Evaluacion final
Mejor_pca=Mejores(1,1);
indice_cc_seleccionadas=sort(Mejores(1,2:size(Mejores,2)));


save( ['tsne_' n_t1 '_' n_t2 '_seleccion_cc_' num2str(n_cc_totales)], 'Mejores', 'Mejores_des', 'Proy', 'Mejor_pca','indice_cc_seleccionadas')


%%Representar


% Proyecc=Proy{1,1};
% figure, plot(Proyecc(1,1:n_img_tipo1),Proyecc(2,1:n_img_tipo1),'.g','MarkerSize',18), text(Proyecc(1,1:n_img_tipo1),Proyecc(2,1:n_img_tipo1),num2str(indice_1))
% hold on, plot(Proyecc(1,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),Proyecc(2,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),'.r','MarkerSize',18), text(Proyecc(1,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),Proyecc(2,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),num2str(indice_2))


% stringres=strcat('PCA','------->Caracteristicas seleccionadas:',num2str(indice_cc_seleccionadas),' Descriptor: ',num2str(Mejor_pca));
% title(stringres)
%%Representar formato Luisma
Proyecc=Proy{1,1};
h=figure; plot(Proyecc(1,1:n_img_tipo1),Proyecc(2,1:n_img_tipo1),'.g','MarkerSize',30)
hold on, plot(Proyecc(1,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),Proyecc(2,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),'.r','MarkerSize',30)


stringres=strcat(num2str(indice_cc_seleccionadas));
title(stringres)
saveas(h,['tsne_' n_t1 '_' n_t2 '.jpg'])

close all
end
