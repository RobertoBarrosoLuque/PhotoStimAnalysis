function [xdisp_avg, ydisp_avg] = motionAnalysis(sessionData,TrialInf)
%function will plot displacement of all trials and divide into two plots
%one for those were mouse went right and the other for trials were mouse
%went left. Inspired on  motionAnalysis_RvsL function. If session was a
%photstim session then function will also plot photostim trials divided
%into left and right trials


%get number of trials in session and the index of the moving portion of
%each trial
[~, ~, ~, ~, indx_moving, ~, total_trials, ~] = return_BehavTimePoints(sessionData);

%Add another column to indx_moving matrix with rewarded vs unrewarded trials
indx_moving(:,3)= TrialInf(:,2);

left_trials = find(TrialInf(:,9)==-1);
right_trials = find(TrialInf(:,9)==1);

% correct = find(TrialInf(:,2)==1);
% incorrect = find(TrialInf(:,2)==0);

%chech to see if session was a photostim session
if size(TrialInf,2)>9
    %photostim session get appropriate indexes
    
    stim_trials = find(TrialInf(:,10)==1);
    nonstim = find(TrialInf(:,10)==0);
    
    stim_left = intersect(left_trials,stim_trials);
    stim_right = intersect(right_trials,stim_trials);
    
    %update left and right trials to include only nonstim trials
    
    if isempty(stim_trials) == 0
        left_trials = intersect(left_trials,nonstim);
        right_trials = intersect(right_trials, nonstim);
    end
    
    moving_stim_left = cell(length(indx_moving(stim_left,1:2)),1);
    moving_stim_right = cell(length(indx_moving(stim_right,1:2)),1);
    
end

%intitiate cell arrays
moving_traj_left = cell(length(indx_moving(left_trials,1:2)),1);
moving_traj_right = cell(length(indx_moving(right_trials,1:2)),1);

%-------------------------------------------------------------------------------------------------------------------
count = 0;
for nn = left_trials
    count = count+ 1; 
    UseTrials = indx_moving(nn,1):indx_moving(nn,2);
    moving_traj_left{count} = [sessionData(5,UseTrials); sessionData(6,UseTrials)]; %get (x,y) coordinates for respective indices
end
clear nn
num_bins = 50; %number of bins for averaging
av_mov_trajL = cellfun(@(x) get_spatial_average(x, num_bins),   moving_traj_left, 'UniformOutput',false);

count = 0;
for nn = trials_right
    count = count+ 1; 
    UseTrials = indx_moving(nn,1):indx_moving(nn,2);
    moving_traj_right{count} = [sessionData(5,UseTrials); sessionData(6,UseTrials)]; %get (x,y) coordinates for respective indices
end
clear nn
num_bins = 50; %number of bins for averaging
av_mov_trajR = cellfun(@(x) get_spatial_average(x, num_bins),   moving_traj_right, 'UniformOutput',false);



%initiate matrixes for movement averages
xdisp_avgL = zeros(1,num_bins); ydisp_avgL=zeros(1,num_bins);
xdisp_avgR = zeros(1,num_bins); ydisp_avgR=zeros(1,num_bins);
%get averages
for n= 1:trials_left
    av_mov = av_mov_trajL{n};
    xdisp_avgL(n,:) = av_mov(1,:);
    ydisp_avgL(n,:) = av_mov(2,:);
end
clear n; clear av_mov;
for n= 1:trials_right
    av_mov = av_mov_trajR{n};
    xdisp_avgR(n,:) = av_mov(1,:);
    ydisp_avgR(n,:) = av_mov(2,:);
end






end