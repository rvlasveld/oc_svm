function change_points_shifted = replace_changepoints_after_unique( change_points, ai )
%REPLACE_CHANGEPOINTS_AFTER_UNIQUE Summary of this function goes here
%   Detailed explanation goes here


    prev_cp = 0;
    for i = 1 : length(change_points)
        cp = change_points(i);
        range_ai = find(ai > prev_cp & ai <= cp);
        
        diff_cp = cp - prev_cp;
        if length(range_ai) < diff_cp
            difference = diff_cp - length(range_ai);
            change_points(i:length(change_points)) = change_points(i:length(change_points)) - difference;
        end
        prev_cp = change_points(i);
    end

    
    change_points_shifted = change_points;

end

