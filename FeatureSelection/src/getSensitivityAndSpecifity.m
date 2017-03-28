function [ sensitivity, specifity, res] = getSensitivityAndSpecifity( length_t1, name_t1, totalImages, name_t2, projection)
%GETSENSITIVITYANDSPECIFITY Summary of this function goes here
%   Detailed explanation goes here
categorization(1:length_t1) = {name_t1};
categorization(length_t1+1 : totalImages) = {name_t2};
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
end

