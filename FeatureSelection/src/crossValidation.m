function [ resultsOfCrossValidation ] = crossValidation(matrixAllCases, maxShuffles, maxFolds, nameFirstClass, nameSecondClass, usedMethod)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
    resultsOfCrossValidation = cell(maxShuffles, maxFolds);
    for numShuffle = 1:maxShuffles
        indices = crossvalind('Kfold', class1, maxFolds);
        for numFold = 1:maxFolds
            test = (indices == numFold); train = ~test;
            class1Train = class1(train);
            class1Test = class1(test);
            matrixTrain = matrixAllCases(train, :);
            matrixTest = matrixAllCases(test, :);
            [bestPCA, indicesCcsSelected] = FeatureSelection_2_cc(matrixTrain(class1Train, :), matrixTrain(class1Train == 0, :), nameFirstClass, nameSecondClass,usedMethod);
            resultsOfCrossValidation(numShuffle, numFold) = {bestPCA, getHowGoodAreTheseCharacteristics(matrixTest(:, indicesCcsSelected), class1Test, weightsOfCharac, usedMethod)};
        end
    end
end

