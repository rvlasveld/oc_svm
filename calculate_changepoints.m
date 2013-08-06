function [change_points, ratios] = calculate_changepoints( values, column, high, low )
%CALCULATE_CHANGEPOINTS Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 2; column = 2; end
    if nargin < 3; high   = 3; end
    if nargin < 4; low    = 0.2; end
    
    % Determine block sizes
    block_size = values(1,1) - values(3,1) + values(2,1);
    
    change_points = [1 1]; %zeros(size(values),2);
    ratios = zeros(size(values, 1),2);
    
    for i = 2 : length(values)
        time = values(i, 1);
        
        series = values(change_points(end,1):i,column);
        r = ratio(series);
        ratios(i,:) = [time r];
        
        if r > high
            change_points(end+1,:) = [i time];
        end
        
        if r < low
            change_points(end+1,:) = [i time-block_size];
        end;
        
    end
    
    
%     change_points = values(change_points, 1);
%     ratios = values(ratios(:,1), 1);
%     change_points = unique(change_points(:,2));
%     ratios = unique(ratios(:,2

    sfigure(5);
    plot(ratios(:,1), ratios(:,2));
    draw_vertical_lines(change_points(:,2), 'r');
end

