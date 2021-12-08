PathName = 'C:\Users\Madrigal\Documents\MATLAB\Stuff\';
dd = dir([PathName,'*.txt']);
lineColor = [1 0 0; 0 1 0; 0 0 1];

fid = fopen([PathName,'10_1CMCore_withrings_0.05mm.txt']);
sizeZ = [5 Inf];
Z = fscanf(fid,'%f %f %f %f %f', sizeZ);
fclose(fid);
v = [Z(2,1:13679616) Z(3,13679617:end)]; %check
sizeA = [4 Inf];
%m = [95 99 100];
%r = 1;

nameList = strings(1, 250);
for i = 1:length(dd)
    nom = dd(i).name;
    firstEleven = string(nom(1:11));
    nameList(i) = firstEleven;
end
names = unique(nameList);
names = names(names~="");
names = names(names~="10_1CMCore_");

%lowFluence = zeros(length(names),3);
for i = 1:length(names)
    x = find(nameList == names(i));
    t = char(names(i));
    if t(5) == 's'
        s = 37;
        size = extractBetween(names(i),11,11);
        t = [t(1:5),'\',t(6:9),'\',t(10:11)];
    else 
        s = 36;
        size = extractBetween(names(i),10,10);
        t = [t(1:4),'\',t(5:8),'\',t(9:10)];
    end
    fileList = strings(1,6);
    layerList = zeros(1,6);
    for j = x'
        file = string(dd(j).name);
        layer = str2double(extractBetween(string(dd(j).name),s,s));
        fileList(j) = file;
        layerList(j) = layer;
    end
    fig = figure;
    for j = 1:3
        y = find(layerList == j);
        
        fid = fopen([PathName,char(fileList(y(1)))]);
        fgetl(fid); 
        fgetl(fid);
        A = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid); 
        y1 = 10^-10*25*pi*A(3,:);
        z1 = A(4,:);
        
        fid = fopen([PathName,char(fileList(y(2)))]);
        fgetl(fid);
        fgetl(fid);
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
        for k = 1:length(v2)
            v3(k) = 100*v2(k)/sumV;
            if k < length(v2), v2(k+1) = v2(k+1) + v2(k);
            end
        end
        %{
        num = 1;
        for i = m
            fluence = find(v3 >= i);
            if isempty(fluence), fprintf('No')
            else, lowFluence(r,num) = y3(fluence(1));
            end
            num = num + 1;
        end
        r = r+1;
        %}
        semilogy(v3,y3,'color', lineColor(layerList(2*j),:),'linewidth',1);
        hold on
    end
    
    %set(gca,'FontSize',18);
    title(t);
    xlim([0 100])
    %xticks([0 20 40 60 80 100])
    %ylim([10^-10 10^-2])
    %yticks([10^-10 10^-8 10^-6 10^-4 10^-2])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Outer Shell','Filter Layer','Inner Shell','Location', 'southoutside','NumColumns',3)
    hold off
    saveas(fig,['C:\Users\Madrigal\Documents\MATLAB\Stuff\' char(names(i)) '.jpg']);
    %}
    %writematrix(lowFluence, 'lowFluence.xlsx');
end
