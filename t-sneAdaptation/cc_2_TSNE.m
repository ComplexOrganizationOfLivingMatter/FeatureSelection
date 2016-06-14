%%PCA_2_cc
function cc_2_TSNE(m_t1,m_t2,n_t1,n_t2, indice_cc_seleccionadas)


matriz_t1=m_t1;
n_img_tipo1=size(matriz_t1,1);


%Grupo 2. Asignamos al grupo 2 la matriz elegida en la función.


matriz_t2=m_t2;
n_img_tipo2=size(matriz_t2,1);




vector_todas_caracteristicas=[matriz_t1;matriz_t2];


%% numero de imagenes y numero de cc

n_imagenes=n_img_tipo1+n_img_tipo2;

vector_todas_caracteristicas(isnan(vector_todas_caracteristicas))=0;

X = vector_todas_caracteristicas;

%% PCA
X = X (:, indice_cc_seleccionadas)

X = X';

%Calculamos la media
 Media=mean(X,2);

 %Le resto la media a cada imagen
 for i = 1:size(X,2)
    X(:,i) = X(:,i) - Media;
 end

 L = X'*X;

% Cálculo de los autovalores/autovesctores
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




Proyecc = V;
h=figure; plot(Proyecc(1,1:n_img_tipo1),Proyecc(2,1:n_img_tipo1),'.g','MarkerSize',30)
hold on, plot(Proyecc(1,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),Proyecc(2,n_img_tipo1+1:n_img_tipo1+n_img_tipo2),'.r','MarkerSize',30)


stringres=strcat(num2str(indice_cc_seleccionadas));
title(stringres)
saveas(h,['tsneClassifierPCA_' n_t1 '_' n_t2 '.jpg'])

end
