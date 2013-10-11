series = {'run-1-walk-run-roemer'}; %, 'run-2-walk-run-jos', 'run-3-walk-turn-roemer', 'run-4-run-fountain-roemer'}; %, 'run-5-run-foutain-jos', 'run-6-walk-run-roemer', 'run-7-walk-run-jos'};
% series = {'run-5-run-fountain-jos', 'run-6-walk-run-roemer', 'run-7-walk-run-jos'};
metrics = {'acc'; 'acc_mag'; 'acc_mag_rot'; 'mag'; 'mag_rot'; 'rot'; 'acc_rot'};
columns = {2:4; 2:7; 2:10; 5:7; 5:10; 8:10; [2:4 8:10]};

for i = 1 : length(series)
    serie = series{i};
    
    script_load_acc_data; % --> this loads the `data` variable
    
    for j = 1 : length(columns)
        disp(['Starting inc_svdd for ' serie ', ' metrics{j}]);
        column = columns{j};
        try 
            [properties, ~] = apply_inc_svdd(data, column, 50, 1, 0.1, 'r', 4);
            filename = ['data/collections/running-outside-almende/' serie '/properties_' metrics{j} '_b_50_t_1_s_4.mat'];
            save(filename, 'properties');
            disp(['Saved ' filename]);
        catch err
            disp(['Could not get properties for ' serie ', ' metrics{j}]);
            disp err;
        end
    end
end