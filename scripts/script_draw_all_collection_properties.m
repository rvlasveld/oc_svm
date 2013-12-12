



sets = {'run-1-walk-run-roemer'}; %, 'run-2-walk-run-jos', 'run-3-walk-turn-roemer', 'run-4-run-fountain-roemer'}; %, 'run-5-run-foutain-jos', 'run-6-walk-run-roemer', 'run-7-walk-run-jos'};

for i = 1 : length(sets)
    setname = sets{i};
    
    load(['/Users/roemer/Documents/Study/Master/scriptie/programming/temporal_segmentaion/oc_svm/data/collections/running-outside-almende/' setname '/properties_acc_mag_rot_b_50_t_1_s_13.mat']);

%     data_set = eval(setname);

    sfigure(i*2); clf; cla;
    
    grid(gca,'minor');
    
    screenSize = get(0,'ScreenSize');
    plot_width  = screenSize(3);
    plot_height = screenSize(4) / 4;
    set(gcf,'Position', [0 (screenSize(4) - plot_height) plot_width plot_height]);
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'DefaultAxesLooseInset',[0.03,0,0.03,0])
    
%     plot(data_set);
    plot(data(:,1), data(:,2:10));
    grid(gca,'minor');
    legend(['Acc x', 'Acc y', 'Acc z', 'Mag x', 'Mag y', 'Mag z', 'Rot x', 'Rot y', 'Rot z']);
   
    sfigure(i*2);
    grid(gca,'minor');
    

    sfigure((i*2)+1); clf; cla;
    
    screenSize = get(0,'ScreenSize');
    plot_width  = screenSize(3);
    plot_height = screenSize(4) / 4;
    set(gcf,'Position',[0 (screenSize(4) - plot_height) plot_width plot_height]);
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'DefaultAxesLooseInset',[0.03,0,0.03,0])

%     p = eval(['properties_' setname]);
    p = properties;
    t = p('thresholds');
    plot(t(:,1), t(:,3));
    legend(['Hypersphere radius set ' num2str(i)]);
    grid(gca,'minor')

%     cps = eval(['cps_' setname]);
    cps = cp;
    draw_vertical_lines(cp, 'b', 1, '-');
   
    set(gcf,'DefaultAxesLooseInset',[0.03,0,0.03,0])
end
