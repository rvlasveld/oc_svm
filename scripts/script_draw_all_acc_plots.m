series = {'run-1-walk-run-roemer'}; %, 'run-2-walk-run-jos', 'run-3-walk-turn-roemer', 'run-4-run-fountain-roemer'}; %, 'run-5-run-foutain-jos', 'run-6-walk-run-roemer', 'run-7-walk-run-jos'};
% series = {'run-5-run-fountain-jos', 'run-6-walk-run-roemer', 'run-7-walk-run-jos'};
metrics = {'acc'; 'mag'; 'rot'};
columns = {2:4; 5:7; 8:10};

sfigure(1); clf;
% Position figure
screenSize = get(0,'ScreenSize');
plot_width  = screenSize(3);
plot_height = screenSize(4) / 4;
sfigure(1); set(gcf,'Position',[0 (screenSize(4) - plot_height) plot_width plot_height]);

for i = 1 : length(series)
    serie = series{i};
    
    script_load_acc_data; % --> this loads the `data` variable
    
    for j = 1 : length(columns)
        disp(['Start drawing for serie: ' serie ', metrics: ', metrics{j}]);
        column = columns{j};
        try 
%             [properties, ~] = apply_inc_svdd(data, column, 50, 1, 0.1, 'r', 4);

            
            clf; axis auto;
            plot(data(:,1), data(:,column));
            set(gca, 'XTick', 0:ceil(data(end,1)/25):data(end, 1));
            xlim([0 data(end,1)]);
            
            
            
            filename = ['data/collections/running-outside-almende/' serie '/data_plot_' metrics{j} '.eps'];
            print('-depsc','-r300',filename);
            disp(['Saved ' filename]);
        catch err
            disp(['Could not get properties for ' serie ', ' metrics{j}]);
            disp err;
        end
    end
end