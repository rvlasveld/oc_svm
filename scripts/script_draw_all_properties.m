

sets = {'jumping_mean_camci', 'jumping_mean_takeuchi', 'jumping_variance', 'jumping_variance_and_mean_camci'};

for i = 1 : 4
    setname = sets{i};
    jumping_mean_camci;
    data_set = eval(setname);

    sfigure(i*2); clf; cla;
    
    grid(gca,'minor');
    
    screenSize = get(0,'ScreenSize');
    plot_width  = screenSize(3);
    plot_height = screenSize(4) / 4;
    set(gcf,'Position', [0 (screenSize(4) - plot_height) plot_width plot_height]);
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'DefaultAxesLooseInset',[0.03,0,0.03,0])
    
    plot(data_set);
    grid(gca,'minor');
    legend(['Data set ' num2str(i)]);
   
    sfigure(i*2);
    grid(gca,'minor');
    

    sfigure((i*2)+1); clf; cla;
    
    screenSize = get(0,'ScreenSize');
    plot_width  = screenSize(3);
    plot_height = screenSize(4) / 4;
    set(gcf,'Position',[0 (screenSize(4) - plot_height) plot_width plot_height]);
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'DefaultAxesLooseInset',[0.03,0,0.03,0])

    p = eval(['properties_' setname]);
    t = p('thresholds');
    plot(t(:,1), t(:,3));
    legend(['Hypersphere radius set ' num2str(i)]);
    grid(gca,'minor')

    cps = eval(['cps_' setname]);
    draw_vertical_lines(cps(2:end-1), 'r', 1, '-');
   
    set(gcf,'DefaultAxesLooseInset',[0.03,0,0.03,0])
end
