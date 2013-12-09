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
    column = 1;
    if size(values, 2) > 1; column = 2; end
    
    disp(['Merging with closeness: ' num2str(closeness) ' on column ' num2str(column)]);
    column
    values = sortrows(values, column)
    
    sfigure(4);
    draw_vertical_lines(values(:,column), 'g');
    
    % Copy last value to make sure it is considered as a change point
    values(end+1,:) = values(end,:);
    
    diffs = diff(values(:,column))
    diff_cp = diffs <= closeness
    
    [values(1:end-1,column) diffs diff_cp]
    
    
    too_close_indices = find(diff_cp == 1) + 1
    

    values(too_close_indices, :) = 0
    
    
    
    
    
%     diff_composed = [diff_cp values(1:end-1,3)]
    
%     indices = [];
%     splits = SplitVec(diff_cp)
%     counter = 1;
%     
%     for k = 1:length(splits)
%         k
%         counter
%         split = splits{k}
%         
% %         split_indices = cumsum(split)' + counter-1;
%         split_indices = cumsum(ones(size(split,1),1))' + counter-1;
%         split_indices
%         
%         disp('Values of this split:')
%         values(split_indices, :)
%         
%         if length(split) > 0
% 
%             if split(1) == 1 
%                 % Serie of large enough distances
%                 disp('Long series');
%                 if length(split) > 1
%                     disp('Length > 1, high passing change points');
% 
%                     % Only use values for high-passing change points
% 
%     %                 sum = cumsum(split)
%     %                 values(split_indices, :)
%     %                 low_cp_values = (values(sum + counter-1, 3) < 1)'
% 
%     %                 split = cumsum( (split' .* low_cp_values) )
% 
%     %                 split = cumsum(split) + counter;
%     %                 indices = unique([indices (split+counter)])
%                     indices = unique([indices split_indices]);
%     %                 values(indices,:)
%                 end
%             else
%                 % Serie of small distances.
%                 disp('Small distances');
% 
%                 % Determine whether to use first or last, depending on type
%                 if sum(values(split_indices, 3)) == 0
%                     % high-passing type, use first
%                     disp('Use first')
%                     use_changepoint = counter;
% 
%                     % Remove first changepoint of new segment
%                     if k < length(splits)
%                         split_next = splits{k+1}
%                         if split_next(1) == 1 
%                             % Next split has large value of next
%                             split_next = split_next(2:end)
%                             splits{k+1} = split_next
%                         end
%                     end
%                 else
%                     % low-passing type, use last
%                     disp('Use last')
%                     use_changepoint = counter + length(split);
%                 end
%                 indices
%                 use_changepoint
%                 indices = [indices use_changepoint];
%             end
%             counter = counter + size(split, 1);
%         else
%             counter = counter + 1;
%         end
%         indices
%     end

    merged_values = values(find(values(:,column) > 0 ),column)

end

