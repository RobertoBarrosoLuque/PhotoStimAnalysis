function [IMG5,xdisp_avg,ydisp_avg] = motionAnalysis_RvsL(sessionData,TrialInf)
%for left_right use 0 for total average, 1 for left, 2 for right, 3 for
%--------------------------------------------Displacement Analysis------
rewardedTr = TrialInf(:,2);
correct = find(TrialInf(:,2)==1);
jL = find(TrialInf(:,9)==-1); jR = find(TrialInf(:,9)==1);
jC= find(TrialInf(:,5)==1);jG= find(TrialInf(:,5)==0);


jLC = intersect(jL,jC); jLG = intersect(jL,jG);
jRC = intersect(jR,jC); jRG = intersect(jR,jG);
%get number of trials, indexes of moving portion
[~, ~, ~, ~, indx_moving, ~, total_trials, ~] = return_BehavTimePoints(sessionData);
indx_moving(:,3)= TrialInf(:,2);
moving_traj = cell(total_trials,1); moving_traj_left = cell(length(indx_moving(jL,1:2)),1);
moving_traj_right = cell(length(indx_moving(jR,1:2)),1);
num_bins=50;
xdisp_avg = zeros(total_trials,num_bins); ydisp_avg=zeros(total_trials,num_bins);

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

IMG5 = figure;set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.25, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])

%plot left trials ---------------------------------------------------------
subplot(4,4,[1 6]);xlim([-40 40]);ylim([0 200]); xlabel('Left Displacement')
hold on
nn = 0;
for n = 1:length(jL)
    nn = nn +1;
    ix = jL(n);
    plot(moving_traj{ix,1}(1,:),moving_traj{ix,1}(2,:),'c')
end 
AVGx =  mean(xdisp_avg(jL,:));
AVGy = mean(ydisp_avg(jL,:)); plot(AVGx,AVGy,'k');
clear n
hold off

%Plot left checker trials 
subplot(4,4,[3 4]);xlim([-40 40]);ylim([0 200]); xlabel('Checker')
hold on
nostim = 0;
for n = 1:length(jLC)
    n = jLC(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'c')
end 
AVGx =  mean(xdisp_avg(jLC,:));
AVGy = mean(ydisp_avg(jLC,:)); plot(AVGx,AVGy,'k');
hold off

%Plot left No-checker trials 
subplot(4,4,[7 8]);xlim([-40 40]);ylim([0 200]); xlabel('No Checker')
hold on
for n = 1:length(jLG)
    n = jLG(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'C')
end
AVGx =  mean(xdisp_avg(jLG,:));
AVGy = mean(ydisp_avg(jLG,:)); plot(AVGx,AVGy,'k');
hold off


%plot right trials ---------------------------------------------------------

subplot(4,4,[9 14]);xlim([-40 40]);ylim([0 200]); xlabel('Right Displacement')
hold on
nn = 0;
for n = 1:length(jR)
    nn = nn +1;
    ix = jR(n);
    plot(moving_traj{ix,1}(1,:),moving_traj{ix,1}(2,:),'g')
end 
AVGx =  mean(xdisp_avg(jR,:));
AVGy = mean(ydisp_avg(jR,:)); plot(AVGx,AVGy,'k');
clear n
hold off

%Plot left checker trials 
subplot(4,4,[11 12]);xlim([-40 40]);ylim([0 200]); xlabel('Checker')
hold on
nostim = 0;
for n = 1:length(jRC)
    n = jRC(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'g')
end 
AVGx =  mean(xdisp_avg(jRC,:));
AVGy = mean(ydisp_avg(jRC,:)); plot(AVGx,AVGy,'k');
hold off

%Plot left No-checker trials 
subplot(4,4,[15 16]);xlim([-40 40]);ylim([0 200]); xlabel('No Checker')
hold on
for n = 1:length(jRG)
    n = jRG(n);
    plot(moving_traj{n,1}(1,:),moving_traj{n,1}(2,:),'g')
end
AVGx =  mean(xdisp_avg(jRG,:));
AVGy = mean(ydisp_avg(jRG,:)); plot(AVGx,AVGy,'k');
hold off

end 