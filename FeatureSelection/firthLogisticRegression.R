
#https://stats.stackexchange.com/questions/11109/how-to-deal-with-perfect-separation-in-logistic-regression
characteristics <- file;
x <- as.matrix(characteristics)
y <- as.matrix(predictors)
( m2 <- brglm(y ~ x[, 1] + x[, 2] + x[, 3] + x[, 4] + x[, 5] + x[, 6] + x[, 7], family = binomial(logit)) )
m3 <- logistf(y ~ x[, 1] + x[, 2] + x[, 3] + x[, 4] + x[, 5] + x[, 6] + x[, 7], family = binomial(logit)) 
mOriginal <- glm(y ~ x[, 1] + x[, 2] + x[, 3] + x[, 4] + x[, 5] + x[, 6] + x[, 7], family = binomial(logit))
summary(m2)
confint.default(m2)

model <- mOriginal
data <- characteristics

#https://gist.github.com/ryanwitt/2911560
prediction <- ifelse(predict(model, data, type='response') > 0.5, TRUE, FALSE)
confusion  <- table(prediction, as.logical(model$y))
confusion  <- cbind(confusion, c(1 - confusion[1,1]/(confusion[1,1]+confusion[2,1]), 1 - confusion[2,2]/(confusion[2,2]+confusion[1,2])))
confusion  <- as.data.frame(confusion)
names(confusion) <- c('FALSE', 'TRUE', 'class.error')
confusion