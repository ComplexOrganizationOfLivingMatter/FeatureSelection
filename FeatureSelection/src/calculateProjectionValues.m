function [W, weightsOfCharacteristics, Ratio_pca] = calculateProjectionValues(matrixChosenCcs,nIteration, labels,W,weightsOfCharacteristics,Ratio_pca,ccsChosen, usedMethod)
            
        %Operations to calculate PCA ratio and weight
        X=matrixChosenCcs';
        meanCCs=mean(X,2);
     
        for i = 1:size(X,2)
           X(:,i) = X(:,i) - meanCCs;
        end
        
        L = X'*X;
        
        %Calculate autovectors/eigenvalues
        [eigenvectors,eigenvalues] = eig(L);
        [sortedEigenvalues, ind]=sort(diag(eigenvalues),'descend');   % sort eigenvalues
        V=eigenvectors(:,ind);
        
        %Convert  eigenvalues of X'X in autovectors of X*X'
        eigenvectors = X*V;
        
        % Normalize autovectors to achieve an unitary length
        for i=1:size(X,2)
            eigenvectors(:,i) = eigenvectors(:,i)/norm(eigenvectors(:,i));
        end
        
        V=eigenvectors(:,1:2);
        

        %% Getting numbers from method3 graphics (LUCIANO) and Storing PCA Ratio for chosen ccs
        labelsCat = grp2idx(categorical(labels));
        [goodnessOfMethod, W{1,nIteration}] = getHowGoodAreTheseCharacteristics(matrixChosenCcs, labelsCat, V, usedMethod);

        %ratio pca,cc1,cc2,cc3
        Ratio_pca(:, nIteration)=[goodnessOfMethod; ccsChosen(:)];

        %% Store eigenvectors
        weightsOfCharacteristics{nIteration} = matrixChosenCcs \ W{1, nIteration}; 
end