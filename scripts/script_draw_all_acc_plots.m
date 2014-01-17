% series = {'run-1-walk-run-roemer', 'run-2-walk-run-jos', 'run-3-walk-turn-roemer', 'run-4-run-fountain-roemer', 'run-5-run-fountain-jos', 'run-6-walk-run-roemer'}; %, 'run-7-walk-run-jos'};
% % series = {'run-5-run-fountain-jos', 'run-6-walk-run-roemer', 'run-7-walk-run-jos'};
% series = {'run-5-run-fountain-jos'};
series = {'stairs-indoor/marc-1'};
% metrics = {'acc'; 'mag'; 'rot'};
% ylabels = {'Acceleration Force', 'Geometric Field Strenth', 'Degrees of Rotation'};
metrics = {'acc';};
ylabels = {'Acceleration Force'};
columns = {2:4}; %; 5:7; 8:10};

sfigure(1); clf;
% Position figure
screenSize = get(0,'ScreenSize');
plot_width  = screenSize(3);
plot_height = screenSize(4) / 4;
sfigure(1); 
% set(gcf,'Position',[0 (screenSize(4) - plot_height) plot_width plot_height]);
% set(gcf,'PaperPositionMode','auto')

% Let the white drawing area take all the available space of the window
set(0,'DefaultAxesLooseInset',[0.03,0,0.03,0])

for serie_i = 1 : length(series)
    serie = series{serie_i};
    script_load_acc_data; % --> this loads the `data` variable
    
    % Load annotated change points into variable 'cp'
%     load(['data/collections/running-outside-almende/' serie '/change_points.mat']);
    load(['data/collections/' serie '/change_points.mat']);
    % Load annotated labels into variable 'labels'
%     load(['data/collections/running-outside-almende/' serie '/labels.mat']);
load(['data/collections/' serie '/labels.mat']);
    % Load found change points into variable 'v_run'
%     load(['data/collections/values-run-' num2str(serie_i) '.mat']);
    load(['data/collections/values-run-8.mat']);
    for k = 1 : length(cp)
        disp([num2str(cp(k)) ': ' labels{k}]);
    end
    
    for j = 1 : length(columns)
        disp(['Start drawing for serie: ' serie ', metrics: ', metrics{j}]);
        column = columns{j};
        try 
            
            clf; axis auto;
            plot(data(:,1), data(:,column));
            draw_vertical_lines(cp, 'k');
            draw_vertical_lines(v_run(:,2),'m', 1, '--');
            
            set(gca, 'XTick', 0:ceil(data(end,1)/25):data(end, 1));
            xlim([0 data(end,1)]);
            
            xlabel('Time (s)', 'FontSize', 15 );
            ylabel( ylabels{j}, 'FontSize', 15 );
            set(gca, 'FontSize', 12 );
            
            filename = ['data/collections/' serie '/data_plot_' metrics{j} '_with_discovered_cps.eps'];
            print('-depsc2','-r300',filename);
            disp(['Saved ' filename]);
        catch err
            disp(['Could not get properties for ' serie ', ' metrics{j}]);
            disp err;
        end
    end
end