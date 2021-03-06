%DRAW_VERICAL_LINES Draw a series of vertical lines in the current figure
%
%       HANDLES = DRAW_VERTICAL_LINES(POSITIONS, COLOR, LINEWIDTH, LINESTYLE)
%
% Draw a series of vertical lines in the current (=last used) figure.
% The values in POSITIONS correspond to the position in the x-axis at which
% a line will be drawn.
% The line style and color can be set with COLOR, LINEWIDTH and LINESTYLE,
% which correspond with 'color', 'lineWidth', and 'lineStyle'.
%
% Currently, other properties of the line can not be set.

function handles = draw_vertical_lines( positions, color, lineWidth, lineStyle )

    if nargin < 2
        color = 'k';
    end
    
    if nargin < 3
        lineWidth = 1;
    end
    
    if nargin < 4
        lineStyle = '-';
    end

    yL = get(gca, 'YLim');
    handles = zeros(length(positions),1);
    for i = 1 : length(positions)
        handles(i) = line([positions(i) positions(i)], yL, 'Color', color, 'lineWidth', lineWidth, 'lineStyle', lineStyle );
    end

end

