library("R.matlab", lib.loc="~/R/win-library/3.3")
matFile = readMat('../../PhD-miscelanious/voronoiGraphlets/results/comparisons/EveryFile/maxLength5/polygonDistributionDistanceMatrix.mat')
distanceMatrix <- matFile$distanceMatrix
points <- cmdscale(distanceMatrix, 2)
points1Dimension <- points[, 1]
writeMat('../../PhD-miscelanious/voronoiGraphlets/results/comparisons/EveryFile/maxLength5/polygonDistribution1DimensionMaxLength5.mat', points=points, points1Dimension=points1Dimension)