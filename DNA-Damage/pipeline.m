function [] = pipeline( )
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera

    cd 'E:\Pablo\PhD-miscelanious\DNA-Damage\'
    allImages = getAllFiles('data/images/');

    previousSerie = '';
    %A big number because of the final if of the for
    previousNumChannel = 20;

    imagesOfSerieByChannel = {};
    numChannel = 0;
    for fileIndex = 1:size(allImages)
        fullPathImage = allImages{fileIndex};
        fileNameSplitted = strsplit(fullPathImage, '\');
        fileName = fileNameSplitted{end};
        dirName = fileNameSplitted{end-1};

        %Check if it's another Serie of images
        if isequal(previousSerie, fileName(1:9)) == 0
            if isequal(previousSerie, '') == 0
                outputDir = strcat('results\', dirName);
                mkdir(outputDir);
                save(strcat(outputDir, '\', previousSerie), 'imagesOfSerieByChannel');
                imagesOfSerieByChannel = {};
            end
            previousSerie = fileName(1:9);
        end

        img = imread(fullPathImage);
        img = im2double(img);

        %Select the channel
        if isempty(strfind(lower(fileName), lower('ch00'))) == 0
            numChannel = 1;
        elseif isempty(strfind(lower(fileName), lower('ch01'))) == 0
            numChannel = 2;
        end

        if previousNumChannel < numChannel
            imagesOfSerieByChannel{end, numChannel} = img(:,:, :);
        else
            imagesOfSerieByChannel{end+1, numChannel} = img(:,:, :);
        end
        previousNumChannel = numChannel;
    end

end

