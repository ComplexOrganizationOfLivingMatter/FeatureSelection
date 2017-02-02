function [] = pipeline( )
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera

    cd 'E:\Pablo\PhD-miscelanious\DNA-Damage\'
    extractImages();
    
    allFiles = getAllFiles('results\images\');
    
    for numFile = 1:size(allFiles, 1)
        fullPathImage = allFiles{numFile};
        
        [cell,rect]=selectCell(fullPathImage);

        Diapositiva=0;
        segmentacion_corte_canal_2(fullPathImage,1,cell,rect);
        [Diapositiva, cellnoval] = segmentacion_corte_canal_1(fullPathImage,0,cell,rect, Diapositiva);
        if cellnoval==0
            % %% Detection of green nodes
            deteccion_nodos(fullPathImage,0,cell,rect)
            % % %Representacion y almacenamiento de datos
            Diapositiva=Representacion_foci(fullPathImage,cell,corte_max,rect,Diapositiva);
            Diapositiva=Representacion_Heterocromatina(fullPathImage,cell,corte_max,rect,Diapositiva);

            Compro_foci_hetero(fullPathImage, cell, corte_max, rect, Diapositiva);
        end
    end
end

