%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoi = importdata('test/Imagen_1_Diagrama_2_Vonoroi_1.mat');
voronoiNoise = importdata('test/Imagen_1_Diagrama_2_Vonoroi_Noise.mat');

verticesV = corner(voronoi, 100000);
verticesVNoise = corner(voronoiNoise, 100000);


edgesZ


distancesVertices = pdist([verticesV; verticesVNoise]);
distanceVertices = squareform(distancesVertices);