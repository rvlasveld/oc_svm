function [datapoints, change_points] = load_camci_data( data_length, segment_size, change_type )
% PAPER_DATASET Get the datasets as defined in the paper (by Camci?). Default length is
% 1000
%   Change_type can be {1,2,3}. The first has only change in mean, the
%   second has change in mean and variance and the last has only a change
%   in variance.

    if nargin < 1
        data_length = 1000;
    end

    if nargin < 2
        segment_size = 100;
    end

    if nargin < 3
        change_type = 1;
    end
    

    x = [1 2];
    
    mean = 0;
    variance = 1;
    for i = 3:data_length
        [mean, variance] = mean_and_var(i, data_length, segment_size, change_type, mean, variance);
        x(i) = 0.6*x(i-1) - 0.5*x(i-2) + normrnd(mean,variance);
    end
    
    datapoints = x;
    change_points = 1 : segment_size : data_length;
end


function [mean, variance] = mean_and_var(i, data_length, segment_size, type, mean, variance)

    if mod(i, segment_size) == 0
        y = i / segment_size;
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
    end
    
    if type == 2
        % Change in mean and variance. Mean already done in switch block
        variance = 0.1/(0.01 + (data_length - i)/data_length);
    end
    
end

