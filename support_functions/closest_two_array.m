function [ values, s ] = closest_two_array( original, discovered )
% CLOSEST_TWO_ARRAY Summary of this function goes here
%   Detailed explanation goes here

    values = zeros(length(original),3);
    for i = 1 : length(original)
        current_value = original(i);
        
        distances = abs(discovered - current_value);
        [dist, index] = min(distances);
        values(i,:) = [current_value discovered(index) dist];
    end
    s = sum(values(:,3))
end

