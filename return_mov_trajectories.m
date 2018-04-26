function [av_mov_traj, av_x_mov, av_y_mov] = return_mov_trajectories(mov_trialTimes, numtrials, sessionData, numbins)

% calculate average running trajectory during session:
% move movement trajectories of each trial into a cell: row1 x values, row2
% y values of position in maze   [ output_array ] = get_spatial_average( input_array, number_of_points  )
mov_traj = cell(numtrials,1);
for i = 1:numtrials
    
    trialTimes2use = mov_trialTimes(i,1): mov_trialTimes(i,2);
    mov_traj{i} = [sessionData(5,trialTimes2use); sessionData(6, trialTimes2use)];
end
clear i

% apply the get_spatial_average function to each vector in the mov_traj cell
numbins = 50; % specify number of bins for averaging
av_mov_traj = cellfun(@(x) get_spatial_average(x, numbins), mov_traj, 'UniformOutput',false);

% extract average x and y movements from cell 
av_x_mov = zeros(numtrials, numbins);
av_y_mov = zeros(numtrials, numbins);
for i = 1:numtrials
    av_mov = av_mov_traj{i};
    av_x_mov(i,:) = av_mov(1,:);
    av_y_mov(i,:) = av_mov(2,:);
end

end