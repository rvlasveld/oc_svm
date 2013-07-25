% PRE-LOAD SOME ACCELEROMETER DATA
%
% This script pre-loads accelerometer data, into the variable 'data'.
% Special segments are available in 'downstairs' and 'upstairs'. The
% indices of that segments are in 'indices_downstairs' and
% 'indices_upstairs'.
% Some very ambiguous manually-chosen (activity ) change points are available
% in 'cp_seconds'

data = csvread('data/stand-downstairs-stand-upstairs-stand-downstairs-stand-upstairs-stand/20130404_150025/accelerometer.csv');
data = data(:,2:5);

indices_downstairs  = find(data(:,1) > 13 & data(:,1) < 23);
indices_upstairs    = find(data(:,1) > 34 & data(:,1) < 43);

downstairs          = data(indices_downstairs, 1:4);
upstairs            = data(indices_upstairs, 1:4);

cp_seconds          = [7 13 22 27.5 29.5 34 43 48 49.5 55 63 68.5 70.5 76 85 90.5 92 94];


% PREPARE DATA FOR INC_SVDD METHOD (WHICH HAS PROBLEMS WITH NON-UNIQUE
% VALUES AND MUST BE 2D [FOR NOW, TO REPRESENT BOUNDARY])
data2 = unique(data(200,length(data), [2 3]), 'rows', 'stable');