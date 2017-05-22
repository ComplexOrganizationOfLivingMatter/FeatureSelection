%% --------------- Cross validation ------------- %%
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Risk);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
class1 = cellfun(@(x) isequal('NoRisk', x), matrix2.Risk);
labelsUsed = matrix2.Risk;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftc = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
ftc.expansion = [1 1 1 1];
ftc.crossValidation(100, 5);

%You can either, get the best of them
res = resultsOfCrossValidation;
max(cellfun(@(x) x{1} +  x{3}, res(:, 2)))
find(cellfun(@(x) x{1} +  x{3}, res(:, 2)) == 2)
%Or get what is the most common combination
combinationOfWinners = cellfun(@(x) x{2}, resultsOfCrossValidation, 'UniformOutput', false);
meanOfGoodness = cellfun(@(x) x{1} + x{3}, resultsOfCrossValidation);
combinationOfWinners_perRowWithNaNs = padcat(combinationOfWinners{:});
meanOfGoodness = vertcat(meanOfGoodness(:));
combinationOfWinners_perRowWithZeros = combinationOfWinners_perRowWithNaNs;
combinationOfWinners_perRowWithZeros(isnan(combinationOfWinners_perRowWithZeros)) = 0;
combinationOfWinners_perRowWithZerosSorted = sort(combinationOfWinners_perRowWithZeros, 2);
[combinationOfWinners_perRowWithZerosSorted, indices1] = sortrows(combinationOfWinners_perRowWithZerosSorted, 1);
meanOfGoodness = meanOfGoodness(indices1);
[C , ia, ic] = unique(combinationOfWinners_perRowWithZerosSorted,'rows');
countCommonCombo = histc(ic, 1:size(C, 1));
[num, index] = max(countCommonCombo);
combinationOfWinners_perRowWithZerosSorted(ic == index, :)
mean(meanOfGoodness(ic == index))
%Get the best combination with at least 10 repetitions
combinationOfWinnersFinal = horzcat(combinationOfWinners_perRowWithZerosSorted, meanOfGoodness);
iaMeanGoodness = arrayfun(@(x) mean(meanOfGoodness(ic == x)), ia)';
iaIndices = find(countCommonCombo > 10);
[num, index] = max(iaMeanGoodness(countCommonCombo > 10));
combinationOfWinnersFinal(ic == iaIndices(index), 1:7)
%Or even get what are the most common characteristics
[C , ia, ic] = unique(combinationOfWinners_perRowWithNaNs);
countCommonChar = histc(ic, 1:size(C, 1));
[sorted, indices] = sort(countCommonChar, 'descend');
C(indices(1:7))
sorted(1:7) %times of repetion
allGoodnessPerCharacteristic = zeros(size(matrixChar, 2), 1);
for numChar = 1:size(matrixChar, 2)
    actualMeanGoodness = 0;
    for numCombination = 1:size(combinationOfWinnersFinal, 1)
        if sum(ismember(numChar, combinationOfWinnersFinal(numCombination, 1:7))) > 0
            actualMeanGoodness = actualMeanGoodness + combinationOfWinnersFinal(numCombination, 8);
        end
    end
    allGoodnessPerCharacteristic(numChar) = actualMeanGoodness / countCommonChar(numChar);
end
allGoodnessPerCharacteristic(indices(1:7))

