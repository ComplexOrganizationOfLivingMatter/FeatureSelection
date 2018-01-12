classdef FeatureSelectionClass
    %FEATURESELECTIONCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Properties of feature selection
        usedMethod
        expansion
        maxExpansion
        initialMatrix
        matrixAllCases
        labels
        usedCharacteristics
        featuresNames
        preSelectedFeature
        worstCondition
        %Results of execution
        indicesCcsSelected
        ccsSelected
        projection
        weightsOfCharacteristics
        bestDescriptor
        sensitivity
        specificity
        BettersPCAEachStep
        featuresMeans
    end
    
    methods
        function obj = FeatureSelectionClass(labels, matrixAllCCs, usedMethod, usedCharacteristics, columnNames, condition)
            % all initializations, calls to base class, etc. here,
            %Define expansion in process
%             obj.expansion=[1 1 1 1];
%             obj.maxExpansion=3; %exted expansion array for more complexity
            obj.expansion=[10 10 5 1];
            obj.maxExpansion=4; %exted expansion array for more complexity
            obj.usedCharacteristics = usedCharacteristics;
            obj.labels = labels;
            obj.featuresNames = columnNames;
            obj.worstCondition = condition;
            obj.initialMatrix = matrixAllCCs;
            obj.matrixAllCases = matrixAllCCs;
            obj.usedMethod = usedMethod;
            obj.matrixAllCases(isnan(obj.matrixAllCases) )= 0;% Do 0 all NaN
            obj.preSelectedFeature = -1;
            obj.featuresMeans = [];
            %normalize matrixes
            for charac=1:size(obj.matrixAllCases,2)
                obj.matrixAllCases(:,charac)=obj.matrixAllCases(:,charac)-min(obj.matrixAllCases(:,charac));
                obj.matrixAllCases(:,charac)=obj.matrixAllCases(:,charac)/max(obj.matrixAllCases(:,charac));
            end
            obj.matrixAllCases(isnan(obj.matrixAllCases))=0;% 0 NaNs
        end
        
        function [W, weightsOfCharacteristics, Ratio_pca] = calculateProjectionValues(obj, matrixChosenCcs,nIteration, labels,W,weightsOfCharacteristics,Ratio_pca,ccsChosen, usedMethod)
            
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
        
        function [BetterPCAs,Proy, eigenvectorsF] = add_cc(obj, BetterPCAs_bef, matrixAllCCs, expansion, labels, usedMethod)
            count=0;
            Niteration=1;
            BetterPCAs=[];
            for rowCCs=1:size(BetterPCAs_bef,1)
                W={};eigenvectors={};Ratio_pca=[];
                ccsRow=BetterPCAs_bef(rowCCs,2:size(BetterPCAs_bef,2));
                
                for nCC=1:size(matrixAllCCs,2)
                    matrixChosenCcs = matrixAllCCs(:,ccsRow);
                    if sum(nCC == ccsRow) == 0
                        p1=sum(matrixAllCCs(:,nCC));
                        % all ccs nan or 0. PCA & eigenvectors = 0
                        if p1==0
                            Ratio_pca(1:2,Niteration)=[0,nCC];
                            eigenvectors{1,Niteration} = 0;
                        else
                            
                            %Include CC to CCs before
                            matrixChosenCcs = [matrixChosenCcs,matrixAllCCs(:,nCC)];
                            
                            %normalize matrixes
                            for charac=1:size(matrixChosenCcs,2)
                                matrixChosenCcs(:,charac)=matrixChosenCcs(:,charac)-min(matrixChosenCcs(:,charac));
                                matrixChosenCcs(:,charac)=matrixChosenCcs(:,charac)/max(matrixChosenCcs(:,charac));
                            end
                            matrixChosenCcs(isnan(matrixChosenCcs))=0;% 0 NaNs
                            
                            %% PCA
                            [W,eigenvectors,Ratio_pca] = obj.calculateProjectionValues(matrixChosenCcs, Niteration, labels, W, eigenvectors, Ratio_pca, [ccsRow,nCC], usedMethod);
                            
                        end
                        Niteration=Niteration+1;
                    end
                end
                
                
                
                
                %% Expansion without repetition
                auxiliar=Ratio_pca(1,:);
                for i=1:expansion
                    %If there are more than a row, check repeated vectors of ccs
                    if isempty(BetterPCAs)==0
                        [~, maxPcaIndex]=max(auxiliar);
                        newPCARow=Ratio_pca(:,maxPcaIndex)';
                        
                        %Checked former rows comparing with new row
                        r=1;
                        while r<size(BetterPCAs,1)+1
                            if length(find(sort(BetterPCAs(r,2:end))==sort(newPCARow(1,2:end))))==size(BetterPCAs,2)-1
                                auxiliar(1,maxPcaIndex)=0;
                                [~, maxPcaIndex]=max(auxiliar);
                                newPCARow=Ratio_pca(:,maxPcaIndex)';
                                r=1;
                            else
                                r=r+1;
                            end
                        end
                        %add if different row exist
                        if isempty(newPCARow)==0
                            BetterPCAs(count+i,1)=Ratio_pca(1,maxPcaIndex);
                            for j=2:size(BetterPCAs_bef,2)
                                BetterPCAs(count+i,j)=BetterPCAs_bef(rowCCs,j);
                            end
                            BetterPCAs(count+i,size(BetterPCAs_bef,2)+1)=Ratio_pca(end,maxPcaIndex);
                            Proy{count+i,1}=W{1,maxPcaIndex};
                            eigenvectorsF{count+i,1} = eigenvectors{1, maxPcaIndex};
                            auxiliar(1,maxPcaIndex)=0;
                        end
                        
                        %When BetterPCAs isempty add row
                    else
                        [BetterPCAs(count+i,1) maxPcaIndex]=max(auxiliar);
                        
                        for j=2:size(BetterPCAs_bef,2)
                            BetterPCAs(count+i,j)=BetterPCAs_bef(rowCCs,j);
                        end
                        BetterPCAs(count+i,size(BetterPCAs_bef,2)+1)=Ratio_pca(end,maxPcaIndex);
                        Proy{count+i,1}=W{1,maxPcaIndex};
                        eigenvectorsF{count+i,1} = eigenvectors{1, maxPcaIndex};
                        auxiliar(1,maxPcaIndex)=0;
                        
                    end
                end
                
                
                count=count+expansion;
                clear W Ratio_pca
            end
            
            BetterPCAs(BetterPCAs(:, 1) <= 0, :) = [];
        end
        
        function obj = executeFeatureSelection(obj, usedCases)
            usedCases = usedCases == 1;
            %Removing uncategorized rows
            labelsCat = grp2idx(categorical(obj.labels));
            usedLabels = obj.labels(isnan(labelsCat) == 0);
            usedMatrix = obj.matrixAllCases(isnan(labelsCat) == 0, obj.usedCharacteristics);
            
            %Filtering by usedCases
            usedLabels = usedLabels(usedCases);
            usedMatrix = usedMatrix(usedCases, :);
            
            %Selection of specified ccs
            totalCharactsIndexes=1:size(usedMatrix, 2); %num of columns
            
            %Number of images and ccs
            n_totalCcs=length(totalCharactsIndexes);
            
            %% Calculate all trios of characteristics
            nIteration=1;
            W={};weightsOfCharacteristics={};Ratio_pca=[];
            if obj.preSelectedFeature ~= -1
                recorringFeatures = 3;
                offset = 0;
            else
                recorringFeatures = n_totalCcs;
                offset = 1;
            end
            
            for cc1=1:recorringFeatures - 2
                for cc2=cc1+offset:n_totalCcs-1
                    for cc3=cc2+1+offset:n_totalCcs
                        %Include trio of ccs for all images
                        if obj.preSelectedFeature ~= -1
                            cc1 = find(arrayfun(@(x) isequal(x, obj.preSelectedFeature), obj.usedCharacteristics));
                        end
                        
                        matrixChosenCcs(:,1:3)=[usedMatrix(:,cc1) ,usedMatrix(:,cc2),usedMatrix(:,cc3)];
                        
                        %Normalizing each cc
                        for cc=1:3
                            matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)-min(matrixChosenCcs(:,cc));
                            matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)/max(matrixChosenCcs(:,cc));
                        end
                        
                        %3 cc for all images
                        matrixChosenCcs(isnan(matrixChosenCcs))=0;% Do 0 all NaN
                        
                        %Calculate proyections, eigenvectors and ratios of PCA
                        %accumulative
                        [W,weightsOfCharacteristics,Ratio_pca] = obj.calculateProjectionValues(matrixChosenCcs,nIteration, usedLabels, W, weightsOfCharacteristics, Ratio_pca,[cc1,cc2,cc3], obj.usedMethod);
                        
                        %counter + 1
                        nIteration=nIteration+1;
                        
                    end
                end
            end
            
            %% Filtering best 10 PCA and their 3 ccs
            auxiliar=Ratio_pca(1,:)';
            nOfBest=10;
            [~, indexBetter]=sort(auxiliar,'descend');
            indexBetter=indexBetter(1:nOfBest);
            BetterPCAs(1:nOfBest,1:4)=[Ratio_pca(1,indexBetter);Ratio_pca(2,indexBetter);Ratio_pca(3,indexBetter);Ratio_pca(4,indexBetter)]';
            best_weights = weightsOfCharacteristics(indexBetter);
            weightsOfCharacteristics = best_weights;
            Proy=W(1,indexBetter);
            
            
            %% Expansion
            
            expansionIndex=1;
            
            
            BettersPCAEachStep{1} = BetterPCAs;
            weightsEachStep{1} = best_weights;
            proyEachStep{1} = Proy';
            
            %Max of 4 expansions.
            while expansionIndex <= obj.maxExpansion
                expansionIndex
                BetterPCAs_bef=BetterPCAs;
                clear Proy
                [BetterPCAs,Proy, weightsOfCharacteristics] = obj.add_cc(BetterPCAs_bef,usedMatrix, obj.expansion(expansionIndex), usedLabels, obj.usedMethod);
                
                % Sort BetterPCAs from best to worst PCA
                [BetterPCAs, rowOrder]=sortrows(BetterPCAs,-1);
                
                for i=1:size(rowOrder,1)
                    Proyb{i,1}=Proy{rowOrder(i),1};
                    weightssb{i,1} = weightsOfCharacteristics(rowOrder(i), 1);
                end
                Proy=Proyb;
                weightsOfCharacteristics = weightssb;
                clear eigenvectorsb
                clear Proyb
                
                %expansion counter
                expansionIndex=expansionIndex+1;
                
                BettersPCAEachStep{expansionIndex} = BetterPCAs;
                weightsEachStep{expansionIndex} = weightsOfCharacteristics;
                proyEachStep{expansionIndex} = Proy;
            end
            
            %% Final evaluation
            [~, numIter] = max(cellfun(@(x) max(x(:,1)), BettersPCAEachStep));
            obj.BettersPCAEachStep = BettersPCAEachStep;
            bestIterationPCA = BettersPCAEachStep{numIter};
            [obj.bestDescriptor, numRow] = max(bestIterationPCA(:, 1));
            obj.indicesCcsSelected = obj.usedCharacteristics(bestIterationPCA(numRow, 2:size(bestIterationPCA,2)));
            obj.ccsSelected = obj.featuresNames(obj.indicesCcsSelected);
            weightsOfCharacteristics = weightsEachStep{numIter};
            obj.weightsOfCharacteristics = weightsOfCharacteristics{numRow};
            if iscell(obj.weightsOfCharacteristics)
                obj.weightsOfCharacteristics = obj.weightsOfCharacteristics{1};
            end
            Proy = proyEachStep{numIter};
            obj.projection = Proy{numRow};
            labelsCat = grp2idx(categorical(usedLabels));
            [~, ~, obj.sensitivity, obj.specificity] = getHowGoodAreTheseCharacteristics(usedMatrix(:, bestIterationPCA(numRow, 2:size(bestIterationPCA,2))), labelsCat, obj.weightsOfCharacteristics, obj.usedMethod);
            
            obj.featuresMeans = obj.getFeaturesMeans();
            disp('------done------')
        end
        
        function resultsOfCrossValidation = crossValidation(obj, maxShuffles, maxFolds)
            resultsOfCrossValidation = cell(maxShuffles, maxFolds);
            labels = obj.labels;
            parfor numShuffle = 1:maxShuffles
                numShuffle
                indices = crossvalind('Kfold', labels, maxFolds);
                for numFold = 1:maxFolds
                    testSet = (indices == numFold); trainSet = ~testSet;
                    objResults = obj.executeFeatureSelection(trainSet);
                    
                    labelsTest = objResults.labels(testSet);
                    matrixTest = objResults.matrixAllCases(testSet, :);
                    %Removing uncategorized rows
                    labelsTestCat = grp2idx(categorical(labelsTest));
                    labelsTest = objResults.labels(isnan(labelsTestCat) == 0);
                    matrixTest = matrixTest(isnan(labelsTestCat) == 0, objResults.indicesCcsSelected);
                    labelsTestCat = grp2idx(categorical(labelsTest));
                    
                    resultsOfCrossValidation(numShuffle, numFold) = {{objResults.bestDescriptor, objResults.indicesCcsSelected, getHowGoodAreTheseCharacteristics(matrixTest, labelsTestCat, objResults.weightsOfCharacteristics, objResults.usedMethod)}};
                end
            end
            save(['results\crossValidation_', num2str(maxShuffles), '_', num2str(maxFolds), '_With', obj.usedMethod, '_', strjoin(unique(obj.labels), '_'), '_', date], 'resultsOfCrossValidation');
        end
        
        function saveResults(obj)
            %%Represent Luisma format
            Proyecc=obj.projection';
            h=figure;
            vColors = [0.0 0.2 0.0
                1.0 0.4 0.0
                0.2 0.8 1.0
                0.0 0.6 0.0
                1.0 0.0 0.0
                0.8 0.8 0.8
                0.2 0.6 0.6
                0.0 0.0 0.6];
            
            labelsCat = grp2idx(categorical(obj.labels));
            for i = 1:max(labelsCat)
                plot(Proyecc(1, labelsCat == i), Proyecc(2, labelsCat == i),'MarkerFaceColor', vColors(i, :), 'Marker', '.','MarkerSize',30, 'LineStyle', 'none')
                hold on;
            end
            
            legend(unique(obj.labels), 'Location', 'Best');
            
            mkdir('results');
            if max(labelsCat) == 2
                [ sensitivity, specificity, classificationResult, AUC, VPpositive, VPnegative] = getSensitivityAndSpecifity(obj.labels , Proyecc);
                save( ['results\' lower(obj.usedMethod) 'FeatureSelection_' strjoin(unique(obj.labels), '_') '_selection_cc_' num2str(size(obj.matrixAllCases, 1)) '_' date ], 'obj', 'classificationResult');
            else
                save( ['results\' lower(obj.usedMethod) 'FeatureSelection_' strjoin(unique(obj.labels), '_') '_selection_cc_' num2str(size(obj.matrixAllCases, 1)) '_' date ], 'obj');
            end
            
            stringres=strcat(num2str(obj.indicesCcsSelected), ' - Descriptor: ', num2str(obj.bestDescriptor));
            title(stringres)
            saveas(h,['results\' lower(obj.usedMethod) 'FeatureSelection_' strjoin(unique(obj.labels), '_') '_selection_cc_' num2str(size(obj.matrixAllCases, 1)) '_' date '.jpg'])
            
            close all
        end
        
        function [ res,  bestFeatures, indicesNames] = getBestFeatures(obj, numBestFeatures)
            %GETBESTFEATURES Summary of this function goes here
            %   Detailed explanation goes here
            res = [];
            noRiskLabels = cellfun(@(x) isequal(x, obj.worstCondition), obj.labels);
            for idChar = obj.usedCharacteristics
                [ goodness, ~, sensitivity1, specificity1] = getHowGoodAreTheseCharacteristics(obj.matrixAllCases(:, idChar), noRiskLabels + 1, -1, 'LogisticRegression');
                [h,p,~,~] = ttest2(obj.initialMatrix(noRiskLabels == 0, idChar), obj.initialMatrix(noRiskLabels, idChar), 'Vartype', 'unequal', 'Alpha', 0.1);
                res(idChar, :) = [idChar, specificity1, sensitivity1, 1 - goodness, p, h];
            end
            res(res(:, 1) == 0, :) = [];
            [res, indices] = sortrows(res, 4);
            indicesNames = obj.featuresNames(obj.usedCharacteristics(indices));
            
            bestFeatures = obj.usedCharacteristics(indices(1:numBestFeatures));
        end
        
        function [featuresMeans] = getFeaturesMeans(obj)
            featuresMeans = [];
            noRiskLabels = cellfun(@(x) isequal(x, obj.worstCondition), obj.labels);
            featuresMeans(:, 1) = obj.indicesCcsSelected;
            featuresMeans(:, 2) = mean(obj.initialMatrix(noRiskLabels, obj.indicesCcsSelected))';
            featuresMeans(:, 3) = std(obj.initialMatrix(noRiskLabels, obj.indicesCcsSelected))';
            featuresMeans(:, 4) = mean(obj.initialMatrix(noRiskLabels == 0, obj.indicesCcsSelected))';
            featuresMeans(:, 5) = std(obj.initialMatrix(noRiskLabels == 0, obj.indicesCcsSelected))';
            [~,p,~,~] = ttest2(obj.initialMatrix(noRiskLabels == 0, obj.indicesCcsSelected), obj.initialMatrix(noRiskLabels, obj.indicesCcsSelected), 'Vartype', 'unequal');
            featuresMeans(:, 6) = p';
        end
    end
end

