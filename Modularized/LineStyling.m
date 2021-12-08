function [lineColor, ls] = LineStyling(colouring)
    if colouring == 'Y'
        lineColor = [1 0 0; 0 1 0; 0 0 1]; %rgb colors
        ls(1).style = '-';  % all lines are solid
        ls(2).style = '-';
        ls(3).style = '-';
    else
        lineColor = [0 0 0; 0 0 0; 0 0 0]; % all lines are black
        ls(1).style = '-';  % solid
        ls(2).style = '-.'; % dot dashed
        ls(3).style = '--'; % dashed
    end
end