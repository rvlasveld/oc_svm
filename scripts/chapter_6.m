clear all;

closeness =         0.7;
outlier_fraction =  0.1;
upper_th =          1.2;
lower_th =          0.8;


sets = {'run-1-walk-run-roemer', 'run-2-walk-run-jos', 'run-3-walk-turn-roemer', 'run-4-run-fountain-roemer', 'run-5-run-fountain-jos', 'run-6-walk-run-roemer', 'marc-1'}; %, 'run-7-walk-run-jos'};

fars = [];
far = 0;
sum_delays = [];


for i = 1 : length(sets)
    setname = sets{i};
    
    if i < 7
    
        % var: properties
        load(['/Users/roemer/Documents/Study/Master/scriptie/programming/temporal_segmentaion/oc_svm/data/collections/running-outside-almende/' setname '/properties_acc_mag_rot_b_50_t_1_s_13.mat']);
        % var: cp
        load(['/Users/roemer/Documents/Study/Master/scriptie/programming/temporal_segmentaion/oc_svm/data/collections/running-outside-almende/' setname '/change_points.mat']);
    else
        % var: properties
        load(['/Users/roemer/Documents/Study/Master/scriptie/programming/temporal_segmentaion/oc_svm/data/collections/stairs-indoor/' setname '/properties_acc_mag_rot_b_50_t_1_s_4.mat']);
        % var: cp
        load(['/Users/roemer/Documents/Study/Master/scriptie/programming/temporal_segmentaion/oc_svm/data/collections/stairs-indoor/' setname '/change_points.mat']);
    end

    
    [calculated_cp, ratios, handles] = calculate_changepoints(properties, 'thresholds', 'threshold', closeness, outlier_fraction, upper_th, lower_th);
    
    [v_run, sum_diffs] = closest_two_array(cp, calculated_cp);
    
    % False alarm rate
    found = size(calculated_cp, 1);
    real  = size(cp, 2);
    this_far = max(0, (found - real)/found);
    fars(end+1) = this_far;
    far = far + this_far;
    
    delays = v_run(:,3);
    
    eval(['delays_' num2str(i) ' = delays']);
    
    sum_delays = [sum_delays; delays];
end

far/size(sets, 2)
% sum_delays
mean(sum_delays)
std(sum_delays)

% sfigure(5);
% draw_vertical_lines(cp, 'k');
% 
% 
% % Plot accelerometer data
% sfigure(1);
% clf;
% plot(accelerometer(:,2), accelerometer(:,3:5));
% set(gca, 'XTick', 0:2:accelerometer(end,2));
% xlim([0 accelerometer(end,2)]);
% 
% % Annotated change points
% draw_vertical_lines(cp);
% 
% % Discovered change points
% draw_vertical_lines(calculated_cp, 'm', 1, '--');
% 
% 
% cp'
% 
% calculated_cp
% 
% size(cp',1)
% size(calculated_cp,1)
% 
% sum_diffs