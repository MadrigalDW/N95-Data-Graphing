function [graphTitle, size, layerChar] = NameVariables(names, i)
   graphTitle = char(names(i));
   if graphTitle(5) == 's' % for the differences between the files with the extra s
        layerChar = 37;                                                             % will be used for finding the layer
        size = extractBetween(names(i),11,11);                                      % the size of the decontamination source    
        graphTitle = [graphTitle(1:5),'\',graphTitle(6:9),'\',graphTitle(10:11)];   % will be the graph title
   else 
        layerChar = 36;
        size = extractBetween(names(i),10,10);
        graphTitle = [graphTitle(1:4),'\',graphTitle(5:8),'\',graphTitle(9:10)];
   end 
end