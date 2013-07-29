function [ alphas, change_points ] = load_genertic_norm_dist_data(size,function_type)
% PROVIDE_DATA_BATCH Provide data in a offline manner of -size- elements
%   Detailed explanation goes here

    if nargin < 2
        function_type = 'alternating';
        
        if nargin < 1
            size = 100;            
        end
    end
    
    
    % Determine which generation function to use
    switch function_type
        case 'alternating'
            [alphas, change_points] = AlternatingVariance(size, 5, [1, 5, 1, 5, 1]);
        case 'paper'
            [alphas, change_points] = PaperExample();
        case 'homogeneous'
            [alphas, change_points] = AlternatingVariance(size, 1, 1);
        case 'single'
            [alphas, change_points] = AlternatingVariance(size, 2, [1, 2]);
        otherwise
            warning('Unexpected function type.');
    end

end



function [values, change_points] = AlternatingVariance(size, segments, variances)
% ALTERNATING_VARIANCE Generate a sequence of data with alternating
% variance. Mean is fixed at 0.
    fprintf('Generating alternating variance data \n');
    change_points = ones(segments-1,1);
    if nargin < 3
        variances = [1, 3, 1];
        
        if nargin < 2
            segments = 3;
            
            if nargin < 1
                size = 100;
            end
        end
    end
    
    values = zeros(1, size);
    per_segment = size / segments;   
    
    j = 1;
    for segment = 1:segments
        variance = variances(segment);
        fprintf('  new segment at %i with variance %i \n', j, variance );
        change_points(segment) = j;
        for i = 1:per_segment
            values(j) = normrnd(0, variance);
            j = j + 1;
        end
    end

end


function [values, change_points] = PaperExample()

    fprintf('Generating data following the scheme in the paper: \n');
    fprintf('  [1   : 391]: 1 \n');
    fprintf('  [391 : 518]: 0.365 \n');
    fprintf('  [518 : 700]: 1.033 \n');
    
    change_points = [391 518 700];
    
    values = zeros(1,700);
    for i=1:391
        values(i) = normrnd(0, 1);
    end
    for i=392:518
        values(i) = normrnd(0, 0.365);
    end
    for i=519:700
        values(i) = normrnd(0,1.033);
    end
end