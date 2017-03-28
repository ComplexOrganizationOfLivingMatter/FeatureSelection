function [ goodness, projection ] = getHowGoodAreTheseCharacteristics(characteristics, labels, weightsOfCharac, usedMethod)
%GETHOWGOODARETHESECHARACTERISTICS Summary of this function goes here
%   Detailed explanation goes here
if isequal(lower(usedMethod), lower('PCA'))
    %% ---- PCA feature selection -----%
    % Luciano's Method: As grouped and clusters go further from each other
    % the better.
    projection = characteristics * weightsOfCharac;
    [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(projection, labels, 2);
    C = sinterluc/sintraluc;
    goodness = trace(C);
elseif isequal(lower(usedMethod), lower('DA'))
    %% ----- Discriminant analysis feature selection ------%
    W = LDA(characteristics, labels');
    L = [ones(size(characteristics, 1), 1) characteristics] * W';
    [~, sintraluc, sinterluc, ~, ~] = valid_sumsqures(L, labels, 2);
    C = sinterluc/sintraluc;
    goodness = trace(C);
    weights = characteristics \ L;
    projection = characteristics * weights;
end
%     %% ---- TuMetodo ----%
%     res = fitcdiscr(characteristics, labels');
%     resClass = resubPredict(res);
%     [resResubCM, ~] = confusionmat(labels', resClass);
%     sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
%     specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
%     
%     if (sensitivity < 20 || specifity < 20)
%         goodness = min(sensitivity, specifity);
%     else
%         goodness = pow2(specifity) + pow2(sensitivity);
%     end
end

