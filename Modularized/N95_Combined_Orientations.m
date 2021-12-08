% N95 Combined
PathName = 'C:\Users\Madrigal\Documents\MATLAB\Summer Student\Data N95\Paper 1\';
dd = dir([PathName,'*.txt']);
colouring = 'Y';
[lineColor, ls] = LineStyling(colouring);       % linestyling for graph
[nameList, uniqueNameList] = BuildNameList(dd); % nameList has all filenames, uniqueNameList contains unique filenames

for i = 1:length(names)
    namePlaces = find(nameList == names(i));
    [graphTitle, size, layerChar] = NameVariables(names, i);
    
    fileList = zeros(1, length(namePlaces'));
    layerList = zeros(1, length(namePlaces'));
    for j = namePlaces'
        fileList(j) = string(dd(j).name);
        layerList(j) = str2double(extractBetween(string(dd(j).name),layerChar,layerChar));
    end
    
    fig = figure;
    for j = 1:3
        [x1, y1] = GraphArrays(PathName, size, 'Y', j, fileList, layerList, 1);
        [x2, y2] = GraphArrays(PathName, size, 'Y', j, fileList, layerList, 2);
        y3 = y1 + y2;
        semilogy(x2,y3,'color', lineColor(layerList(2*j),:),'linewidth',1);
        hold on
    end
    title(t); % graph details
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Inner Shell','Filter Layer','Outer Shell','Location', 'southoutside','NumColumns',3)
    hold off
    saveas(fig,['C:\Users\Madrigal\Documents\MATLAB\Stuff\' char(names(i)) '.jpg']);
end