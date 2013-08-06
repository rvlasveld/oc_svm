%APPLY_INC_SVDD Apply the incremental SVDD algorithm over a data set
%
%       [OFFS, W, AI ] = APPLY_INC_SVDD( DATA, COLUMNS, BLOCK_SIZE,
%           STEP_SIZE, C, KTYPE, KPAR )
%   
%   Apply the incremental SVDD algorithm and get the w.offs for each
%   window, representing the radius of the hypersphere.
%
%   Input arguments:
%       - DATA: the data series. Should be minimal two dimensional
%       - COLUMNS: the columns of DATA to which to apply the method. Max
%       length is two. Defaults to first two columns.
%       - BLOCK_SIZE: two window block. Defaults to 40.
%       - STEP_SIZE: the step size for each window-shift. Defaults to 5.
%       - C: The C-parameter of SVDD. Use <1 for soft-margin. Default: 0.1
%       - KTYPE: The kernel type to use. Default: 'r' (rbf kernel).
%       - KPAR: The parameter for the kernel. Defaults to 4.
%
%   The returned value OFFS gives for each window the approximated (?)
%   radius of the hypersphere.
%
%   Output values:
%       - OFFS: for each window the approximated (?) radius of the
%       hypersphere
%       - W: the final model representation
%       - AI: the indices after applying `unique` on the data. This can be
%       used to recalculate the change_points locations (if known).
%
%   See also inc_setup, incsvdd, inc_add, inc_remove.



function [results, ai] = apply_inc_svdd( data, columns, block_size, step_size, C, ktype, kpar )


    if size(data, 2) == 1
        warning('Data must be 2D. Copying the single column for now');
        data(:,2) = data(:,1);
    end
    
%     if nargin < 2; columns = [1 2]; end
    if nargin < 2; columns = 1:size(data,2); end
    
    % Sliding window parameters
    if nargin < 3; block_size = 40; end
    if nargin < 4; step_size = 5; end
    
    % SVDD parameteres
    if nargin < 5; C = 0.1; end
    if nargin < 6; ktype = 'r'; end     % RBF kernel
    if nargin < 7; kpar = 4; end        % Sigma
    
    % Make sure data is unique (otherwise problems with inc_remove)
    [data, ai, ~] = unique(data(:, columns), 'rows', 'stable');
    
    
%     first_block_size = floor(max(1/C, step_size))
    first_block_size = block_size;
    results_length   = ceil(size(data, 1)/step_size) - (first_block_size + step_size);
    results_zeros    = zeros(results_length, 2);
    offs             = results_zeros;

    % Set up the figure with model representation, axis properties, handles for vertical line drawing
    sfigure(1); clf; axis auto;
    
    % Figure with orignal data
    sfigure(3); clf; axis auto;
    plot(1:size(data, 1), data(:,:));
    set(gca, 'XTick', 0:50:size(data, 1));
    
    h_verticals = draw_vertical_lines([0 0]);
    xLimits_full_plot = get(gca, 'XLim');
    
    % Figure with threshold/offs values (model metrics)
    sfigure(2); cla; hold on;
    xlim(xLimits_full_plot);
    ylim([0 1]);
    set(gca, 'XTick', 0:50:size(data, 1));
    
    
    % Figure with outlier-metrics
    sfigure(4); cla; axis auto;
    xlim(xLimits_full_plot);
    ylim([0 1]);
    set(gca, 'XTick', 0:50:size(data, 1));
   
    
    % Create the SVDD
    W = inc_setup('svdd', ktype, kpar, C, data(1:first_block_size,:), ones(first_block_size, 1) );

    from = 1;
    counter = 1;
    
    number_of_outliers  = results_zeros;
    offsets             = results_zeros;
    outlier_distances   = results_zeros;
    thresholds          = results_zeros;
    
    for i = first_block_size + step_size: step_size : size(data, 1)
%         i
        % Extract new point from data buffer
        new_points = data(i-step_size + 1 : i, :);
        
        % Add to SVDD
        for j = 1 : size(new_points, 1)
            W = inc_add(W, new_points(j,:), 1);
        end
        
        % Remove first point from SVDD
        if i >= (from + block_size)
            
            for j = 1 : size(new_points, 1)
                W = inc_remove(W,1);
            end
            from = from + step_size;
        end
        
        
        % Get mapping representations
        w0 = inc_store(W);
        w = +w0;

        offs(counter,:) = [i, w.offs];

        % Draw mapping and points
        [h_data, h_SVs, h_new_points, h_outliers, h_boundary, properties] = calculate_data_and_boundary(data, from:i, w0, w, i-step_size+1:i, counter == 1);
        
        number_of_outliers(counter,:) = properties('number_of_outliers');
        offsets(counter,:)            = properties('offsets');
        outlier_distances(counter,:)  = properties('outlier_distances');
        thresholds(counter,:)         = properties('thresholds');

        handles = [h_data(1), h_SVs(1), h_new_points(1)];
        texts = {['Data (' int2str(i-from+1+step_size) ') '], ['Support Vectors (' int2str(length(w.sv)) ') '], ['New Point (' int2str(i) ') ']};
        
        if numel(h_outliers) ~= 0
            handles(end+1) = h_outliers(1);
            
            texts{end+1} = ['Outliers (' int2str(number_of_outliers(counter,2)) ')'];
        end
        
        if numel(h_boundary) ~= 0
            handles(end+1) = h_boundary(1);
            texts{end+1} = 'Boundary';
        end
        legend(handles', texts);
        
        % Draw the window with mapped data points and boudary
        sfigure(1);
        drawnow;
        
        % Draw the selection-bars in the data-plot window
        sfigure(3);
        yL = get(gca, 'YLim');
        set(h_verticals(1), 'XData', [from-step_size from-step_size], 'YData', yL );
        set(h_verticals(2), 'XData', [i i], 'YData', yL );
        drawnow;

        counter = counter + 1;
    end
    
    sfigure(2);
    legend('W.offs', 'W.threshold', 'ratio W.offs', 'ratio W.threshold');
    drawnow;
    sfigure(4);
    legend('Total outlier distances', 'Number of outliers', 'ratio outlier distance', 'ratio nubmer of outliers');
    drawnow;
    
    results = containers.Map();
    results('number_of_outliers') = number_of_outliers;
    results('offsets')            = offsets;
    results('outlier_distances')  = outlier_distances;
    results('thresholds')         = thresholds;
end



function [h_data, h_SVs, h_new_points, h_outliers, h_boundary, properties] = calculate_data_and_boundary(data, rows, w, W, indices_new, clear_persistance)
    persistent offsets
    persistent thresholds;
    persistent outlier_distances;
    persistent number_of_outliers;
    
    persistent offset_ratios;
    persistent threshold_ratios;
    persistent distance_ratios;
    persistent outliers_ratios;
    
    if clear_persistance; 
        offsets = []; thresholds = []; outlier_distances = []; number_of_outliers = []; 
        offset_ratios = []; threshold_ratios = []; distance_ratios = []; outliers_ratios = [];
    end
    
    i = indices_new(end);
    
    sfigure(2);
    cla; hold on; ylim('auto');
    
    % Check which (new) data points are outliers
    new_data = data(rows,:);
    new_data_mapped = +(new_data * w);
    threshold = W.threshold;
    indices_outliers = abs(new_data_mapped(:,1)) - 0.0001 > (threshold);
    
    
    % Select the window with mapped data and boundary
    sfigure(1); cla; axis auto;
    
    h_data          = scatterd(data(rows,:), 'k*');      % Only draw first two features
    axis auto; hold on;
    h_SVs           = scatterd(W.sv, size(data, 2), 'r*');                     % Points acting as Support Vector
    axis auto; hold on;
    h_new_points    = scatterd(data(indices_new,:), 'g*');
    axis auto; hold on;
    
    h_boundary = 0;
    if size(data, 2) < 3
        h_boundary      = plotc(w, 'b');
        axis auto; hold on;
    end
    
    h_outliers = 0;
    num_outliers = length(find(indices_outliers));
    number_of_outliers(end+1, :) = [i num_outliers];
    if num_outliers
        
        h_outliers      = scatterd(new_data(indices_outliers, :), 'ko');
        axis auto; hold on;
        
        outlier_distances(end+1,:) = [i  sum(abs(new_data_mapped(indices_outliers, 1)))];
    else
        outlier_distances(end+1,:) = [i 0];
    end
    

    offsets(end+1,:) = [i W.offs]; 
    thresholds(end+1,:) = [i W.threshold]; 
    
    % Draw the offs and threshold in the window
    sfigure(2);
    hold on;
    plot(offsets(:,1), offsets(:,2), 'b', 'LineWidth', 1 );
    plot(thresholds(:,1), thresholds(:,2), 'g', 'LineWidth', 1 );
    
    % Draw the ratios
    ratio_history = 10;
    
    ratio_offset = ratio(offsets(:,2), ratio_history);
    offset_ratios(end+1,:) = [i ratio_offset];
    
    ratio_threshold = ratio(thresholds(:,2), ratio_history);
    threshold_ratios(end+1,:) = [i ratio_threshold];
    
    plot(offset_ratios(:,1), offset_ratios(:,2), '--r', 'LineWidth', 1 );
    plot(threshold_ratios(:,1), threshold_ratios(:,2), '--m', 'LineWidth', 1 );
    
    % TODO: USE plotyy FOR RATIOS ON ONE SIDE
    
    ylim('auto');
    drawnow;
    
    sfigure(4); cla; hold on;
    plot(outlier_distances(:,1), outlier_distances(:,2), 'r', 'LineWidth', 1 );
    plot(number_of_outliers(:,1), number_of_outliers(:,2), 'b', 'LineWidth', 1 );
    
    % Draw the ratios
    ratio_distances = ratio(outlier_distances(:,2), ratio_history);
    distance_ratios(end+1,:) = [i ratio_distances];
    
    ratio_outliers = ratio(number_of_outliers(:,2), ratio_history);
    outliers_ratios(end+1,:) = [i ratio_outliers];
    
    plot(distance_ratios(:,1), distance_ratios(:,2), '--g', 'LineWidth', 1.2 );
    plot(outliers_ratios(:,1), outliers_ratios(:,2), '--m', 'LineWidth', 1.2 );
    
    ylim('auto');
    drawnow;
    
    
    properties = containers.Map();
    properties('offsets') = offsets(end,:);
    properties('thresholds') = thresholds(end,:);
    properties('outlier_distances') = outlier_distances(end,:);
    properties('number_of_outliers') = number_of_outliers(end,:);
    
    
end