PathName = 'C:\Users\Madrigal\Documents\MATLAB\Stuff\';
dd = dir([PathName,'*.txt']);
lineColor = [1 0 0; 0 1 0; 0 0 1];

fid = fopen([PathName,'10_1CMCore_withrings_0.05mm.txt']);
sizeA = [4 Inf];
sizeZ = [5 Inf];
Z = fscanf(fid,'%f %f %f %f %f', sizeZ);
fclose(fid);
v = [Z(2,1:13679616) Z(3,13679617:end)];

nameList = [];
for i = 1:length(dd)
    nom = dd(i).name;
    firstEleven = string(nom(1:11));
    nameList = [nameList;firstEleven];
end
names = unique(nameList);
names = names(names~="10_1CMCore_");

for i = 1:length(names)
     x = find(nameList == names(i));
    t = char(names(i));
    if t(5) == 's'
        s = 35;
        t = [t(1:5),'\',t(6:9),'\_1CM'];
    else 
        s = 34;
        t = [t(1:4),'\',t(5:8),'\_1CM'];
    end
    figure
    for j = x'
        fid = fopen([PathName,dd(j).name]);
        first = fgetl(fid);
        junk = fgetl(fid);
        A = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid);
        layer = str2double(extractBetween(string(dd(j).name),s,s));
        
        y = 10^-10*36*pi*A(3,:);
        z = A(4,:);
        x2 = v(z+1);
        [x1, I] = sort(x2);
        y1 = y(I);
        semilogy(x1,y1,'color', lineColor(layer,:),'linewidth',1);
        hold on
    end
    title(t);
    xlabel('Tetra Volume')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Outer Shell','Filter Layer','Inner Shell','Location', 'southoutside','NumColumns',3)
    hold off
end
