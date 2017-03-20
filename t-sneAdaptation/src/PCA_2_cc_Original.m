%%PCA_2_cc
function PCA_2_cc_Original(m_t1,m_t2,n_t1,n_t2, weightedVersion)

close all

%Seleccionamos las características que queramos: 

CARACT=1:size(m_t1, 2); %69 cc de estructura celular + 12 cc de núcleos.


% Grupo 1. Asignamos al grupo 1 la matriz elegida en la función.

matriz_t1=m_t1;
n_img_tipo1=size(matriz_t1,1);


%Grupo 2. Asignamos al grupo 2 la matriz elegida en la función.


matriz_t2=m_t2;
n_img_tipo2=size(matriz_t2,1);



vector_todas_caracteristicas=[matriz_t1;matriz_t2];
vector_todas_caracteristicas(isnan(vector_todas_caracteristicas))=0;


%% numero de imagenes y numero de cc

n_imagenes=n_img_tipo1+n_img_tipo2;
n_cc_totales=length(CARACT);



categorization(1:n_img_tipo1) = {n_t1};
categorization(n_img_tipo1+1:n_imagenes) = {n_t2};


%% Vector de clases. hay tantas columnas como clases, en la primera column pongo a 1 las
% imagenes q pertenecen y en la segunda a 1 los que pertenecen a la clase
% 2, y asi sucesivamente

%vector_clases=zeros([n_imagenes,2]);
%vector_clases(1:n_img_tipo1,1)=1;
%vector_clases(n_img_tipo1+1:n_imagenes,2)=1;

%Comando que sirve simplemnte para medir el tiempo de ejecución. (se cierra con toc)

Niteracion=1;

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
          
        % Cálculo de los autovalores/autovesctores
        [Vectors,Values] = eig(L);
        [~,ind] = sort(diag(Values),'descend');   % se ordenan los autovalores
        V = Vectors(:,ind);
        
        
        
        %Convierto los autovalores de X'X en los autovectores de X*X'
        Vectors = X*V;
        
        % Normalizo los vectores, para conseguir longitud unitaria
        for i=1:size(X,2)
            Vectors(:,i) = Vectors(:,i)/norm(Vectors(:,i));
        end
        
        
        V=Vectors(:,1:2);
        
        %W{1,Niteracion}=V'*X;  %Proyecciones
        
        label=[ones(1, n_img_tipo1), 2*ones(1,n_img_tipo2)];
        
        [Ratio_pca(1,Niteracion), W{1,Niteracion}] = getHowGoodAreTheseCharacteristics(vectores_caracteristicas, label, V);
        Ratio_pca(2,Niteracion)=cc1;
        Ratio_pca(3,Niteracion)=cc2;
        eigenvectors{Niteracion} = V;
        
        Niteracion=Niteracion+1;
        
          
        %%%%-----$$$$------PROBAR DIRECTAMENTE EL COMANDO PCA DE MATLAB y  observar DIFERENCIAS-----$$$$----%%%%

    end
end

%% Calculamos las 10 mejores PCA y sus 3 cc iniciales

auxiliar=Ratio_pca(1,:);
for i = 1:Niteracion
    [Mejores(i,1) num]=max(auxiliar);
    Mejores(i,2)=Ratio_pca(2,num);
    Mejores(i,3)=Ratio_pca(3,num);
    Proy{i,1}=W{1,num};
    auxiliar(1,num)=0;
    best_eigenvectors{i} = eigenvectors(num);
end

eigenvectors = best_eigenvectors;

%Incrementamos el nº de cc a las que queramos. Nosotros nos quedamos con 
%el vector expansión de este modo ya que seguimos un proceso:

expansion=[10 10 5 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

% 1-Bucle anterior: Ya hemos testeado las 10 mejores parejas que separan
% mejor. Ahora les añadimos una cc para que sean los 10 mejores trios que
% mejor separen.

% Seguidamente:

% 2-Comparamos cada cc individual contra los 10 tríos, y nos
% quedamos con los 5 mejores descriptores de PCA de cada trío. De esta manera
% manejaremos 50 cuartetos de cc (5x10)

% 3-Repetimos el proceso anterior y nos quedamos con las 2 mejores cc.
% Trataríamos con 100 quintetos de cc (5x10x2)

% Finalmente seguimos añadiendo una 'cc' hasta que se obtienen 7 cc o el
% descriptor de PCA es menor al del paso anterior.

add_cc=1;
Mejores_ant=Mejores;
eigenvectors_ant = best_eigenvectors;
Proy_ant=Proy;
Mejores_des=Mejores;
Mejores_ant_des=Mejores_des;

mejoresEachStep{1} = Mejores;
eigenvectorsEachStep{1} = best_eigenvectors;
proyEachStep{1} = Proy;
mejores_desEachStep{1} = Mejores_des;

%El proceso sigue ejecutandose hasta que el descriptor de PCA es menor al
%del paso anterior o hasta que se expanden las cc 4 veces. Es decir, como
%máximo se realizarán 4 expansiones.
while add_cc<=5
    add_cc
    Mejores_ant=Mejores;
    Mejores_ant_des=Mejores_des;
    Proy_ant=Proy;
    eigenvectors_ant = eigenvectors;
    clear Proy
    [Mejores,Mejores_des,Proy, eigenvectors]=anadir_cc_original(Mejores_ant,Mejores_ant_des,vector_todas_caracteristicas,expansion(add_cc),n_img_tipo1,n_img_tipo2, categorization);
    % Ordenamos Mejores de mejor a peor PCA
    [Mejores orden]=sortrows(Mejores,-1);
    
    for i=1:size(orden,1)
        Proyb{i,1}=Proy{orden(i),1};
        eigenvectorsb{i,1} = eigenvectors(orden(i), 1);
        Mejores_des_aux(i,:)=Mejores_des(orden(i),:);
    end
    Proy=Proyb;
    eigenvectors = eigenvectorsb;
    clear eigenvectorsb
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
                eigenvectors(i+cuenta, :) = [];
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
    mejoresEachStep{add_cc} = Mejores;
    eigenvectorsEachStep{add_cc} = eigenvectors;
    proyEachStep{add_cc} = Proy;
    mejores_desEachStep{add_cc} = Mejores_des;
end

%% Evaluacion final
[~, numIter] = max(cellfun(@(x) max(x(:,1)), mejoresEachStep));
%Mejor_pca=Mejores(1,1);
bestIterationPCA = mejoresEachStep{numIter};
[Mejor_pca, numRow] = max(bestIterationPCA(:, 1));
indice_cc_seleccionadas=bestIterationPCA(numRow, 2:size(bestIterationPCA,2));
eigenvectors = eigenvectorsEachStep{numIter};
eigenvectors = eigenvectors{numRow,1}{1};
Proy = proyEachStep{numIter};


%save( ['PCA_' n_t1 '_' n_t2 '_seleccion_cc_' num2str(n_cc_totales)], 'mejoresEachStep', 'mejores_desEachStep', 'Proy', 'Mejor_pca','indice_cc_seleccionadas', 'eigenvectors')


%%Representar


% Proyecc=Proy{1,1};
% figure, plot(Proyecc(1,1:n_img_tipo1),Proyecc(2,1:n_img_tipo1),'.g','MarkerSize',18), text(Proyecc(1,1:n_img_tipo1),Proyecc(2,1:n_img_tipo1),num2str(indice_1))
% hold on, plot(Proyecc(1,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),Proyecc(2,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),'.r','MarkerSize',18), text(Proyecc(1,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),Proyecc(2,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),num2str(indice_2))


% stringres=strcat('PCA','------->Caracteristicas seleccionadas:',num2str(indice_cc_seleccionadas),' Descriptor: ',num2str(Mejor_pca));
% title(stringres)
%%Representar formato Luisma
Proyecc=Proy{1,1}';
h=figure; plot(Proyecc(1,1:n_img_tipo1),Proyecc(2,1:n_img_tipo1),'.g','MarkerSize',30)
hold on, plot(Proyecc(1,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),Proyecc(2,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),'.r','MarkerSize',30)
legend(n_t1,n_t2)

categorization(1:n_img_tipo1) = {n_t1};
categorization(n_img_tipo1+1:n_imagenes) = {n_t2};

weights = ones(n_imagenes, 1);
resResubCM = ones(2, 2);
if ~isempty(strfind(n_t1, 'High'))
    highIndex = 1;
    highIndex2 = 2;
elseif ~isempty(strfind(n_t2, 'High'))
    highIndex = 2;
    highIndex2 = 1;
end

if exist('highIndex', 'var') == 1 && weightedVersion
    while resResubCM(highIndex, highIndex2) >= 1
        if ~isempty(strfind(n_t1, 'High'))
            weights(1:n_img_tipo1) = weights(1:n_img_tipo1) + 1;
        elseif ~isempty(strfind(n_t2, 'High'))
            weights(n_img_tipo1+1:n_imagenes) = weights(n_img_tipo1+1:n_imagenes) + 1;
        end
        % You can put the Weights on here
        res = fitcdiscr(Proyecc', categorization', 'Weights', weights);
        resClass = resubPredict(res);
        [resResubCM,grpOrder] = confusionmat(categorization', resClass);
        bad = ~strcmp(resClass, categorization');
    end
else
    res = fitcdiscr(Proyecc', categorization');
    resClass = resubPredict(res);
    [resResubCM,grpOrder] = confusionmat(categorization', resClass);
    bad = ~strcmp(resClass, categorization');
end
hold on;
Proyecc = Proyecc';
plot(Proyecc(bad,1), Proyecc(bad,2), 'kx');
hold off;

sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;

stringres=strcat(num2str(indice_cc_seleccionadas));
title(stringres)
classificationInfo = res;
if weightedVersion
    save( ['PCA_Weighted_' n_t1 '_' n_t2 '_seleccion_cc_' num2str(n_cc_totales)], 'mejoresEachStep', 'mejores_desEachStep', 'Proy', 'Mejor_pca','indice_cc_seleccionadas', 'eigenvectors', 'resResubCM', 'classificationInfo', 'specifity', 'sensitivity')
    saveas(h,['PCA_Weighted_' n_t1 '_' n_t2 '.jpg'])
else
    save( ['PCA_' n_t1 '_' n_t2 '_seleccion_cc_' num2str(n_cc_totales)], 'mejoresEachStep', 'mejores_desEachStep', 'Proy', 'Mejor_pca','indice_cc_seleccionadas', 'eigenvectors', 'resResubCM', 'classificationInfo', 'specifity', 'sensitivity')
    saveas(h,['PCA_' n_t1 '_' n_t2 '.jpg'])
end

close all
end
