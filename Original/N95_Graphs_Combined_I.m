PathName = 'C:\Users\Madrigal\Documents\MatLab\Data N95\';
dd = dir([PathName,'*.txt']);
lineColor = [1 0 0; 0 1 0; 0 0 1];
nameList = [];
for i = 1:length(dd) % creating a list of all the names of files
    nom = dd(i).name;
    firstEleven = string(nom(1:11));
    nameList = [nameList;firstEleven];
end
names = unique(nameList);
for j = 1:length(names)
    % Run through the names, finding the 3 files that match each name
    x = find(nameList == names(j));
    t = char(names(j));
    if t(5) == 's' % for the differences between the files with the extra s
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
    figure
    for l = 1:3
        x3 = 0:0.1:100;
        y = find(layerList == l);
        fid = fopen([PathName,char(fileList(y(1)))]);
        first = fgetl(fid);
        junk = fgetl(fid);
        sizeA = [4 Inf];
        A = fscanf(fid,'%f %f %f', sizeA);
        fclose(fid);
        x1 = 100-100*A(2,:);
        [x1, index] = unique(x1); 
        z = 10^-8*36*pi*A(3,:);
        y1 = interp1(x1,z(index),x3);
        
        fid = fopen([PathName,char(fileList(y(2)))]);
        first = fgetl(fid);
        junk = fgetl(fid);
        sizeB = [4 Inf];
        B = fscanf(fid,'%f %f %f', sizeA);
        fclose(fid);
        x1 = 100-100*B(2,:);
        [x1, index] = unique(x1);
        z = 10^-8*36*pi*B(3,:);
        y2 = interp1(x1,z(index),x3);
        
        y3 = y1 + y2;
        semilogy(x3,y3,'color', lineColor(layerList(2*l),:),'linewidth',1);
        hold on
    end
    title(t); % graph details
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Inner Shell','Filter Layer','Outer Shell','Location', 'southoutside','NumColumns',3)
    hold off
end