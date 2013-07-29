function [ datapoints, change_points ] = load_sin_wave_data( data_length, segment_amplitudes, segment_snrs )
%LOAD_SIN_WAVE_DATA Summary of this function goes here
%   Detailed explanation goes here


    if nargin < 1
        data_length = 1000;
    end
    
    if nargin < 2
        segment_amplitudes = [1 3 1 5 2];
    end
    
    if nargin < 3
        segment_snrs = [0.01 0.01 0.1 0.1 0.1];
    end

    if length(segment_amplitudes) ~= length(segment_snrs)
        return;
    end
    
    datapoints = zeros(data_length, 0);
    change_points = zeros(length(segment_amplitudes), 1);
    
    per_segment = ceil(data_length/ length(segment_amplitudes));
    for segment = 1 : length(segment_amplitudes)
        t = 1:per_segment;
        a = segment_amplitudes(segment);
        f = 1000;
        y = awgn(a * sin(f*t), segment_snrs(segment));
        datapoints = [datapoints y];
        change_points(segment) = ((segment - 1) * per_segment) + 1;
    end

end

