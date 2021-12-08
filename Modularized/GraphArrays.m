function [x, y] = GraphArrays(PathName, size, combined, j, fileList, layerList, oneTwo)
    if combined == 'N', fid = fopen([PathName,dd(k).name]);                                         % opening file when orientations aren't combined
    elseif combined == 'Y', L = find(layerList == j); fid = fopen([PathName,char(fileList(L(oneTwo)))]); % when orientations are combined
    else, error('There was an error.');
    end
    x2 = 0:0.1:100;
    
    first = fgetl(fid);
    junk = fgetl(fid);
    sizeA = [4 Inf];
    A = fscanf(fid,'%f %f %f', sizeA);
    fclose(fid);
    x = 100-100*A(2,:);
    if size == 'S', y = 10^-10*25*pi*A(3,:); % calculations on data
    elseif size == 'L', y = 10^-8*36*pi*A(3,:);
    else, error('There was an error.');
    end
    
    [x1, index] = unique(x); 
    z = 10^-8*36*pi*A(3,:);
    y1 = interp1(x1,z(index),x2);
    if combined == 'Y'
        x = x2;
        y = y1;
    end
end