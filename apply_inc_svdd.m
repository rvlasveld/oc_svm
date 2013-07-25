function [ output_args ] = apply_inc_svdd( data, columns )
%APPLY_INC_SVDD Summary of this function goes here
%   Detailed explanation goes here

%     pause on;
    % Running dataset, start with 1 points
%     a = data(1,columns);

    % Sliding windows configuration
    block_size = 40;
    step_size = 5;
    
    
    figure(3); clf; axis auto;
    
    plot(1:length(data), data(:,:));
    set(gca, 'XTick', 0:50:length(data));
    
    h_verticals = draw_vertical_lines([0 0]);
    
    figure(1); clf; axis auto;
    figure(2); clf; axis auto;
    set(gca, 'XTick', 0:50:length(data));
    
    % SVDD Parameters
    C       = 0.1;
    ktype   = 'r';          % RBF
    kpar    = 4;            % Sigma
%     x       = +a;           % Examples
%     y       = getoclab(a);  % Label of examples
%     y = ones(step_size, 1);
    
    first_block_size = max(1/C, step_size);
    
    % Create the SVDD
    W = inc_setup('svdd', ktype, kpar, C, data(1:first_block_size,columns), ones(first_block_size, 1) );
%     w0 = inc_store(W);
%     w = +w0;
    
    

    from = first_block_size;
    
    for i = first_block_size + step_size: step_size : length(data)
        
        % Extract new point from data buffer
        new_points = data(i-step_size + 1 : i, columns);
        
        % Add to SVDD
        for j = 1 : length(new_points)
            W = inc_add(W, new_points(j,:), 1);
        end
        
%         a = [a; new_point];
        
        % Remove first point from SVDD
        if i >= (from + block_size)
%             fprintf('Removing, i: %i, from: %i , block_size: %i \n', i, from, block_size );
%             size(W.x)
            
            for j = 1 : length(new_points)
%                 fprintf('Removing... %i : (%f, %f) \n', j, W.x(1,1), W.x(1,2));
                W = inc_remove(W,1);
%                 size(W.x)
%                 W.x
                
            end
%             w0 = inc_store(W);
            from = from + step_size;
        end
        
        
        
        % Get mapping representations
        w0 = inc_store(W);
        w = +w0;
        fprintf( 'Block from %i to %i (new_points from %i); offs: %f \n', from - step_size + 1, i, i-step_size + 1, w.offs );
        
        % Draw mapping and points
        [h_data, h_SVs, h_new_points, h_boundary] = draw_data_and_boundary(data, from:i, columns, w0, w, i-step_size:i);
        
        legend([h_data(1) h_SVs(1) h_new_points(1) h_boundary(1)]', ['Data (' int2str(i-from+1+step_size) ') '], ['Support Vectors (' int2str(length(w.sv)) ') '], ['New Point (' int2str(i) ') '], 'Boundary');
        
        figure(3);
        yL = get(gca, 'YLim');
        set(h_verticals(1), 'XData', [from-step_size from-step_size], 'YData', yL );
        set(h_verticals(2), 'XData', [i i], 'YData', yL );
%         figure(1);
%         pause(0.01);
    end
    

    
end



function [h_data, h_SVs, h_new_points, h_boundary] = draw_data_and_boundary(data, rows, columns, w, W, indices_new)
%     W = +w;
    figure(1); clf;     axis auto;
    
    
    h_data          = scatterd(data(rows, columns), 'k*');      % Only draw first two features
    axis auto;
    hold on;
    h_SVs           = scatterd(W.sv, 'r*');             % Points acting as Support Vector
    axis auto;
    hold on;
    h_new_points    = scatterd(data(indices_new, columns), 'g*');
    axis auto;
    hold on;
    h_boundary      = plotc(w, 'b');
    axis auto;
    hold on;

    
    figure(2);
    hold on;
    scatter(indices_new(end), W.offs, 'b.');
    axis auto;
    hold on;
    
end