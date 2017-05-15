classdef FeatureSelectionClass
    %FEATURESELECTIONCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        usedMethod
        expansion
        maxExpansion
        matrixAllCCs
        labels
        ind
    end
    
    methods
        function obj = featureSelectionClass()
            % all initializations, calls to base class, etc. here,
        end
        function obj = executeFeatureSelection(obj, usedCharacteristics)
         
        end
        function obj = crossValidation(obj, maxShuffles, maxFolds)
            resultsOfCrossValidation = cell(maxShuffles, maxFolds);
            for numShuffle = 1:maxShuffles
                indices = crossvalind('Kfold', class1, maxFolds);
                for numFold = 1:maxFolds
                    test = (indices == numFold); train = ~test;
                    class1Train = class1(train);
                    class1Test = class1(test);
                    matrixTrain = obj.matrixAllCCs(train, :);
                    matrixTest = obj.matrixAllCCs(test, :);
                    [valueOfBest, indicesCcsSelected] = FeatureSelection_2_cc(matrixTrain(class1Train, :), matrixTrain(class1Train == 0, :), nameFirstClass, nameSecondClass,usedMethod);
                    resultsOfCrossValidation(numShuffle, numFold) = {valueOfBest, getHowGoodAreTheseCharacteristics(matrixTest(:, indicesCcsSelected), class1Test, weightsOfCharac, usedMethod)};
                end
            end
        end
    end
    
end

