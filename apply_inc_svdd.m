%APPLY_INC_SVDD Apply the incremental SVDD algorithm over a data set
%
%       [PROPERTIES, RATIOS] = APPLY_INC_SVDD( DATA, COLUMNS, BLOCK_SIZE,
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
%       - PROPERTIES: The properties of the calculated SVM models. It is an
%       container Map, with keys: {'thresholds', 'offsets',
%       'outlier_distances', 'number_of_outliers'}.
%       - RATIOS: The ratios of each value of PROPERTIES, calculated with
%       the default history length of 10. This is a direct result of a call
%       to draw_properties.
%
%   See also inc_setup, incsvdd, inc_add, inc_remove, draw_properties.



function [results, ratios] = apply_inc_svdd( data, columns, block_size, step_size, C, ktype, kpar )


    if size(data, 2) == 1
        warning('Data must be 2D. Copying the single column for now');
        data(:,2) = data(:,1);
    end
    
    if nargin < 2; columns = 1:size(data,2); end
    
    % Sliding window parameters
    if nargin < 3; block_size = 40; end
    if nargin < 4; step_size = 5; end
    
    % SVDD parameteres
    if nargin < 5; C = 0.1; end
    if nargin < 6; ktype = 'r'; end     % RBF kernel
    if nargin < 7; kpar = 4; end        % Sigma
    
    % Make sure data is unique (otherwise problems with inc_remove)
    [filtered_data, IA, ~] = unique(data(:,columns), 'rows', 'stable');
    
    % Include time as first column
    data = [data(IA,1) filtered_data];
    
    first_block_size = block_size;
    results_length   = ceil(size(data, 1)/step_size) - (first_block_size + step_size);
    results_zeros    = zeros(results_length, 3);
    offs             = results_zeros;
        
    % Set up the figure with model representation, axis properties, handles for vertical line drawing
    sfigure(1); clf; axis auto;
    
    % Figure with orignal data
    sfigure(4); clf; axis auto;
    plot(data(:,1), data(:,2:end));
    set(gca, 'XTick', 0:roundn(length(data)/50, 1):data(end, 1));
    
    h_verticals = draw_vertical_lines([0 0]);

    screenSize = get(0,'ScreenSize');
    plot_width  = screenSize(3);
    plot_height = screenSize(4) / 4;
    sfigure(4); set(gcf,'Position',[0 (screenSize(4) - plot_height) plot_width plot_height]);
   
    
    % Create the SVDD
    W = inc_setup('svdd', ktype, kpar, C, data(1:first_block_size,2:end), ones(first_block_size, 1) );

    from = 1;
    counter = 1;
    
    number_of_outliers  = results_zeros;
    offsets             = results_zeros;
    outlier_distances   = results_zeros;
    thresholds          = results_zeros;
    
    for i = first_block_size + step_size: step_size : size(data, 1)
        % Extract new point from data buffer
        new_points = data(i-step_size + 1 : i, :);
        time = new_points(end,1);
        
        % Add to SVDD
        for j = 1 : size(new_points, 1)
            W = inc_add(W, new_points(j,2:end), 1);
        end
        
        % Remove first point from SVDD
        if i >= (from + block_size)
            
            for j = 1 : size(new_points, 1)
                W = inc_remove(W,1);
            end
            from = from + step_size;
        end
        time_start = data(from-step_size, 1);
        
        % Get mapping representations
        w0 = inc_store(W);
        w = +w0;

        offs(counter,:) = [new_points(end,1) i w.offs];

        % Draw mapping and points
        [h_data, h_SVs, h_new_points, h_outliers, h_boundary, properties] = calculate_data_and_boundary(data, from:i, w0, w, i-step_size+1:i, counter == 1);
        
        number_of_outliers(counter,:) = [time properties('number_of_outliers')];
        offsets(counter,:)            = [time properties('offsets')];
        outlier_distances(counter,:)  = [time  properties('outlier_distances')];
        thresholds(counter,:)         = [time properties('thresholds')];
        
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
%         legend(handles', texts);
        
        % Draw the window with mapped data points and boudary
%         sfigure(1);
        drawnow;
        
        % Draw the selection-bars in the data-plot window
        sfigure(4);
        yL = get(gca, 'YLim');
        
        set(h_verticals(1), 'XData', [time_start time_start], 'YData', yL );
        set(h_verticals(2), 'XData', [time time], 'YData', yL );
        drawnow;

        counter = counter + 1;
    end
    
    results = containers.Map();
    results('number_of_outliers') = number_of_outliers;
    results('offsets')            = offsets;
    results('outlier_distances')  = outlier_distances;
    results('thresholds')         = thresholds;
    
    ratios = draw_properties(results, 20 );
    
    % Add empty y cols for equal space
    sfigure(4);
    addaxis([],[]);
    addaxis([],[]);
    addaxis([],[]);
end



function [h_data, h_SVs, h_new_points, h_outliers, h_boundary, properties] = calculate_data_and_boundary(data, rows, w, W, indices_new, clear_persistance)
    persistent offsets
    persistent thresholds;
    persistent outlier_distances;
    persistent number_of_outliers;
    
    if clear_persistance; 
        offsets = []; thresholds = []; outlier_distances = []; number_of_outliers = []; 
    end
    
    i = indices_new(end);
    
    % Check which (new) data points are outliers
    new_data = data(rows,2:end);
    new_data_mapped = +(new_data * w);
    threshold = W.threshold;
    indices_outliers = abs(new_data_mapped(:,1)) - 0.0001 > (threshold);
    
    h_data = 0;
    h_SVs = 0;
    h_new_points = 0;
    
    
    % Select the window with mapped data and boundary
%     sfigure(1); cla; axis auto;
    
    % Only draw first two features
%     h_data          = scatterd(data(rows,:), 'k*');      
%     axis auto; hold on;
    
    % Points acting as Support Vector
%     h_SVs           = scatterd(W.sv, size(data, 2), 'r*');
%     axis auto; hold on;
    
    % Plot the points that are new in this incremental model
%     h_new_points    = scatterd(data(indices_new,:), 'g*');
%     axis auto; hold on;
    
    h_boundary = 0;
%     if size(data, 2) == 2
%         h_boundary      = plotc(w, 'b');
%         axis auto; hold on;
%     end
    
    h_outliers = 0;
    num_outliers = length(find(indices_outliers));
    number_of_outliers(end+1, :) = [i num_outliers];
    if num_outliers
        
%         h_outliers      = scatterd(new_data(indices_outliers, :), 'ko');
%         axis auto; hold on;
        
        outlier_distances(end+1,:) = [i  sum(abs(new_data_mapped(indices_outliers, 1)))];
    else
        outlier_distances(end+1,:) = [i 0];
    end
    

    offsets(end+1,:) = [i W.offs]; 
    thresholds(end+1,:) = [i W.threshold]; 
    
    properties = containers.Map();
    properties('offsets') = offsets(end,:);
    properties('thresholds') = thresholds(end,:);
    properties('outlier_distances') = outlier_distances(end,:);
    properties('number_of_outliers') = number_of_outliers(end,:);
    
    
end