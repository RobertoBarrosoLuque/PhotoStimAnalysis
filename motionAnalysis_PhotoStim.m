function [Move,xdisp_avg,ydisp_avg] = motionAnalysis_PhotoStim(sessionData,TrialInf)
%for left_right use 0 for total average, 1 for left, 2 for right, 3 for
%--------------------------------------------Displacement Analysis------
rewardedTr = TrialInf(:,2);
correct = find(TrialInf(:,2)==1);
jL = find(TrialInf(:,9)==-1); jR = find(TrialInf(:,9)==1);
jC= find(TrialInf(:,5)==1);jG= find(TrialInf(:,5)==0);


%get number of trials, indexes of moving portion
[~, ~, ~, ~, indx_moving, ~, total_trials, ~] = return_BehavTimePoints(sessionData);
indx_moving(:,3)= TrialInf(:,2); %column 3 has reward or no reward
indx_moving(:,4)= TrialInf(:,10); %column 4 has stim or no stim
moving_traj = cell(total_trials,1); moving_traj_left = cell(length(indx_moving(jL,1:2)),1);
moving_traj_right = cell(length(indx_moving(jR,1:2)),1);
num_bins=50;


for nn = 1:total_trials
    UseTrials = indx_moving(nn,1):indx_moving(nn,2);
    moving_traj{nn} = [sessionData(5,UseTrials); sessionData(6,UseTrials)]; %get (x,y) coordinates for respective indices
end
clear nn

num_bins = 50; %number of bins for averaging
av_mov_traj = cellfun(@(x) get_spatial_average(x, num_bins), moving_traj, 'UniformOutput',false);

%initiate matrixes for movement averages
xdisp_avg = zeros(total_trials,num_bins); ydisp_avg=zeros(total_trials,num_bins);
%get averages
for n= 1:total_trials
    av_mov = av_mov_traj{n};
    xdisp_avg(n,:) = av_mov(1,:);
    ydisp_avg(n,:) = av_mov(2,:);
end

Move = figure;set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.25, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])

%--------------------------------------------------------------------------
%plot stim trials
stimTraj = find(TrialInf(:,10)==1);
subplot(4,4,[1 6]);xlim([-40 40]);ylim([0 200]); xlabel('Stim Displacement')
hold on
nn = 0;
for n = 1:length(stimTraj)
    nn = nn +1;
    ix = stimTraj(n);
    plot(moving_traj{ix,1}(1,:),moving_traj{ix,1}(2,:),'b')
end 
clear n
hold off

%Plot left stim trials
LeftStim = intersect(jL, stimTraj);  
subplot(4,4,[3 4]);xlim([-40 40]);ylim([0 200]); xlabel('Left')
hold on
nostim = 0;
for n = 1:length(LeftStim)
    n = LeftStim(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'b')
    nostim = nostim +1;
end 

%Plot Right stim trials
RightStim = intersect(jR, stimTraj); 
subplot(4,4,[7 8]);xlim([-40 40]);ylim([0 200]); xlabel('Right')
hold on
nostim = 0;
for n = 1:length(RightStim)
    n = RightStim(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'b')
    nostim = nostim +1;
end 




%--------------------------------------------------------------------------

%plot Non stim trials
NostimTraj = find(TrialInf(:,10)==0);
subplot(4,4,[9 14]);xlim([-40 40]);ylim([0 200]); xlabel('Non Stim Displacement')
hold on
nn = 0;
for n = 1:length(NostimTraj)
    nn = nn +1;
    ix = NostimTraj(n);
    plot(moving_traj{ix,1}(1,:),moving_traj{ix,1}(2,:),'k')
end 
clear n
hold off

%Plot left stim trials
LeftNoStim = intersect(jL, NostimTraj);  
subplot(4,4,[11 12]);xlim([-40 40]);ylim([0 200]); xlabel('Left')
hold on
nostim = 0;
for n = 1:length(LeftNoStim)
    n = LeftNoStim(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'k')
    nostim = nostim +1;
end 

%Plot Right stim trials
RightNoStim = intersect(jR, NostimTraj); 
subplot(4,4,[15 16]);xlim([-40 40]);ylim([0 200]); xlabel('Right')
hold on
nostim = 0;
for n = 1:length(RightNoStim)
    n = RightNoStim(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'k')
    nostim = nostim +1;
end 

end 