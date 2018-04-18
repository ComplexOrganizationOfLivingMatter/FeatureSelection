characteristics <- file;
x <- as.matrix(characteristics)
y <- as.matrix(predictors)
( m2 <- brglm(y ~ x[, 1] + x[, 2] + x[, 3] + x[, 4] + x[, 5] + x[, 6] + x[, 7], family = binomial(logit)) )
summary(m2)
confint.default(m2)