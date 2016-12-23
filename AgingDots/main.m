%% Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez

dataFiles = getAllFiles('data\WithInvalidArea\');
for numFile = 1:size(dataFiles,1)
    fullPathFile = dataFiles(numFile);
    fullPathFile = fullPathFile{:};
    diagramNameSplitted = strsplit(fullPathFile, '\');
    imgName = diagramNameSplitted(end);
    imgName = imgName{1};
    rawImg = imread(fullPathFile);
    
    
    img = rawImg(:, :, 1) - rawImg(:, :, 3);
    invalidArea = rawImg(:, :, 1) == 0 & rawImg(:, :, 3);
    img2 = im2bw(img(:,:,1), 0.8);
    se = strel('disk', 1);
    imgEroded = imerode(img2, se);
    
    
    imgRegions = regionprops(imgEroded);
    
    % imgAreas = vertcat(imgRegions.Area);
    Centroids = round(vertcat(imgRegions.Centroid));
    
    %Create centroids image and distance matrices for each centroid
    ImgCentroids = zeros(size(img2, 2) , size(img2, 1));
    
    distanceMatrices={};
    
    %left region is label as 1, righ - 2 & top 3
    for i = 1:size(Centroids, 1)
        ImgCentroids(Centroids(i, 2), Centroids(i, 1)) = 1;
        
        mask=zeros(size(img2, 2) , size(img2, 1));
        mask(Centroids(i, 2), Centroids(i, 1)) = 1;
        distanceMatrices{i}=round(bwdist(mask));
        
        %find position of blue point
        [~,Y]=find(invalidArea(Centroids(i, 2), :)==1);
        
        if isempty(Y)
            regionLabel(i)=3;
        elseif Y(1) > Centroids(i, 1)
            regionLabel(i)=2;
        elseif Y(1) < Centroids(i, 1)
            regionLabel(i)=1;
        end
        
        
    end
    
    % find blue max point as reference to calculate distance.
    [X,Y]=find(invalidArea==1);
    mask=zeros(size(img2, 2) , size(img2, 1));
    mask(X(1),Y(1)) = 1;
    distanceMatrixReference=round(bwdist(mask));
    
    %create final distance matrix between dots
    
    distanceMatrixFinal=zeros(size(Centroids, 1));
    
    for i = 1:size(Centroids, 1)
        
        distImg=distanceMatrices{i};
        
        for j = i+1:size(Centroids, 1)
            
            if (regionLabel(i)==1 && regionLabel(j)==2) || (regionLabel(i)==2 && regionLabel(j)==1)
                
                distanceMatrixFinal(i,j)=distanceMatrixReference(Centroids(j, 2), Centroids(j, 1))+distanceMatrixReference(Centroids(i, 2), Centroids(i, 1));
                distanceMatrixFinal(j,i)=distanceMatrixReference(Centroids(j, 2), Centroids(j, 1))+distanceMatrixReference(Centroids(i, 2), Centroids(i, 1));
                
            else
                distanceMatrixFinal(i,j)=distImg(Centroids(j, 2), Centroids(j, 1));
                distanceMatrixFinal(j,i)=distImg(Centroids(j, 2), Centroids(j, 1));
            end
            
        end 
    end
    distanceMatrix = distanceMatrixFinal;
    imageNameSplitted = strsplit(imgName, '.');
    save(strcat('results\distanceMatrix\', imageNameSplitted{1}, '.mat'), 'distanceMatrix');
end


%     imshow(ImgCentroids)
%     for k=1:size(Centroids, 1)
%         c=Centroids(k,:);
%         text(c(1),c(2),sprintf('%d',k),'HorizontalAlignment','center','VerticalAlignment','middle','Color','Green','FontSize',10);
%     end





