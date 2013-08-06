%RATIO Calculate the ratio of a value compared to a history of values
%
%   R = RATIO(VALUES, HISTORY, NEW_VALUE)
%
%   Calculate the ratio of the last entry of VALUES, of NEW_VALUE, compared
%   to all previous, or the last HISTORY number of entries.
%
%   The ratio is calucated as the NEW_VALUE devided by the mean of HISTORY
%   entries from VALUES.
%
%   Input arguments:
%       - VALUES: the vector of values to use in the calculation
%       - HISTORY: the number of previous entries to use (default: all)
%       - NEW_VALUE: the value to get the ratio from (default: the last of
%       VALUES)
%
%   Output values:
%       - R: The calculated ratio.
%

function ratio = ratio(values, history, new_value)
    if nargin < 2 history = length(values); end
    if nargin < 3 new_value = values(end); end
    
    mean_value = mean(values(max(end-history+1,1):end));
    ratio = new_value / mean_value;
end