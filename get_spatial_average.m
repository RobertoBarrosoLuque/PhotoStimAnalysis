function [ output_array ] = get_spatial_average( input_array, number_of_points  )

% function from website: https://motorbehaviour.wordpress.com/2015/07/20/trajectory-analysis-toolbox-2d-spatial-average/

% input array: trajectory data with each row being a frame
% 1st column: x position, 2nd column: y position
% 2nd argument: number of points in the spatial average

input_array = input_array';

t = input_array(2:end,:) - input_array(1:end-1,:);
t(:,1) = t(:,1) .* t(:,1); %x-positions
t(:,2) = t(:,2) .* t(:,2); %y-positions
t = t(:,1) + t(:,2);
distance_array = sqrt(t);
path_distance = sum(distance_array);

output_array = ones(number_of_points,2) .* NaN;
output_array(1,:) = input_array(1,:);
output_array(end,:) = input_array(end,:);     % ADDED
points_index = 2;
distance_per_point = path_distance / (number_of_points - 1);

distance_travelled = 0;
for distance_index = 1:size(distance_array,1)-1
    if (distance_travelled + distance_array(distance_index) < distance_per_point)
        % Keep traveling.
        distance_travelled = distance_travelled + distance_array(distance_index);
    elseif (distance_travelled + distance_array(distance_index) == distance_per_point)
        % Add a point.
        display('      Lucky!');
        output_array(points_index,:) = input_array(distance_index+1,:);
        points_index = points_index + 1;
        distance_travelled = 0;
    else
        % Find a point between this one and the previous one.
        percent_distance = (distance_per_point - distance_travelled) / (distance_travelled + distance_array(distance_index) - distance_travelled);
        
        % Find new point that is between the two points.
        output_array(points_index,:) = input_array(distance_index,:) + ((input_array(distance_index+1,:) - input_array(distance_index,:)) .* percent_distance);
        
        points_index = points_index + 1;
        distance_travelled = distance_array(distance_index) * (1 - percent_distance);
    end
end
output_array = output_array';
