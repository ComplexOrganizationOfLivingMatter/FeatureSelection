function [ ] = getSpecialIndividualCells( infoPath, outputPath, additionalDataPath)
%GETSPECIALINDIVIDUALCELLS Summary of this function goes here
%   Detailed explanation goes here

    allFilesInfo = getAllFiles(infoPath);
    allFilesData = getAllFiles(additionalDataPath);
    pathSplitted = strsplit(additionalDataPath, '\');
    typeOfData = pathSplitted{end-1};
    for numFile = 1:size(allFilesData,1)
        fullPathFile = allFilesData{numFile};
        fullPathFileSplitted = strsplit(fullPathFile, '\');
        fileName = fullPathFileSplitted{end};
        
        if isempty(strfind(fileName, '_data.mat')) %Only analyze additional information
            load(fileName);
            fileNameSplitted = strsplit(fileName, '_');
            
            graphletFile = cellfun(@(x) isempty(strfind(x, fileNameSplitted(1:2))) == 0, allFilesInfo);
        end
    end
end

