function [ weightCC ] = calculateWeightOfSelectedCC( OriginalMatrix, Points, indices_cc_seleccionadas )
%UNTITLED Summary of this function goes here
%   Thanks to Pedro Gomez-Galvez
    
    OriginalMatrix = OriginalMatrix(:, indices_cc_seleccionadas);
    OriginalMatrix(isnan(OriginalMatrix))=0;
    
    OriginalMatrix = OriginalMatrix - min(OriginalMatrix(:));
    OriginalMatrix = OriginalMatrix / max(OriginalMatrix(:));
    OriginalMatrix = bsxfun(@minus, OriginalMatrix, mean(OriginalMatrix, 1));
    
    for y = 1:size(Points, 1)
        Points(y, :) = Points(y, :)/norm(Points(y, :));
    end
    
    weightCC = OriginalMatrix' * Points';
end

