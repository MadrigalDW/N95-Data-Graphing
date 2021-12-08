PathName = 'C:\Users\Madrigal\Documents\MATLAB\Data N95\Paper 1\Large Source Orientation A\';
dd = dir([PathName,'*.txt']);
ls(1).style = '-';
ls(2).style = '-.';
ls(3).style = '--';
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
    figure
    for k = x' % Open each file with index x and extract the data, graphing it
        fid = fopen([PathName,dd(k).name]);
        f = fgetl(fid);
        f = fgetl(fid);
        sizeA = [4 Inf];
        A = fscanf(fid,'%f %f %f', sizeA);
        fclose(fid);
        layer = str2double(extractBetween(string(dd(k).name),s,s));
        x1 = 100-100*A(2,:);
        if size == 'S', y1 = 10^-10*25*pi*A(3,:); % calculations on data
        elseif size == 'L', y1 = 10^-8*36*pi*A(3,:);
        else, error('There was an error.');
        end
        semilogy(x1,y1,'color','k','linestyle',ls(layer).style,'linewidth',1);
        hold on
    end
    title(t); % graph details
    ylim([10^-8 10^0])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Inner Shell','Filter Layer','Outer Shell','Location', 'southoutside','NumColumns',3)
    hold off
end