PathName = 'C:\Users\Madrigal\Documents\MATLAB\Stuff\';
dd = dir([PathName,'*.txt']);
fid = fopen([PathName,'10_1CMCore_withrings_0.05mm.txt']);
sizeZ = [5 Inf];
sizeA = [4 Inf];
Z = fscanf(fid,'%f %f %f %f %f', sizeZ);
fclose(fid);
v = Z(2,1:13679616), Z(2,13679617:end);

nameList = [];
for i = 1:length(dd)
    nom = dd(i).name;
    first14 = string(nom(1:14));
    nameList = [nameList;first14];
end
names = unique(nameList);
names = names(names~="24CMMeshVolume");

for a = 1:length(names)
    x = find(nameList == names(a));
    t = char(names(a));
    if t(5) == 's'
        s = 40;
        size = extractBetween(names(a),11,12);
        t = [t(1:5),'\',t(6:9),'\',t(10:14)];
    else 
        s = 39;
        size = extractBetween(names(a),10,11);
        t = [t(1:4),'\',t(5:8),'\',t(9:13)];
    end
    fileList = [];
    layerList = [];
    for b = x'
        file = string(dd(b).name);
        layer = str2double(extractBetween(string(dd(b).name),s,s));
        fileList = [fileList, file];
        layerList = [layerList, layer];
    end

    y = find(layerList == 3);
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
    y2 = 10^-8*36*pi*B(3,:);
    z2 = B(4,:);

    [z3, I] = sort(z1);
    y3 = y1(I);
    [z4, I] = sort(z2);
    y4 = y2(I);
    y5 = y3 + y4;
    v2 = v(z3+1);
    [y6, I] = sort(y5);
    v3 = v2(I);
    
    sumV = sum(v3);
    v4 = zeros(1, length(v3));
    for i = 1:length(v3)
        v4(i) = 100*v3(i)/sumV;
        if i < length(v3), v3(i+1) = v3(i+1) + v3(i);
        end
    end
    figure
    loglog(v4,y6,'color', 'b','linewidth',1);
    hold on
    title(t);
    xlim([10^-4 10^2]);
    ylim([10^-6 10^-2])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Outer Shell','Location', 'southoutside')
    hold off
end