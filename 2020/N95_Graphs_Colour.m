PathName = 'C:\Users\Madrigal\Documents\MATLAB\Stuff\';
dd = dir([PathName,'*.txt']);
lineColor = [1 0 0; 0 1 0; 0 0 1];
nameList = [];
for i = 1:length(dd)
    nom = dd(i).name;
    firstEleven = string(nom(1:11));
    nameList = [nameList;firstEleven];
end
names = unique(nameList);
for j = 1:length(names)
    x = find(nameList == names(j));
    t = char(names(j));
    if t(5) == 's'
        s = 37;
        size = extractBetween(names(j),11,11);
        t = [t(1:5),'\',t(6:9),'\',t(10:11)];
    else 
        s = 34;
        size = extractBetween(names(j),10,10);
        t = [t(1:4),'\',t(5:8),'\',t(9:10)];
    end
    figure
    for k = x'
        fid = fopen([PathName,dd(k).name]);
        first = fgetl(fid);
        junk = fgetl(fid);
        sizeA = [4 Inf];
        A = fscanf(fid,'%f %f %f %f', sizeA);
        fclose(fid);
        layer = str2double(extractBetween(string(dd(k).name),s,s));
        x1 = 100-100*A(2,:);
        y1 = 10^-10*36*pi*A(3,:);
        %{
        if size == 'S', y1 = 10^-10*25*pi*A(3,:); % calculations on data
        elseif size == 'L', y1 = 10^-8*36*pi*A(3,:);
        else, error('There was an error.');
        end
        %}
        semilogy(x1,y1,'color', lineColor(layer,:),'linewidth',1);
        hold on
    end
    title(t);
    %set(gca,'FontSize',18);
    %ylim([10^-12 10^-2])
    %yticks([10^-12 10^-10 10^-8 10^-6 10^-4 10^-2])
    xlim([0 100])
    %xticks([0 20 40 60 80 100])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Outer Shell','Filter Layer','Inner Shell','Location', 'southoutside','NumColumns',3)
    hold off
end
