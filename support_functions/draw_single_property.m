function [ ratios ] = draw_single_property( property, draw_ratio, ratio_history_length )
%DRAW_SINGLE_PROPERTY Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 2; draw_ratio = false; end
    if nargin < 3; ratio_history_length = 10; end
    
    data_x = property(:, 1);
    
    if draw_ratio
%         series = cell2mat(property);
        series = property;
        ratio_series = zeros(1, size(series, 1));
        for j = 1 : size(series, 1)
            ratio_series(j) = ratio(series(1:j,:), ratio_history_length);
        end
        ratios = [series(:,1) series(:,2) ratio_series'];
    end
    
    
    clf; axis auto;
    set(0,'DefaultAxesLooseInset',[0.02,0,0.02,0])
    
    % Set plot location and size
%     screenSize = get(0,'ScreenSize');
%     plot_width  = screenSize(3);
%     plot_height = screenSize(4) / 4;
    
%     set(gcf,'Position',[0 (plot_height * 1.3) plot_width plot_height]);
    
    plot(data_x, property(:,3), 'b-');
    legend('Property');
    axis([0 data_x(end,1) 0 max(property(:,3))])
    
    if draw_ratio
        hold on;
        plot(data_x, ratio_series', 'k--');
        legend('Property', 'Ratio');
        axis([0 data_x(end,1) 0 max([property(:,3); ratio_series'])])
    end
    
    
    
    set(gca, 'XTick', 0:roundn(length(data_x)/25, 1):data_x(end, 1));

end

