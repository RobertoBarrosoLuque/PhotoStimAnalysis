%Script to compare stimulation after switches during different epochs (comparing stim during whole trial to only movement stim)
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions\');
addpath('C:\Users\Roberto\Desktop\sync-master\')

animal = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\16';
ID = 16;

%sessionsE1: dates for first epoch (all trial stim)
sessionsE1 =  {'\05-Feb-2018';'\06-Feb-2018';'\07-Feb-2018';'\08-Feb-2018';'\10-Feb-2018';'\12-Feb-2018';'\13-Feb-2018';'\14-Feb-2018'};
sessionsE2 = {'\07-Mar-2018';'\09-Mar-2018';'\12-Mar-2018';'\14-Mar-2018';'\15-Mar-2018';'\16-Mar-2018';'\19-Mar-2018';'\20-Mar-2018';'\21-Mar-2018';'\22-Mar-2018';'\23-Mar-2018'};

sessionE3 = {'\01-Mar-2018';'\02-Mar-2018';'\05-Mar-2018';'\06-Mar-2018';'\26-Mar-2018';'\27-Mar-2018';'\28-Mar-2018';'\30-Mar-2018';'\02-Apr-2018';'\03-Apr-2018'};

%%
%Calculates the average performance around switches according to before and
%after window

AvgASAllTrial = []; LRasAllTrial= []; %average after switch and averages left right after switch

%set size of window
%TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;
before = 20; after = 50;

AllStimAllTrial = [];AllNoStimAllTrial = []; diffs = [];Cavgs = []; Savgs = [];
stimLine = []; conLine = []; stimC = []; conC = [];

x = -before:after;

totalAvgStim = zeros(1,before+after+1); totalAvgNoStim = zeros(1,before+after+1);
Stim_count = zeros(1,71);NoStim_count = zeros(1,71);
for i = 1:size(sessionsE1,1)
    sessionsE1{i}
    [ dirL ] = dir(strcat(animal,sessionsE1{i},'\'));
    load(strcat(animal,sessionsE1{i},'\',dirL(end).name))

    filename = strcat(animal,sessionsE1{i},'\session_1\sessionData');
    load(filename)
    
    [TrialInf] = TrialInformation(sessionData);
    stimInfo = sync.stimRecord;
    [stimInf,TrialInf,stimAreas] = StimInfo(sessionData, stimInfo, TrialInf);


    dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);

%    only use first two blocks
        if length(trial_switch)>=3
            trial_switch = trial_switch(1:3);
        else
            continue
        end

        [~,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after,TrialInf,trial_switch);
        AllStimAllTrial= [AllStimAllTrial; AvgStim]; AllNoStimAllTrial = [AllNoStimAllTrial; AvgNoStim];


        [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,40,stimAreas);
        AvgASAllTrial = [AvgASAllTrial;AVGs']; LRasAllTrial= [LRasAllTrial;[AVGsLR(1,:) AVGsLR(2,:)]];
        
        
        %WINDOW PERFORMANCES        
        [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);
        
        diffs = [diffs;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
        
        Cavgs =[Cavgs;controlAVGs'];
        Savgs=[Savgs;stimAVGs'];

        %fit line and save coefficients 
        [yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,1,50);
        stimLine = [stimLine;yStim]; conLine = [conLine;yCon];
        stimC = [stimC;coeffStim]; conC = [conC;coeffCon];
        
        

end

[h,P] =ttest2(AvgASAllTrial(:,1),AvgASAllTrial(:,2));

DaysAvgStimAllTrial = nanmean(AllStimAllTrial); DaysAvgNoStimAllTrial = nanmean(AllNoStimAllTrial);
%PLOT ONLY ALL TRIAL SESSIONS FIRST
EP1 = figure('rend','painters','pos',[10 10 900 600]); subplot(2,3,1:2)
s = plot([-before:after],DaysAvgStimAllTrial,'b');hold on
p = plot([-before:after],DaysAvgNoStimAllTrial,'k');hold off
title(strcat('All Trial: ',int2str(ID)))
shadedErrorBar(x,AllStimAllTrial,{@mean,@std},'lineprops','-b','transparent',1);
shadedErrorBar(x,AllNoStimAllTrial,{@mean,@std},'lineprops','-k','transparent',1);
legend('Stim', 'No Stim','Location','southwest','Orientation','horizontal');
ylabel('Performance')

subplot(2,3,3)
%stim performance average after switch create box plot with scatter of
%individual trials
StimAVG_AF = nanmean(AvgASAllTrial(:,1));
NoStimAVG_AF = nanmean(AvgASAllTrial(:,2));

b = bar([StimAVG_AF NoStimAVG_AF]);
b.FaceColor='white';
xticklabels({'ACC', 'No Stim'});ylim([0 1])
hold on; varargout=sigstar([1 2], P);
scatter(ones(length(AvgASAllTrial(:,1)),1),AvgASAllTrial(:,1),'k')
text(.8,.1,strcat('N=',int2str(length(AvgASAllTrial(:,1))))); text(1.8,.1,strcat('N=',int2str(length(AvgASAllTrial(:,2)))));
scatter(2*ones(length(AvgASAllTrial(:,2)),1),AvgASAllTrial(:,2),'k');xlim([0 3])
title('(wnd:40 trials)')

[ALLT]=DiffSign(diffs,Cavgs,Savgs);
stimCavg = mean(stimC);
conCavg = mean(conC);

[fitAll] = figure;
subplot(2,3,[1:2])
FitLog_Line_Growth(DaysAvgNoStimAllTrial(21:end),0);
subplot(2,3,[4:5]);
FitLog_Line_Growth(DaysAvgStimAllTrial(21:end),1);

PlotSwitchLine(stimLine,conLine,stimCavg,conCavg)
P = mtit(strcat('ID: ',int2str(ID),'All Tial'));




%%
%----------------------------Get Stim performance around switches for
%sessions with stim on movement phase only
AvgASMove = []; LRasMove= []; %average after switch and averages left right after switch

%set size of window
%TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;
before = 20; after = 50;

AllStimMove = [];AllNoStimMove = [];diffs2 = [];Cavgs2 = []; Savgs2 = [];
stimLine = []; conLine = []; stimC = []; conC = [];
x = -before:after;

totalAvgStim = zeros(1,before+after+1); totalAvgNoStim = zeros(1,before+after+1);
Stim_count = zeros(1,71);NoStim_count = zeros(1,71); 
for i = 1:size(sessionsE2,1)
    sessionsE2{i}
    [ dirL ] = dir(strcat(animal,sessionsE2{i},'\'));
    load(strcat(animal,sessionsE2{i},'\',dirL(end).name))

    filename = strcat(animal,sessionsE2{i},'\session_1\sessionData');
    load(filename)

    [TrialInf] = TrialInformation(sessionData);

    stimInfo = sync.stimRecord;
    [stimInf,TrialInf,stimAreas] = StimInfo(sessionData, stimInfo, TrialInf);


    dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);

    %only use first two blocks
        if length(trial_switch)>=3
            trial_switch = trial_switch(1:3);
        else
            continue
        end

        [~,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after,TrialInf,trial_switch);
        AllStimMove= [AllStimMove; AvgStim]; AllNoStimMove = [AllNoStimMove; AvgNoStim];


        [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,40,stimAreas);
        AvgASMove = [AvgASMove;AVGs']; LRasMove= [LRasMove;[AVGsLR(1,:) AVGsLR(2,:)]];

        
        [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);

        
        diffs2 = [ diffs2;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
        
        Cavgs2 =[Cavgs2;controlAVGs'];
        Savgs2=[Savgs2;stimAVGs'];
        
        %fit line and save coefficients
        [yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,1,50);
        stimLine = [stimLine;yStim]; conLine = [conLine;yCon];
        stimC = [stimC;coeffStim]; conC = [conC;coeffCon];

end
[h,P] =ttest2(AvgASMove(:,1),AvgASMove(:,2));

DaysAvgStimMove = nanmean(AllStimMove); DaysAvgNoStimMove = nanmean(AllNoStimMove);
%PLOT ONLY ALL TRIAL SESSIONS FIRST
subplot(2,3,4:5)
s = plot([-before:after],DaysAvgStimMove,'b');hold on
p = plot([-before:after],DaysAvgNoStimMove,'k');hold off
title(strcat('Movement Phase: ',int2str(ID)))

shadedErrorBar(x,AllStimMove,{@mean,@std},'lineprops','-b','transparent',1);
shadedErrorBar(x,AllNoStimMove,{@mean,@std},'lineprops','-k','transparent',1);
legend('Stim', 'No Stim','Location','southwest','Orientation','horizontal');
ylabel('Performance')


subplot(2,3,6)
%stim performance average after switch create box plot with scatter of
%individual trials
StimAVG_AF = nanmean(AvgASMove(:,1));
NoStimAVG_AF = nanmean(AvgASMove(:,2));

b = bar([StimAVG_AF NoStimAVG_AF]);
b.FaceColor='white';
xticklabels({'ACC', 'No Stim'});ylim([0 1])
hold on; varargout=sigstar([1 2], P);
scatter(ones(length(AvgASMove(:,1)),1),AvgASMove(:,1),'k')
text(.8,.1,strcat('N=',int2str(length(AvgASMove(:,1))))); text(1.8,.1,strcat('N=',int2str(length(AvgASMove(:,2)))));
scatter(2*ones(length(AvgASMove(:,2)),1),AvgASMove(:,2),'k');xlim([0 3])
title('(wnd:40 trials)')

%Plot different stim epochs in same graph 


ALLtraces = figure('rend','painters','pos',[10 10 900 600]);

s = plot([-before:after],DaysAvgStimAllTrial,'b');hold on
p = plot([-before:after],DaysAvgNoStimAllTrial,'k');
s = plot([-before:after],DaysAvgStimMove,'c');
p = plot([-before:after],DaysAvgNoStimMove,'m');hold off
title('Performance Around Switch RB01')
shadedErrorBar(x,AllStimAllTrial,{@mean,@std},'lineprops','-b','transparent',1);
shadedErrorBar(x,AllNoStimAllTrial,{@mean,@std},'lineprops','-k','transparent',1);
shadedErrorBar(x,AllStimMove,{@mean,@std},'lineprops','c','transparent',1);
shadedErrorBar(x,AllNoStimMove,{@mean,@std},'lineprops','m','transparent',1);
legend('Stim All Trial', 'No Stim All Trial','Stim Move','No Stim Move','Location','southwest','Orientation','horizontal');


[ALLM]=DiffSign(diffs2,Cavgs2,Savgs2);
stimCavg = mean(stimC);
conCavg = mean(conC);

[fitMove] = figure;
subplot(2,3,[1:2])
FitLog_Line_Growth(DaysAvgNoStimMove(21:end),0);
subplot(2,3,[4:5]);
FitLog_Line_Growth(DaysAvgStimMove(21:end),1);

PlotSwitchLine(stimLine,conLine,stimCavg,conCavg)
P = mtit(strcat('ID: ',int2str(ID),' Movement'));


saveas(ALLtraces,strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures PhotoStim\Averages\',int2str(ID),'\StimEpComp',int2str(ID)),'png');
saveas(EP1,strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures PhotoStim\Averages\',int2str(ID),'\EpAfterSwitch',int2str(ID)),'png');
saveas(ALLT,strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures PhotoStim\Averages\',int2str(ID),'\ALLTdifferences',int2str(ID)),'png');
saveas(ALLM,strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures PhotoStim\Averages\',int2str(ID),'\ALLMdifferences',int2str(ID)),'png');
saveas(fitAll,strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures PhotoStim\Averages\',int2str(ID),'\fitALL',int2str(ID)),'png');
saveas(fitMove,strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures PhotoStim\Averages\',int2str(ID),'\fitMove',int2str(ID)),'png');
