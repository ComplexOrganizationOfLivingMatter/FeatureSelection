function [ sensitivity, specifity, res, AUC, VPpositive, VPnegative] = getSensitivityAndSpecifity( categorization, , projection)
%GETSENSITIVITYANDSPECIFITY Summary of this function goes here
%   Detailed explanation goes here

res = fitcdiscr(projection', categorization');
resClass = resubPredict(res);
[resResubCM, ~] = confusionmat(categorization', resClass);
bad = ~strcmp(resClass, categorization');
hold on;
projection = projection';
plot(projection(bad,1), projection(bad,2), 'kx');
hold off;

sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
[~, score] = resubPredict(res);
[~, ~, ~, AUC] = perfcurve(res.Y, score(:, 2), categorization(1));

VPpositive = resResubCM(2, 2) / (resResubCM(2, 2) + resResubCM(1, 2)) * 100;
VPnegative = resResubCM(1, 1) / (resResubCM(1, 1) + resResubCM(2, 1)) * 100;
end

