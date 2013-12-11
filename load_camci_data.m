% LOAD_CAMCI_DATA Get the datasets as defined in the paper (by Camci). 
%
%       [DATA, CP] = LOAD_CAMCI_DATA( LENGTH, SEGMENT_SIZE, CHANGE_TYPE)
%
%   Default DATA_LENGTH is 1000.
%   Default SEGMENT_SIZE is 100.
%   CHANGE_TYPE can be {1 (default),2,3}. The first has only change in mean
%   , the second has change in mean and variance and the last has only a 
%   change in variance.

function [datapoints, change_points] = load_camci_data( change_type, data_length, segment_size)
    
    if nargin < 1; change_type  = 1; end
    if nargin < 2; data_length  = 10000; end
    if nargin < 3; segment_size = 1000; end
    
    

    x = [0; 0];
    
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
    end
    
    datapoints = x;
    change_points = 1 + segment_size : segment_size : data_length;
end

function [mean, variance] = mean_and_var(i, data_length, segment_size, type, mean, variance)
    if mod(i, segment_size) == 0
        y = i / segment_size;
        switch type
            case 1
                % Change in mean with fixed difference (Camci)
                mean = y * 5;
            case 2
                % Change in mean with relative difference (Takeuchi and
                % Yamanishi, first set
                mean = mean + (10 - y);
            case 3
                % Change in mean (relatieve) and variance, Camci
                mean = mean + (10 - y);
                % Variance below
            case 4
                % Change in mean (absolute) and variance, Takeuchi
                mean = mean + 1;
                % Variance below
            case 5
                % Change in variance
                if mod(y,2) == 0
                    variance = 1;
                else
                    % variance = 9;
                    variance = 8.5;
                end
                
        end
    end
    
    if type == 3 || type == 4
        
        % Change in mean and variance. Mean already done in switch block
        variance = 0.1/(0.01 + (data_length - i)/data_length);
    end
end

