%Developed by Pablo Vicente-Munuera

createNetworksFromVoronoiDiagrams('E:\Pablo\PhD-miscelanious\voronoiNetworks\data\voronoiDiagrams\');

cd 'E:\Pablo\PhD-miscelanious\voronoiNetworks\results\networks';
calculateLEDAFilesFromDirectory();

analyzeGraphletDistances('E:\Pablo\PhD-miscelanious\voronoiNetworks\results\distanceMatrix\');

%-------------------- biologicalImages ---------------------%
Calculate_neighbors_polygon_distribution('E:\Pablo\PhD-miscelanious\voronoiNetworks\data\biologicalImages\');

createNetworksFromVoronoiDiagrams('E:\Pablo\PhD-miscelanious\voronoiNetworks\data\biologicalImages\');
cd 'E:\Pablo\PhD-miscelanious\voronoiNetworks\results\networks';
calculateLEDAFilesFromDirectory();

analyzeGraphletDistances('E:\Pablo\PhD-miscelanious\voronoiNetworks\results\distanceMatrix\');

easyHeatmap(distanceMatrixMean, namesSortedOut, 'heatmap', 'data')