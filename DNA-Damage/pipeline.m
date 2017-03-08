function [] = pipeline( )
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera
    

    cd 'D:\Pablo\PhD-miscelanious\DNA-Damage\'
    extractImages();
    
    allFiles = getAllFiles('results\images\');
    
    for numFile = 1:size(allFiles, 1)
        close all
        allFiles{numFile}
        fullPathImage = allFiles{numFile};
        
        nameFileSplitted = strsplit(fullPathImage, '\');
        directory = strcat(nameFileSplitted{1}, '\segmentation\', nameFileSplitted{3});
        nameFileSplittedNoExtension = strsplit(nameFileSplitted{end}, '.');
        nameFileSplittedNoExtension = nameFileSplittedNoExtension{1};
        firstOuputFile = strcat(directory, '\', nameFileSplittedNoExtension, 'Proyeccion_General_3D_FOCI-VERDE-2.tiff');
        %if exist(firstOuputFile, 'file') ~= 2
            [cell,rect]=selectCell(fullPathImage);

            Diapositiva=0;
            segmentacion_corte_canal_2(fullPathImage,1,cell,rect);
            [Diapositiva, cellnoval] = segmentacion_corte_canal_1(fullPathImage,0,cell,rect, Diapositiva);
            if cellnoval==0
                % %% Detection of green nodes
                deteccion_nodos(fullPathImage,0,cell,rect)
                % % %Representacion y almacenamiento de datos
                Diapositiva=Representacion_foci(fullPathImage, cell, rect, Diapositiva);
                Diapositiva=Representacion_Heterocromatina(fullPathImage, cell, rect, Diapositiva);
                
                Compro_foci_hetero(fullPathImage, cell, rect, Diapositiva);
            end
            
    %end
    end
end

