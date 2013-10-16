%MERGE_CLOSE Merge change points that are close together
%   
%   MERGED = MERGE_CLOSE( VALUES, 10 );
%
%   Merge a series of increasing VALUES that are less than CLOSENESS
%   different from each.
%
%   The VALUES argument must be a n-by-3 matrix.
%   The first column is the index of the change point,
%   the second column is the timestamp of the change point and
%   the third column is the type of change:
%   - 0 indicates from low-to-high (passing high-threshold)
%   - 1 indicates from high-to-low (passing low-threshold)
%
% For 0-typed change points, the first `time` of a merged segment will be
% used.
% For 1-typed change points, the last `time` of a merged segment will be
% used.
%   
%   The returned MARGED contains all the VALUES(:,2) that have a larger gap
%   than CLOSENESS between them.
%
%   Input arguments:
%   - VALUES: the series to merge as an n-by-3 matrix
%   - CLOSENESS: the amount which the elements need to differ. Default: 5
%
%   Output value:
%   - MERGED: the merged elements of VALUES(:,2)

function merged_values = merge_changepoints( values, closeness )

    % Assume VALUES is a n-by-3 matrix.
    % The first column is the index i,
    % the second column in the timestamp and
    % the third column is the type of change:
    %   - 0 indicates from low-to-high (passing high-threshold)
    %   - 1 indicates from high-to-low (passing low-threshold)
    %
    % For 0-typed change points, the first `time` of a merged segment
    % should be used.
    % For 1-typed change points, the last `time` of a merged segment should
    % be used.

    if nargin < 2; closeness = 5; end
    
    values = sortrows(values, 2);
    
    diff_cp = diff(values(:,2)) > closeness;
    indices = [];
    splits = SplitVec(diff_cp);
    counter = 1;
    for k = 1:length(splits)
        split = splits{k};
        values(counter:counter+length(split)-1, 2)
        if split(1) == 1 
            % Serie of large enough distances
            
            if length(split) > 1
                
                % Only use values for high-passing change points
                sum = cumsum(split);
                low_cp_values = (values(sum + counter, 3) < 1)';
                split = cumsum( (split' .* low_cp_values) );
                
%                 split = cumsum(split) + counter;
                indices = [indices unique(split+counter)];
            end
        else
            % Serie of small distances.
            
            % Determine whether to use first or last, depending on type
            if values(counter, 3) == 0
                % high-passing type, use first
                use_changepoint = counter;
            else
                % low-passing type, use last
                use_changepoint = counter + length(split);
            end
            indices = [indices use_changepoint];
        end
        counter = counter + length(split);
    end

    merged_values = values(indices, 2);


end

