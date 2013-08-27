%DRAW_HORIZONTAL_LINES Draw a series of horizontal lines in the current figure
%
%       HANDLES = DRAW_HORIZONTAL_LINES(POSITIONS, COLOR)
%
% Draw a series of horizontal lines in the current (=last used) figure.
% The values in POSITIONS correspond to the position in the y-axis at which
% a line will be drawn.
% A COLOR string can be added for color settings etc.
%
% Currently, other properties of the line can not be set.

function handles = draw_horizontal_lines( positions, color )

    if nargin < 2
        color = 'k';
    end

    xL = get(gca, 'XLim');
    handles = zeros(length(positions),1);
    for i = 1 : length(positions)
        handles(i) = line(xL, [positions(i) positions(i)], 'Color', color );
    end

end

