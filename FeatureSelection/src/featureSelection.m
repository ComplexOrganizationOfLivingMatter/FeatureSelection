function featureSelection(matrixAllCCs, labels, usedMethod)
%FEATURESELECTION Summary of process:
% 1-Calculate 10 betters trios
% 2-Compare each individual cc VS each of 10 trios. Getting 5 betters descriptors by trio, with a total of 50 quartets of cc (5x10)
% 3-Repeat process before saving 2 best cc for quartets (5x10x2). Total of 100 quintets
% Finally, adding a 'cc' until 7 ccs or until get lower descriptor of PCA
% than step before.
%
% Developed by Pedro Gomez-Galvez, Pablo Vicente-Munuera and Daniel
% Sanchez-Gutierrez

    %Define expansion in process
    expansion=[10 10 5 1];
    maxExpansion=4; %exted expansion array for more complexity

    %% Parameters Initialization
    
    %Removing uncategorized rows
    labelsCat = grp2idx(categorical(labels));
    labels = labels(isnan(labelsCat) == 0);
    matrixAllCCs = matrixAllCCs(isnan(labelsCat) == 0, :);
    labelsCat = labelsCat(isnan(labelsCat)==0);
    
    %Selection of specified ccs
    totalCharactsIndexes=1:size(matrixAllCCs, 2); %num of columns

    %Number of images and ccs
    n_images = size(matrixAllCCs, 1);
    n_totalCcs=length(totalCharactsIndexes);

    %% Calculate all trios of characteristics
    nIteration=1;
    W={};weightsOfCharacteristics={};Ratio_pca=[];
    for cc1=1:n_totalCcs-2
        for cc2=cc1+1:n_totalCcs-1
            for cc3=cc2+1:n_totalCcs
                %Include trio of ccs for all images
                matrixChosenCcs(:,1:3)=[matrixAllCCs(:,cc1) ,matrixAllCCs(:,cc2),matrixAllCCs(:,cc3)];

                %Normalizing each cc
                for cc=1:3
                    matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)-min(matrixChosenCcs(:,cc));
                    matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)/max(matrixChosenCcs(:,cc));
                end

                %3 cc for all images
                matrixChosenCcs(isnan(matrixChosenCcs))=0;% Do 0 all NaN

                %Calculate proyections, eigenvectors and ratios of PCA
                %accumulative
                [W,weightsOfCharacteristics,Ratio_pca]=calculateProjectionValues(matrixChosenCcs,nIteration, labels, W,weightsOfCharacteristics,Ratio_pca,[cc1,cc2,cc3], usedMethod);

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
    while expansionIndex <= maxExpansion
        expansionIndex
        BetterPCAs_bef=BetterPCAs;
        clear Proy
        [BetterPCAs,Proy, weightsOfCharacteristics]=add_cc(BetterPCAs_bef,matrixAllCCs,expansion(expansionIndex), labels, usedMethod);

        % Sort BetterPCAs from best to worst PCA
        [BetterPCAs rowOrder]=sortrows(BetterPCAs,-1);

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
    bestIterationPCA = BettersPCAEachStep{numIter};
    [bestPCA, numRow] = max(bestIterationPCA(:, 1));
    indicesCcsSelected=bestIterationPCA(numRow, 2:size(bestIterationPCA,2));
    weightsOfCharacteristics = weightsEachStep{numIter};
    weightsOfCharacteristics = weightsOfCharacteristics{numRow};
    Proy = proyEachStep{numIter};
    Proy = Proy{numRow};

    %%Represent Luisma format
    Proyecc=Proy';
    h=figure;
    vColors = [0.0 0.2 0.0
        1.0 0.4 0.0
        0.2 0.8 1.0
        0.0 0.6 0.0
        1.0 0.0 0.0
        0.8 0.8 0.8
        0.2 0.6 0.6
        0.0 0.0 0.6];
    
    for i = 1:max(labelsCat)
        plot(Proyecc(1, labelsCat == i), Proyecc(2, labelsCat == i),'MarkerFaceColor', vColors(i, :), 'Marker', '.','MarkerSize',30, 'LineStyle', 'none')
        hold on;
    end
    
    legend(unique(labels), 'Location', 'Best');
    
    mkdir('results');
    if max(labelsCat) == 2
        [ sensitivity, specifity, classificationResult, AUC, VPpositive, VPnegative] = getSensitivityAndSpecifity(labels , Proyecc);
        save( ['results\' lower(usedMethod) 'FeatureSelection_' strjoin(unique(labels), '_') '_selection_cc_' num2str(n_totalCcs) '_' date ], 'BettersPCAEachStep', 'Proy', 'bestPCA','indicesCcsSelected', 'weightsOfCharacteristics', 'sensitivity', 'specifity', 'classificationResult', 'AUC', 'VPpositive', 'VPnegative');
    else
        save( ['results\' lower(usedMethod) 'FeatureSelection_' strjoin(unique(labels), '_') '_selection_cc_' num2str(n_totalCcs) '_' date ], 'BettersPCAEachStep', 'Proy', 'bestPCA','indicesCcsSelected', 'weightsOfCharacteristics');
    end
    
    stringres=strcat(num2str(indicesCcsSelected), ' - Descriptor: ', num2str(bestPCA));
    title(stringres)
    saveas(h,['results\' lower(usedMethod) 'FeatureSelection_' strjoin(unique(labels), '_') '_selection_cc_' num2str(n_totalCcs) '_' date '.jpg'])

    close all
end

