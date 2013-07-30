% LOAD_CAMCI_DATA Get the datasets as defined in the paper (by Camci). 
%
%       [DATA, CP] = LOAD_CAMCI_DATA( LENGTH, SEGMENT_SIZE, CHANGE_TYPE)
%
%   Default DATA_LENGTH is 1000.
%   Default SEGMENT_SIZE is 100.
%   CHANGE_TYPE can be {1 (default),2,3}. The first has only change in mean
%   , the second has change in mean and variance and the last has only a 
%   change in variance.

function [datapoints, change_points] = load_camci_data( data_length, segment_size, change_type )
    
    if nargin < 1; data_length  = 1000; end
    if nargin < 2; segment_size = 100; end
    if nargin < 3; change_type  = 1; end
    

    x = [0 0];
    
    mean = 0;
    variance = 1;
    for i = 3:data_length
        [mean, variance] = mean_and_var(i, data_length, segment_size, change_type, mean, variance);
        
        mod_i = mod(1, segment_size);
        new_value = normrnd(mean,variance);
        
        if mod_i == 1 || mod_i == 2
            x(i) = new_value;
        else
            x(i) = 0.6*x(i-1) - 0.5*x(i-2) + new_value;
        end
        
        fprintf( '=== Value for %i : %f, mean: %f, variance: %f === \n\n', i, x(i), mean, variance);
    end
    
    datapoints = x;
    change_points = 1 + segment_size : segment_size : data_length;
end

function [mean, variance] = mean_and_var(i, data_length, segment_size, type, mean, variance)
    
    if mod(i, segment_size) == 0
        y = i / segment_size;
        
        fprintf( '\n \n \n Switching for i: %i , y: %f \n', i, y );
        
        switch type
            case 1
                % Change in mean
                mean = y * 5;
            case 2
                % Change in mean and variance
                mean = mean + (10 - y);
                % Variance below
            case 3
                % Change in variance
                if mod(y,2) == 0
                    variance = 1;
                else
                    variance = 9;
                end
                
        end
        
        fprintf( 'Mean: %f, variance: %f \n', mean, variance );
    end
    
    if type == 2
        
        % Change in mean and variance. Mean already done in switch block
        variance = 0.1/(0.01 + (data_length - i)/data_length);
        fprintf( 'Variance: %f \n', variance );
    end
    
    fprintf( 'Mean: %f \n', mean );
    
end

