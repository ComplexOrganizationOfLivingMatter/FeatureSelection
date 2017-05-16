%% --------------- Cross validation ------------- %%
labelsUsed = matrix2.Risk;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftc.expansion = [1 1 1 1];
res = ftc.crossValidation(100, 5);

%You can either, get the best of them
find(cellfun(@(x) x{1} +  x{3}, res(:, 3)) > 787.5)
%Or get what is the most common combination
combinationOfWinners = cellfun(@(x) x{2}, resultsOfCrossValidation, 'UniformOutput', false);
combinationOfWinners_perRowWithNaNs = padcat(combinationOfWinners{:});
combinationOfWinners_perRowWithZeros = combinationOfWinners_perRowWithNaNs;
combinationOfWinners_perRowWithZeros(isnan(combinationOfWinners_perRowWithZeros)) = 0;
combinationOfWinners_perRowWithZerosSorted = sort(combinationOfWinners_perRowWithZeros, 2);
combinationOfWinners_perRowWithZerosSorted = sort(combinationOfWinners_perRowWithZerosSorted, 1);
[C , ia, ic] = unique(combinationOfWinners_perRowWithZerosSorted,'rows');
countCommonCombo = histc(ic, 1:size(C, 1));
[num, index] = max(countCommonCombo);
combinationOfWinners_perRowWithZerosSorted(ic == index, :)
%Or even get what are the most common characteristics
[C , ia, ic] = unique(combinationOfWinners_perRowWithNaNs);
countCommonChar = histc(ic, 1:size(C, 1));
[sorted, indices] = sort(countCommonChar, 'descend');
C(indices(1:7))
sorted(1:7) %times of repetion