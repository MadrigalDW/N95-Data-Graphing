PathName = 'C:\Users\Madrigal\Documents\MatLab\Data N95\Paper 2\';
dd = dir([PathName,'*.txt']);
fid = fopen([PathName,'24CMMeshVolume.txt']);
sizeA = [4 Inf];
Z = fscanf(fid,'%f %f %f %f', sizeA);
fclose(fid);
v = Z(2,:);

nameList = strings(1, 250);
for i = 1:length(dd)
    nom = dd(i).name;
    first14 = string(nom(1:14));
    nameList(i) = first14;
end
names = unique(nameList);
names = names(names~="");
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
    fileList = strings(1,6);
    layerList = zeros(1,6);
    for b = x'
        file = string(dd(b).name);
        layer = str2double(extractBetween(string(dd(b).name),s,s));
        fileList(b) = file;
        layerList(b) = layer;
    end
    v4 = [];
    y7 = [];
    for c = 1:3
        y = find(layerList == c);
        fid = fopen([PathName,char(fileList(y(1)))]);
        fgetl(fid); 
        fgetl(fid);
        A = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid); 
        y1 = 10^-8*144*pi*A(3,:);
        z1 = A(4,:);
        
        fid = fopen([PathName,char(fileList(y(2)))]);
        fgetl(fid);
        fgetl(fid);
        B = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid);  
        y2 = 10^-8*144*pi*A(3,:);
        z2 = B(4,:);
        
        [z3, I] = sort(z1);
        y3 = y1(I);
        [z4, I] = sort(z2);
        y4 = y2(I);
        y5 = y3 + y4;
        v2 = v(z3+1);
        [y6, I] = sort(y5);
        v3 = v2(I);
        
        v4 = [v4, v3];
        y7 = [y7, y6];
    end
    sumV = sum(v4);
    [y8, I] = sort(y7);
    v5 = v4(I);
    
    v6 = zeros(1, length(v5));
    for i = 1:length(v5)
        v6(i) = 100*v5(i)/sumV;
        if i < length(v5), v5(i+1) = v5(i+1) + v5(i);
        end
    end
    fig = figure;
    loglog(v6,y8,'color', 'k','linewidth',1);
    hold on
    title(t);
    xlim([10^-4 100]);
    ylim([10^-5 10^0])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    %legend('Outer Shell','Location', 'southoutside','NumColumns',3)
    hold off
    saveas(fig,['C:\Users\Madrigal\Documents\MATLAB\Data N95\Paper 2\' char(names(a)) '.jpg']);
end
% check calculations and where figures are being saved
