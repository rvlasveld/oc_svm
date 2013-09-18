function outputs = check_cp_with_all_plots( serie, metric, closeness )
%CHECK_CP_WITH_ALL_PLOTS Summary of this function goes here
%   Detailed explanation goes here
%     global properties;

    if nargin < 1; serie  = 'run-1-walk-run-roemer'; end;
    if nargin < 2; metric = 'thresholds'; end;
    if nargin < 3; closeness = 0.5; end;
    
    % Load raw data
    script_load_acc_data;
    times = data(:,1);
    
    % Load change points into variable 'cp'
    load(['data/collections/running-outside-almende/' serie '/change_points.mat']);
    outputs = containers.Map();
    outputs('annotated') = cp;
    
    inputs = {'acc'; 'acc_mag'; 'acc_mag_rot'; 'mag'; 'mag_rot'; 'rot'; 'acc_rot'};
    input_indices = {1:4; 1:7; 1:10; [1 5:7]; [1 5:10]; [1 8:10]; [1:4 8:10]};
%     lengths = [50 80];
%     block_lengths = [50];

    % Let the white drawing area take all the available space of the window
    set(0,'DefaultAxesLooseInset',[0.03,0,0.05,0])

    for i = 1 : length(inputs)
        input = inputs{i};
        for j = 1 : 1 % length(block_lengths)
            % block_length = block_lengths(j);
            block_length = 50;
            
            disp(['Loading file for metric "' input '" and block length ' int2str(block_length)]);
            
            change_points = [];
            
            filename = ['data/collections/running-outside-almende/' serie '/matlab_properties_' input '_block_' int2str(block_length) '_step_1_sigma_13.mat'];
            
            if exist(filename, 'file') == 2
                loaded = load(filename, 'properties');
                properties = getfield(loaded, 'properties');
%                 Variable 'properties' is now loaded
                
                metric_series = properties(metric);
                
                [change_points, ~, ~, handles] = calculate_changepoints(properties, metric, 'threshold', 1.5, 0.8);
                h = sfigure(5);
                % Close the generate windows (by calculate_changepoints)
                
                
                % Calculate offset of used data for properties
%                 offset = length(data) - length(metric_series);
%                 time_offset = data(offset, 1);
%                 time_offset
                time_offset = 0;
                
                change_points = change_points(:,2) + time_offset;
%                 times_for_change_points = times(change_points');
                times_for_change_points = change_points;
                change_points
                
                diff_cp = diff(times_for_change_points);
                large_enough_indices = find(diff_cp > closeness);
                
                
%                 change_and_time = [change_points(large_enough_indices) times_for_change_points(large_enough_indices)]
                times = times_for_change_points(large_enough_indices);
                
                
%                 change_points(end,1)


                % Draw original signal, calculated CPs and annotated CPs
                
                f = sfigure(i + 10); clf; cla; hold on;
                screenSize = get(0,'ScreenSize');
                plot_width  = screenSize(3);
                plot_height = screenSize(4);
                set(gcf,'Position',[0 (screenSize(4) - plot_height) plot_width plot_height]);
                
                subplot(211);
%                 clf;
                cla;
                set(gca, 'XTick', 0:2:data(end,1));
                
                data_to_plot = data(:,input_indices{i});
                
                plot(data(:,1), data_to_plot(:,2:end), 'linestyle', '-');
                draw_vertical_lines(cp, 'k', 2, '--');
                
                if length(times) > 0
%                     draw_vertical_lines(change_and_time(:,2), 'm', 2, '--');
                    draw_vertical_lines(times, 'm', 2, '--');
                end
                
                axis([0 data(end,1) 0 1]);
%                 f = 
                
%                 plot(data(:,1), data_to_plot(:,2:end), 'linestyle', '-');
%                 clf;
%                 f = sfigure(5);
%                 childs = allchild(gcf)
%                 sfigure(i+10);
                f = subplot(212);
                cla;
                handles;
                copyobj(handles, f);
                axis([0 data(end,1) 0 3]);
                
                top = subplot(211);
                t = title(top, [input ' block size: ' int2str(block_length)]);
                set(t,'Interpreter','none');    % ignore underscores in title
                set(t, 'FontSize', 20);
                
            end
            
%             outputs(metric) = change_and_time;
            outputs(metric) = times;
            
        end
    end
    
%     close(4); close(5);

end

