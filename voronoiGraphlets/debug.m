for numNameTable = 1:size(tableInfo, 1)
    date = tableInfo(numNameTable, 2).File;
    isAtInfoTable = cellfun(@(x) isempty(strfind(date{:}, x)) == 0, names);
    
    if sum(isAtInfoTable) > 0
        indicesSorted(numNameTable, 1) = find(isAtInfoTable == 1);
    end
end