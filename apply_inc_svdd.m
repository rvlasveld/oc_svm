%APPLY_INC_SVDD Apply the incremental SVDD algorithm over a data set
%
%       [OFFS] = APPLY_INC_SVDD( DATA, COLUMNS, BLOCK_SIZE, STEP_SIZE, C,
%           KTYPE, KPAR )
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
%   See also inc_setup, incsvdd, inc_add, inc_remove.



function offs = apply_inc_svdd( data, columns, block_size, step_size, C, ktype, kpar )


    if size(data, 2) == 1
        warning('Data must be 2D. Copying the single column for now');
        data(:,2) = data(:,1);
    end
    
    if nargin < 2; columns = [1 2]; end
    
    % Sliding window parameters
    if nargin < 3; block_size = 40; end
    if nargin < 4; step_size = 5; end
    
    % SVDD parameteres
    if nargin < 5; C = 0.1; end
    if nargin < 6; ktype = 'r'; end     % RBF kernel
    if nargin < 7; kpar = 4; end        % Sigma
    
    % Make sure data is unique (otherwise problems with inc_remove)
    data = unique(data, 'rows', 'stable');
    
    
    first_block_size = max(1/C, step_size);
    offs = zeros(ceil(length(data)/step_size) - (first_block_size + step_size),2);

    % Set up the figure, axis properties, handles for vertical line drawing
    sfigure(1); clf; axis auto;
    
    %
    sfigure(3); clf; axis auto;
    plot(1:length(data), data(:,:));
    set(gca, 'XTick', 0:50:length(data));
    
    h_verticals = draw_vertical_lines([0 0]);
    xLimits_full_plot = get(gca, 'XLim');
    
    %
    sfigure(2); cla; hold on;
    xlim(xLimits_full_plot);
    ylim([0 1]);
    set(gca, 'XTick', 0:50:length(data));
    
    
    
   
    
    % Create the SVDD
    W = inc_setup('svdd', ktype, kpar, C, data(1:first_block_size,columns), ones(first_block_size, 1) );

    from = first_block_size;
    counter = 1;
    for i = first_block_size + step_size: step_size : length(data)
        
        % Extract new point from data buffer
        new_points = data(i-step_size + 1 : i, columns);
        
        % Add to SVDD
        for j = 1 : length(new_points)
            W = inc_add(W, new_points(j,:), 1);
        end
        
        % Remove first point from SVDD
        if i >= (from + block_size)
            
            for j = 1 : length(new_points)
                W = inc_remove(W,1);
            end
            from = from + step_size;
        end
        
        
        % Get mapping representations
        w0 = inc_store(W);
        w = +w0;

        offs(counter,:) = [i, w.offs];

        % Draw mapping and points
        [h_data, h_SVs, h_new_points, h_boundary] = draw_data_and_boundary(data, from:i, columns, w0, w, i-step_size:i, counter == 1);

        handles = [h_data(1), h_SVs(1), h_new_points(1)];
        texts = {['Data (' int2str(i-from+1+step_size) ') '], ['Support Vectors (' int2str(length(w.sv)) ') '], ['New Point (' int2str(i) ') '] ''};
        
        if numel(h_boundary) ~= 0
            handles(4) = h_boundary(1);
            texts{4} = 'Boundary';
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
   
end



function [h_data, h_SVs, h_new_points, h_boundary] = draw_data_and_boundary(data, rows, columns, w, W, indices_new, clear_persistance)
    persistent offsets
    persistent thresholds;
    
    if clear_persistance; offsets = []; thresholds = []; end
    
    
    % Check which (new) data points are outliers
    new_data = data(rows, columns)
    new_data_mapped = +(new_data * w)
    threshold = W.threshold
    indices_outliers = abs(new_data_mapped(:,1)) - 0.0001 > (threshold)
    
    
    % Select the window with mapped data and boundary
    sfigure(1); cla; axis auto;
    
    h_data          = scatterd(data(rows, columns), 'k*');      % Only draw first two features
    axis auto; hold on;
    h_SVs           = scatterd(W.sv, 'r*');                     % Points acting as Support Vector
    axis auto; hold on;
    h_new_points    = scatterd(data(indices_new, columns), 'g*');
    axis auto; hold on;
    
    if length(find(indices_outliers > 0 ))
        h_outliers      = scatterd(new_data(indices_outliers, columns), 'ko');
        axis auto; hold on;
        
        % TODO: plot the total distance from the outliers to the
        % hypersphere, using the `new_mapped_data` and `threshold` values.
    end
    
    h_boundary      = plotc(w, 'b');
    axis auto; hold on;

    offsets(end+1,:) = [indices_new(end) W.offs]; 
    thresholds(end+1,:) = [indices_new(end) W.threshold]; 
    
    % Draw the offs in the window
    sfigure(2);
    cla;
    hold on;
    plot(offsets(:,1), offsets(:,2), 'b', 'LineWidth', 1.5 );
    plot(thresholds(:,1), thresholds(:,2), 'g', 'LineWidth', 1.5 );
    drawnow;
    
end