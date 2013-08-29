function [change_points, ratios, handles] = calculate_changepoints( properties, fields, method, varargin )
%CALCULATE_CHANGEPOINTS Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 2; fields = {'thresholds'}; end
    if nargin < 3; method = 'threshold';    end
    
%     change_points = data_values(change_points, 1);
%     ratios = data_values(ratios(:,1), 1);
%     change_points = unique(change_points(:,2));
%     ratios = unique(ratios(:,2

    if strcmp(class(fields), 'char')
        fields = {fields};
    end
    
    switch method
        
        case 'threshold'
            disp('- Using thresholding method');
            
            high = varargin{1};
            low  = varargin{2};
                
            if length(fields) == 1
                disp(['- For a single field ' fields{1}]);
                [change_points, ratios] = thresholding_single(properties, fields, high, low);
                
            else
                disp(['- For multiple fields ' cell2mat(fields) ]);
                [change_points, ratios] = thresholding_multiple(properties, fields, high, low);
            end
            
        otherwise
            disp('---')
            disp('Error: Unsupported change detection method.');
            disp('Supported methods include:');
            disp('   - threshold (high, low)');
    end
            

    % Plot ratios and changepoint in new figure
    sfigure(5); clf;
    plot(ratios(:,1), ratios(:,2));
    draw_vertical_lines(change_points(:,2), 'r');
    draw_horizontal_lines([high low], 'r');
    set(gca, 'XTick', 0:50:ratios(end,1));
    set(gca, 'YTick', 0:0.1:max(ratios(:,2)));
    
    % Plot change points in original data figure
    sfigure(4);
    handles = draw_vertical_lines(change_points(:,2), 'm');
end

function [change_points, ratios] = thresholding_multiple(properties, fields, high, low)
    % Use the thresholding method. Sum all the ratios of the data series
    % indicated by the fields.
    
    column = 2;     % Assume first column is time/index, second has value
    
    data_values = containers.Map();
    
    for i = 1 : length(fields)
        field = fields{i};
        field_values = cell2mat(values(properties, field));
        
        % Normalize the column with the values
        field_values(:,column) = mat2gray(field_values(:,column));
        
        data_values(field) = field_values;
    end
    
    if nargin < 3; high = 3;  end
    if nargin < 4; low = 0.2; end
    
    % Determine block sizes
    block_size = data_values(1,1) - data_values(3,1) + data_values(2,1);
    
    change_points = [1 1]; %zeros(size(data_values),2);
    ratios = zeros(size(data_values, 1),2);
    
    for i = 2 : length(data_values)
        time = data_values(i, 1);
        
        series = data_values(change_points(end,1):i,column);
        r = ratio(series, 10);
        ratios(i,:) = [time r];
        
%         if r > high
%             change_points(end+1,:) = [i time];
%         end
        
        % TODO: check block-compenstation for low values
        
%         if r < low
%             change_points(end+1,:) = [i time-block_size];
%         end;
        
    end

end


function [change_points, ratios] = thresholding_single(properties, field, high, low)
    % Use the thresholding method. Sum all the ratios of the data series
    % indicated by the fields.
    
    column = 2;     % Assume first column is time/index, second has value

    data_values = cell2mat(values(properties, field));
    
    if nargin < 3; high = 3;  end
    if nargin < 4; low = 0.2; end
    
    % Determine block sizes
    block_size = data_values(1,1) - data_values(3,1) + data_values(2,1);
    
    change_points = [1 1]; %zeros(size(data_values),2);
    ratios = zeros(size(data_values, 1),2);
    
    for i = 2 : length(data_values)
        time = data_values(i, 1);
        
        series = data_values(change_points(end,1):i,column);
        r = ratio(series);
        ratios(i,:) = [time r];
        
        if r > high
            change_points(end+1,:) = [i time];
        end
        
        % TODO: check block-compenstation for low values
        
        if r < low
            change_points(end+1,:) = [i time]; %-block_size];
        end;
        
    end

end