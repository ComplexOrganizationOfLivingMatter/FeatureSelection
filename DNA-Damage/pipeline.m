function [] = pipeline( )
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera

    cd 'E:\Pablo\PhD-miscelanious\DNA-Damage\'
    allImages = getAllFiles('data/images/');

    for fileIndex = 1:size(allImages)
        fullPathImage = allImages{fileIndex};
        fileNameSplitted = strsplit(fullPathImage, '\');
        fileName = fileNameSplitted{end};
        
        if isempty(strfind(lower(fileName), lower(''))) == 0
            
        end
    end

end

