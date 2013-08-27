% Experiment: plot min, avg and max pairwise distances of data stream

function [ mins, avgs, maxs ] = distances( data, column, block_size, step )
%DISTANCES Summary of this function goes here
%   Detailed explanation goes here


    data_length = size(data,1);
    result_length = ceil(((data_length-block_size)/step)+1);
    avgs = zeros(result_length, 2);
    mins = zeros(result_length, 2);
    maxs = zeros(result_length, 2);
    
    from = 1;
    j = 1;
    for i = block_size : step : data_length
        time = data(i, 1);
        mins(j,1) = time;
        avgs(j,1) = time;
        maxs(j,1) = time;
        
        block = data(from:i, column);
        
        [mins(j,2), avgs(j,2), maxs(j,2)] = getProperties(block);
        from = from + step;
        j = j + 1;
    end

end


function [min_value, avg_value, max_value] = getProperties(block)

    distances = pdist(block);
    min_value = min(distances);
    avg_value = mean(distances);
    max_value = max(distances);
end

