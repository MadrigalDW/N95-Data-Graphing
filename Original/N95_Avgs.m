%{
PathName = 'C:\Users\Madrigal\Documents\MatLab\Data N95\Paper 2\';
dd = dir([PathName,'*.txt']);

fid = fopen([PathName,'24CMMeshVolume.txt']);
sizeZ = [4 Inf];
Z = fscanf(fid,'%f %f %f %f', sizeZ);
fclose(fid);
v = Z(2,:);
sumV = sum(v);
lengthV = length(v);
average = sumV/lengthV;
%}
PathName = 'C:\Users\Madrigal\Documents\MatLab\Data N95\Paper 2\';
dd = dir([PathName,'*.txt']);
fid = fopen([PathName,'24CMMeshVolume.txt']);
sizeA = [4 Inf];
Z = fscanf(fid,'%f %f %f %f', sizeA);
fclose(fid);
v = Z(2,:);
r = 1;

nameList = [];
for i = 1:length(dd)
    nom = dd(i).name;
    first14 = string(nom(1:14));
    nameList = [nameList; first14];
end
names = unique(nameList);
names = names(names~="24CMMeshVolume");

avg = zeros(length(names),2);
for j = 1:length(names)
    x = find(nameList == names(j));
    t = char(names(j));
    if t(5) == 's'
        s = 40;
        t = [t(1:5),'\',t(6:9),'\',t(10:14)];
    else 
        s = 39;
        t = [t(1:4),'\',t(5:8),'\',t(9:13)];
    end
    
    fileList = [];
    layerList = [];
    for k = x'
        file = string(dd(k).name);
        layer = str2double(extractBetween(string(dd(k).name),s,s));
        fileList = [fileList, file];
        layerList = [layerList, layer];
    end
    for k = 1:3
        y = find(layerList == k);
        fid = fopen([PathName,char(fileList(y(1)))]);
        first = fgetl(fid); 
        junk = fgetl(fid);
        A = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid); 
        z1 = A(4,:);
        
        %z1 = sort(z1);
        v2 = v(z1+1)*10^9;
        average = mean(v2);
        stDev = std(v2);
        avg(r,:) = [average, stDev];
        r = r+1;
    end
    writematrix(avg, 'Avg&StDev.xlsx');
end
