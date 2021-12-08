PathName = 'C:\Users\Madrigal\Documents\MATLAB\Data N95\Paper 1\Small Source Orientation A\';
dd = dir([PathName,'*.txt']);
ls(1).style = '-';
ls(2).style = '-.';
ls(3).style = '--';
fid = fopen([PathName,'SmallMeshVolume.txt']);
sizeZ = [5 Inf];
Z = fscanf(fid,'%f %f %f %f %f', sizeZ);
fclose(fid);
v = Z(3,:);
sizeA = [4 Inf];

nameList = [];
for i = 1:length(dd)
    nom = dd(i).name;
    firstEleven = string(nom(1:11));
    nameList = [nameList;firstEleven];
end
names = unique(nameList);
names = names(names~="LargeMeshVo");
names = names(names~="SmallMeshVo");
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
    fig = figure;
    for l = 1:3
        y = find(layerList == l);
        fid = fopen([PathName,char(fileList(y(1)))]);
        sizeF = [5 1];
        F = fscanf(fid,'%f %f %f %f %f', sizeF);
        fclose(fid);
        f = F(2);
        fid = fopen([PathName,char(fileList(y(1)))]);
        first = fgetl(fid); 
        junk = fgetl(fid);
        A = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid); 
        y1 = 10^-10*25*pi*A(3,:);
        z1 = A(4,:);
        
        fid = fopen([PathName,char(fileList(y(2)))]);
        first = fgetl(fid);
        junk = fgetl(fid);
        B = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid);  
        y2 = 10^-10*25*pi*B(3,:);
        z2 = B(4,:);
        
        [z1, I] = sort(z1,'descend');
        y1 = y1(I);
        [z2, I] = sort(z2,'descend');
        y2 = y2(I);
        y3 = y1 + y2;
        v2 = v(z1+1);
        [y3, I] = sort(y3, 'descend');
        v2 = v2(I);
        sumV = sum(v2);
        v3 = zeros(1, length(v2));
        for i = 1:length(v2)
            v3(i) = 100*v2(i)/sumV;
            if i < length(v2), v2(i+1) = v2(i+1) + v2(i);
            end
        end
        semilogy(v3,y3,'color','k','linestyle',ls(layerList(2*l)).style,'linewidth',1);
        hold on
    end
    title(t);
    xlim([0 100]);
    xticks([0 20 40 60 80 100])
    ylim([10^-10 10^-2])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Inner Shell','Filter Layer','Outer Shell','Location', 'southoutside','NumColumns',3)
    hold off
    saveas(fig,['C:\Users\Madrigal\Documents\MATLAB\N95 Graphs 1\Small Source Combined\' char(names(j)) 'BW.jpg']);
end