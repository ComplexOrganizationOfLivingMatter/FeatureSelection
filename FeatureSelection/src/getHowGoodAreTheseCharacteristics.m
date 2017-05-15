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
    L = L(:, 1:2);
    [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(L, labels, max(labels));
    C = sinterluc/sintraluc;
    goodness = trace(C);
    %clustered = evalclusters(L, labels, 'silhouette');
    %seperated = evalclusters(L, labels, 'CalinskiHarabasz');
    %goodness = clustered.CriterionValues + seperated.CriterionValues/100;
    weights = characteristics \ L;
    projection = characteristics * normalizeVector(weights);
elseif isequal(lower(usedMethod), lower('NCA'))
    %% ----- Neighborhood component analysis (NCA)------%
    mdl = fscnca(characteristics, labels);
    [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(mdl, labels, max(labels));
    C = sinterluc/sintraluc;
    goodness = trace(C);
    %clustered = evalclusters(L, labels, 'silhouette');
    %seperated = evalclusters(L, labels, 'CalinskiHarabasz');
    weights = characteristics \ L;
    projection = characteristics * normalizeVector(weights);
elseif isequal(lower(usedMethod), lower('LogisticRegression'))
    labels = labels - 1 ;
    [b,~,~] = glmfit(characteristics, labels, 'binomial', 'logit'); % Logistic regression
    yfit = 1 ./ (1 + exp(-(b(1) + characteristics * (b(2:end))))); % Same as  yfit = glmval(b, characteristics, 'logit')';
    [resResubCM, ~] = confusionmat(logical(labels), (yfit > 0.5)); %0.35 works better
    sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
    specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
    if (sensitivity < 20 || specifity < 20)
        goodness = min(sensitivity, specifity);
    else
        goodness = specifity*2 + sensitivity*2;
    end
    projection = characteristics * weightsOfCharac;
elseif isequal(lower(usedMethod), lower('DANoProjections'))
    res = fitcdiscr(characteristics, labels');
    resClass = resubPredict(res);
    [resResubCM, ~] = confusionmat(labels', resClass);
    sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
    specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
    
    if (sensitivity < 20 || specifity < 20)
        goodness = min(sensitivity, specifity);
    else
        goodness = pow2(specifity) + pow2(sensitivity);
    end
    
    W = LDA(characteristics, labels');
    L = [ones(size(characteristics, 1), 1) characteristics] * W';
    weights = characteristics \ L;
    projection = characteristics * normalizeVector(weights);
end

end

