%FILTER_UNIQUE_ROWS Filter the rows of a set of matrices using a column
%
%   MATRICES = FILTER_UNIQUE_ROWS(MATRICES, KEY_COLUMN)
%
%   Filter the MATRICES by comparing the values in each KEY_COLUMN. If one
%   of the matrices has a value in the KEY_COLUMN which is unique, that
%   corresponding row is left out.
%
%   Input arguments:
%       - MATRICES: A -cell- structure of matrices. The can be of different
%       length and size. All the MATRICES must have a KEY_COLUMN in common.
%       - KEY_COLUMN: The column which all MATRICES have in common, used to
%       compare values and search for unique rows.
%
%   Output values:
%       - MATRICES: The -cell- structure with the MATRICES, where in each
%       matrix the unique rows, based on KEY_COLUMN, are filtered out.
%
%   Example:
%      matrices = {accelerometer(:,2:4), magnetic(:,2:4), rotation(:,2:4)};
%      filtered = filter_unique_rows(matrices, 1);
%      data = [accelerometer(:,2) filtered{1} filtered{2} filtered{3}];


function matrices = filter_unique_rows( matrices, key_column )

    if nargin < 2   key_column = 1; end

    nr = length(matrices);
    removals = cell(nr, nr);
    
    
    for i = 1 : nr
        for j = 1 : nr
            if i == j continue; end
                
                set_i = matrices{i};
                set_j = matrices{j};
                
                removals{i,j} = find(ismember(set_i(:,key_column), set_j(:, key_column)) == 0);
        end
    end
    
    for i = 1 : nr
        
        remove_indices = [];
        for j = 1 : nr
            remove_indices = [remove_indices removals{i,j}'];
        end
        
        set = matrices{i};
        set(remove_indices, :) = [];
        matrices{i} = set;
    end

end

