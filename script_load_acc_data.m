% PRE-LOAD SOME ACCELEROMETER DATA
%
% This script pre-loads accelerometer data, into the variable 'data'.
% Special segments are available in 'downstairs' and 'upstairs'. The
% indices of that segments are in 'indices_downstairs' and
% 'indices_upstairs'.
% Some very ambiguous manually-chosen (activity ) change points are available
% in 'cp_seconds'

accelerometer = csvread('data/stand-downstairs-stand-upstairs-stand-downstairs-stand-upstairs-stand/20130404_150025/accelerometer.csv');
magnetic = csvread('data/stand-downstairs-stand-upstairs-stand-downstairs-stand-upstairs-stand/20130404_150025/magnetic_field.csv');
rotation = csvread('data/stand-downstairs-stand-upstairs-stand-downstairs-stand-upstairs-stand/20130404_150025/rotation.csv');


% Combine all the data and filter out unique timestamp rows
matrices = {accelerometer(:,2:5), magnetic(:,2:5), rotation(:,2:5)};
filtered = filter_unique_rows(matrices, 1);

acc = filtered{1};
mag = filtered{2};
rot = filtered{3};

data = [acc mag(:,2:4) rot(:,2:4)];

% data = accelerometer(:,2:5);     % Enable this to use a single data set

% Normalize data (bring to range 0-1)
for i = 2 : size(data, 2)
    data(:,i) = mat2gray(data(:,i));
end

% indices_downstairs  = find(data(:,1) > 13 & data(:,1) < 23);
% indices_upstairs    = find(data(:,1) > 34 & data(:,1) < 43);

% downstairs          = data(indices_downstairs, 1:4);
% upstairs            = data(indices_upstairs, 1:4);

cp_seconds          = [7 13 22 27.5 29.5 34 43 48 49.5 55 63 68.5 70.5 76 85 90.5 92];
change_points       = zeros(length(cp_seconds), 1);

for i = 1 : length(cp_seconds)
    cp_indices = find(data(:,1) > cp_seconds(i));
    change_points(i) = cp_indices(1);
end

[data_unique, ai, ~] = unique(data(:,2:end), 'rows', 'stable');
change_points_shifted = replace_changepoints_after_unique(change_points, ai);