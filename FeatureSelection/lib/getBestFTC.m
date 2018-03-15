function [ ftc ] = getBestFTC( ftc )
%GETBESTFTC Summary of this function goes here
%   Detailed explanation goes here


    for numCombination = 1:length(ftc)
        actualFTC = ftc{numCombination};
        bestValue = 0;
        best = 1;
        for numFTC = 1:length(actualFTC)
            if (actualFTC{numFTC}.bestDescriptor) >= bestValue
                if (actualFTC{numFTC}.bestDescriptor > bestValue) || (bestValue == 1 && length(actualFTC{best}.ccsSelected) > length(actualFTC{numFTC}.ccsSelected))
                    best = numFTC;
                    bestValue = actualFTC{numFTC}.bestDescriptor;
                end
            end
        end
        ftc{numCombination} = actualFTC{best};
    end

end

