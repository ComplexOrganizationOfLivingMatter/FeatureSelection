function [W,eigenvectors,Ratio_pca]=calculatePCAValues(matrixChosenCcs,nIteration,nImgType1,nImgType2,W,eigenvectors,Ratio_pca,ccsChosen)
            
        %Operations to calculate PCA ratio and weight
        X=matrixChosenCcs';
        meanCCs=mean(X,2);
     
        for i = 1:size(X,2)
           X(:,i) = X(:,i) - meanCCs;
        end
        
        L = X'*X;
          
        %Calculate autovectors/eigenvalues
        [autovectors,eigenvalues] = eig(L);
        [sortedEigenvalues,ind]=sort(diag(eigenvalues),'descend');   % sort eigenvalues
        V=autovectors(:,ind);
        
        %Convert  eigenvalues of X'X in autovectors of X*X'
        autovectors = X*V;
        
        % Normalize autovectors to achieve an unitary length
        for i=1:size(X,2)
            autovectors(:,i) = autovectors(:,i)/norm(autovectors(:,i));
        end
        
        V=autovectors(:,1:2);
        
        %Proyections
        W{1,nIteration}=V'*X;  

        %% Getting numbers from method3 graphics (LUCIANO) and Storing PCA Ratio for chosen ccs
        label=[ones(1, nImgType1), 2*ones(1,nImgType2)];
        [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(W{1,nIteration}',label,2);
        %ratio PCA
        C=sinterluc/sintraluc;
        %ratio pca,cc1,cc2,cc3
        Ratio_pca(:,nIteration)=[trace(C);ccsChosen(:)];

        %% Store eigenvectors
        eigenvectors{nIteration} = V; 
        
        
        
end