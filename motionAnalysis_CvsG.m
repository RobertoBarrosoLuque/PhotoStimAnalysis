function [xdisp_avg,ydisp_avg] = motionAnalysis_CvsG(sessionData,TrialInf,jC,jG,L_R)

%Same as motionAnalysis_RvsL but for grating vs non grating trials

trial_change = diff(sessionData(11,:));
rewardedTr = TrialInf(:,2);


%get number of trials, indexes of moving portion
[~, ~, ~, ~, indx_moving, ~, total_trials, ~] = return_BehavTimePoints(sessionData);
indx_moving(:,3)=rewardedTr;
moving_traj = cell(total_trials,1); moving_traj_left = cell(length(indx_moving(jC,1:2)),1);
moving_traj_right = cell(length(indx_moving(jG,1:2)),1);
num_bins=50;
xdisp_avg = zeros(total_trials,num_bins); ydisp_avg=zeros(total_trials,num_bins);
%place moving indices into a cell array

%ploting only correct trials
color = 'm'; type= '-';       %if input - jC and jG the left = Checker
correct_left = [];
for m = jC  
    if rewardedTr(m) == 1
        correct_left = [correct_left m];
    end
end
clear m
correct_right = [];
for m = jG %for trials were reward is on the right
    if rewardedTr(m) == 1               %if input - jC and jG the left = non-checker
        correct_right = [correct_right m];
    end
end
moving_traj_left = cell(length(correct_left),1);
moving_traj_right = cell(length(correct_right),1);


indx_moving_left = indx_moving(correct_left,1:2); trials_left = size(indx_moving_left,1);
indx_moving_right = indx_moving(correct_right,1:2); trials_right = size(indx_moving_right,1);
for nn = 1:trials_left
    UseTrials = indx_moving_left(nn,1):indx_moving_left(nn,2);
    moving_traj_left{nn} = [sessionData(5,UseTrials); sessionData(6,UseTrials)]; %get (x,y) coordinates for respective indices
end
clear nn
num_bins = 50; %number of bins for averaging
av_mov_trajL = cellfun(@(x) get_spatial_average(x, num_bins),   moving_traj_left, 'UniformOutput',false);


for nn = 1:trials_right
    UseTrials = indx_moving_right(nn,1):indx_moving_right(nn,2);
    moving_traj_right{nn} = [sessionData(5,UseTrials); sessionData(6,UseTrials)]; %get (x,y) coordinates for respective indices
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


if L_R == 0 %LEFT
subplot(4,4,[3 4]); xlim([-40 0]); ylim([0 200]); label ='Checker Trials';
else
subplot(4,4,[11 12]); xlim([0 40]); ylim([0 200]);  label ='Checker Trials';
end 

for u=1:size(indx_moving_left,1)
    start = indx_moving_left(u,1);
    endd = indx_moving_left(u,2);
    
    
    x_disp = sessionData(5,start:endd);
    y_disp = sessionData(6,start:endd);
    p = plot(x_disp,y_disp);
    set(p,'color', 'c')
    set(p, 'LineStyle', type)
    hold on
end
xdisp_avgL = mean(xdisp_avgL,1); ydisp_avgL = mean(ydisp_avgL,1);
hh = plot(xdisp_avgL,ydisp_avgL);
set(hh,'color', 'k');xlabel(label);
hold off


if L_R == 0 %LEFT
subplot(4,4,[7 8]); label ='Non-Checker Trials';
else
subplot(4,4,[15 16]); label ='Non-Checker Trials';
end 
for u=1:size(indx_moving_right,1)
    start = indx_moving_right(u,1);
    endd = indx_moving_right(u,2);
    
    
    x_disp = sessionData(5,start:endd);
    y_disp = sessionData(6,start:endd);
    p = plot(x_disp,y_disp);
    set(p,'color', 'c')
    set(p, 'LineStyle', type)
    hold on
end
xdisp_avgR = mean(xdisp_avgR,1); ydisp_avgR = mean(ydisp_avgR,1);
hh = plot(xdisp_avgR,ydisp_avgR);
set(hh,'color', 'k');xlabel(label);
hold off


end
