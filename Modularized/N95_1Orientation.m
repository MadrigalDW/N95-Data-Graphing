%N95 1 Orientation
PathName = 'C:\Users\Madrigal\Documents\MATLAB\Summer Student\Data N95\Paper 1\Small Source Orientation A';
dd = dir([PathName,'*.txt']);
colouring = 'Y';
[lineColor, ls] = LineStyling(colouring);       % linestyling for graph
[nameList, uniqueNameList] = BuildNameList(dd); % nameList has all filenames, uniqueNameList contains unique filenames

for i = 1:length(names)
    namePlaces = find(nameList == names(i));
    [graphTitle, size, layerChar] = NameVariables(names, i);
    
    figure
    for j = namePlaces'
        [x, y] = GraphArrays(PathName, size, 'N', j, '', '', 1);
        layer = str2double(extractBetween(string(dd(j).name),layerChar,layerChar));
        semilogy(x,y,'color', lineColor(layer,:),'linewidth',1,'linestyle',ls(layer).style);
        hold on
    end
    title(graphTitle);
    xlim([0 100])
    xlabel('Volume (%)')
    ylabel('Fluence-Rate (mW/cm^2)')
    legend('Outer Shell','Filter Layer','Inner Shell','Location', 'southoutside','NumColumns',3)
    hold off
end