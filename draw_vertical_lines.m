%DRAW_VERICAL_LINES Draw a series of vertical lines in the current figure
%
%       HANDLES = DRAW_VERTICAL_LINES(POSITIONS, COLOR)
%
% Draw a series of vertical lines in the current (=last used) figure.
% The values in POSITIONS correspond to the position in the x-axis at which
% a line will be drawn.
% A COLOR string can be added for color settings etc.
%
% Currently, the properties of the line can not be set. The color is set to
% black.

function handles = draw_vertical_lines( positions, color )

    if nargin < 2
        color = 'k';
    end

    yL = get(gca, 'YLim');
    handles = zeros(length(positions),1);
    for i = 1 : length(positions)
        handles(i) = line([positions(i) positions(i)], yL, 'Color', color );
    end

end

