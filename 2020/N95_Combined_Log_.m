PathName = 'C:\Users\Madrigal\Documents\MatLab\Data N95\Large Source Orientation B\';
dd = dir([PathName,'*.txt']);
fid = fopen([PathName,'LargeMeshVolume.txt']);
sizeZ = [5 Inf];
Z = fscanf(fid,'%f %f %f %f %f', sizeZ);
fclose(fid);
v = [Z(3,1:1023) Z(2,1024:end)]; %for large
%v = Z(3,:); %for small
sizeA = [4 Inf];
sizeF = [5 1];

nameList = [];
for i = 1:length(dd)
    nom = dd(i).name;
    firstEleven = string(nom(1:11));
    nameList = [nameList;firstEleven];
end
names = unique(nameList);
names = names(names~="SmallMeshVo");
names = names(names~="LargeMeshVo");
lowFluence = zeros(length(names),3);
for j = 1:length(names)
    x = find(nameList == names(j));
    t = char(names(j));
    if t(5) == 's'
        s = 37;
        size = extractBetween(names(j),11,11);
        t = [t(1:5),'\',t(6:9),'\',t(10:11)];
    else 
        s = 36;
        size = extractBetween(names(j),10,10);
        t = [t(1:4),'\',t(5:8),'\',t(9:10)];
    end
    fileList = [];
    layerList = [];
    for k = x'
        file = string(dd(k).name);
        layer = str2double(extractBetween(string(dd(k).name),s,s));
        fileList = [fileList, file];
        layerList = [layerList, layer];
    end

    v3 = [];
    y4 = [];
    for l = 1:3
        y = find(layerList == l);
        fid = fopen([PathName,char(fileList(y(1)))]);
        first = fgetl(fid); 
        junk = fgetl(fid);
        A = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid); 
        y1 = 10^-8*36*pi*A(3,:);
        z1 = A(4,:);
        
        fid = fopen([PathName,char(fileList(y(2)))]);
        first = fgetl(fid);
        junk = fgetl(fid);
        B = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid);  
        y2 = 10^-8*36*pi*A(3,:);
        z2 = B(4,:);
        
        [z1, I] = sort(z1);
        y1 = y1(I);
        [z2, I] = sort(z2);
        y2 = y2(I);
        y3 = y1 + y2;
        v2 = v(z1+1);
        [y3, I] = sort(y3);
        v2 = v2(I);
        
        v3 = [v3, v2];
        y4 = [y4, y3];
    end
    sumV = sum(v3);
    [y4, I] = sort(y4);
    v3 = v3(I);
    v4 = zeros(1, length(v3));
    for i = 1:length(v3)
        v4(i) = 100*v3(i)/sumV;
        if i < length(v3), v3(i+1) = v3(i+1) + v3(i);
        end
    end
    figure
    loglog(v4,y4,'color', 'k','linewidth',1);
    hold on
    title(t);
    xlim([10^-4 100]);
    ylim([10^-6 10^-1])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    %legend('Outer Shell','Location', 'southoutside','NumColumns',3)
    hold off
end
