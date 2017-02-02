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
        [Diapositiva,cellnoval]=segmentacion_corte_canal_1(serie,0,cell,rect,Diapositiva);
        if cellnoval==0
            % %% Detection of green nodes
            deteccion_nodos(serie,0,cell,rect)
            % % %Representacion y almacenamiento de datos
            Diapositiva=Representacion_foci(serie,cell,corte_max,rect,Diapositiva);
            Diapositiva=Representacion_Heterocromatina(serie,cell,corte_max,rect,Diapositiva);

            fichero=strcat('Programa_ CC_Networks\Informacion_basica\info_basica_Serie_',serie,'_celula_',cell);
            save(fichero,'serie','corte_max','cell','rect')

            Compro_foci_hetero(serie,cell,corte_max,rect,Diapositiva);
        end
    end
end

