function [nameList, uniqueNameList] = BuildNameList(dd)
    nameList = zeros(1,length(dd));
    for i = 1:length(dd)
        nom = dd(i).name; 
        nameList(i) = string(nom(1:11));    % takes first eleven characters of filename and adds it to the nameList
    end
    uniqueNameList = unique(nameList);      % creates unique list of names
end
