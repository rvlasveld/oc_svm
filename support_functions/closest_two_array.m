function [ values ] = closest_two_array( original, discovered )
% CLOSEST_TWO_ARRAY Summary of this function goes here
%   Detailed explanation goes here

    values = zeros(size(original));
    for i = 1 : length(original)
        current_value = original(i);
        
        distances = abs(discovered - current_value);
        [~, index] = min(distances);
        values(i) = discovered(index);
    end
end

