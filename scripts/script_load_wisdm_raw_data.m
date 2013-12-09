data = load('data/wisdm/raw.txt');

% Use only fraction of data
% data = data(8490:14353,:);
data = data(1:2900, : );

% Store performed activities
activities = data(:,2);

% Process the time-column: it is the number of nanoseconds of phone's time
% powered.
times = data(:,3);

% Use first time value to create offset, and use seconds
times = times - times(1);
times = times ./ 1000000000;

sfigure(1);
clf;
hold on;

plot(times, data(:,4:6));
xlabel('Time (s)');
ylabel('Accelerometer');