if ~exist('data_x', 'var' )
    data_x = load('data/uci_har/body_acc_x_train.txt');
    data_x(:,65:128) = [];
end
if ~exist('data_y', 'var' )
    data_y = load('data/uci_har/body_acc_y_train.txt');
    data_y(:,65:128) = [];
end
if ~exist('data_z', 'var' )
    data_z = load('data/uci_har/body_acc_z_train.txt');
    data_z(:,65:128) = [];
end

activities = load('data/uci_har/y_train.txt');

data = [data_x(:) data_y(:) data_z(:)];

% Use only activities for subject 25, which has the most data
data = data(5067:5476, :);

labels = {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'};

range = 1:length(data);

data2 = [range' data];

sfigure(1);
clf; hold on;
% [ax, h1, h2] = plotyy(range/50, data, range/50, activities(range));
% set(ax(1), 'YLim', [floor(min(min(data(range,:))) * 100)/100 ceil(max(max(data(range,:))) * 100)/100]);

plot(range/50, data);
xlabel('Time (s)');
ylabel('Accelerometer');


% set(ax(2), 'YLim', [1 6], 'YTick', 1:6, 'YTickLabel', labels, 'ycolor', 'm' );
% set(h2, 'LineWidth', 2);
% set(h2, 'Color', 'm');
% set(gca, 'XTick', 0:roundn(range(end)/25, 1):range(end));


% Number of occurences of each subject
% 281 8
% 302 5
% 308 7
% 316 11
% 321 22
% 323 14
% 325 6
% 328 15
% 341 3
% 344 29
% 347 1
% 360 19
% 366 16
% 368 17
% 372 23
% 376 27
% 382 28
% 383 30
% 392 26
% 408 21
% 409 25
