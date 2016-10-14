%Developed by Pablo Vicente-Munuera

dataFiles = getAllFiles('data\voronoiDiagrams\');
for numFile = 1:size(dataFiles,1)
    fullPathFile = dataFiles(numFile);
    fullPathFile = fullPathFile{:};
    diagramName = strsplit(fullPathFile, '\');
    diagramName = diagramName(10);
    
    if size(strfind(lower(diagramName), '.mat'), 1) >= 1
        load(fullPathFile);
        
        
    end
end