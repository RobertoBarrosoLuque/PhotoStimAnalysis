addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\sync-master')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\Downloaded Function')

%script to calculate and compare the performance for multiuple days on
%stable performance experiments
%Average performances

animal = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\16';
sessions =  {'\05-Feb-2018';'\06-Feb-2018';'\07-Feb-2018';'\08-Feb-2018';'\10-Feb-2018';'\12-Feb-2018';'\13-Feb-2018';'\14-Feb-2018';'\08-Mar-2018'};

%Calculates the average performance around switches according to before and
%after window

AvgAS = []; LRas= []; %average after switch and averages left right after switch

%set size of window
%TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;
before = 20; after = 40;

AllStim = [];AllNoStim = [];
x = -before:after;

totalAvgStim = zeros(1,before+after+1); totalAvgNoStim = zeros(1,before+after+1);
Stim_count = zeros(1,71);NoStim_count = zeros(1,71);

diffs = []; Cavgs =[]; Savgs=[];
for i = 1:size(sessions,1)
    sessions{i}
    [ dirL ] = dir(strcat(animal,sessions{i},'\'));
    load(strcat(animal,sessions{i},'\',dirL(end).name))

    filename = strcat(animal,sessions{i},'\session_1\sessionData');
    load(filename)

    [TrialInf] = TrialInformation(sessionData);

    stimInfo = sync.stimRecord;
    [stimInf,TrialInf,stimAreas] = StimInfo(sessionData, stimInfo, TrialInf);


    dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);

% % %     only use first two blocks
        if length(trial_switch)>=3
            trial_switch = trial_switch(1:3);
        else
            continue
        end

        [~,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after,TrialInf,trial_switch);
        AllStim= [AllStim; AvgStim]; AllNoStim = [AllNoStim; AvgNoStim];


        [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,40,stimAreas);
        AvgAS = [AvgAS;AVGs']; LRas= [LRas;[AVGsLR(1,:) AVGsLR(2,:)]];
        
        
        
        
        [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);
        
        diffs = [diffs;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
        
        Cavgs =[Cavgs;controlAVGs']; %each row is a different day
        Savgs=[Savgs;stimAVGs']; %each row is a different day


end
LR = nanmean(LRas);

C = bar([LR(1:2);LR(3:4)]);
legend('Right', 'Left')
legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
legend('Right', 'Left','Right', 'Left');lgd.FontSize = 6;
ylabel('Percentage Correct');ylim([0 1])
xticklabels({stimAreas{1};'No stim Block'});


DaysAvgStim = nanmean(AllStim); DaysAvgNoStim = nanmean(AllNoStim);

P = anova1(AvgAS(:,2),AvgAS(:,1));


figure;subplot(1,3,1:2)
s = plot([-before:after],DaysAvgStim,'b');hold on
p = plot([-before:after],DaysAvgNoStim,'k');hold off
title('Averaged Performance Whole Trial RB02')
shadedErrorBar(x,AllStim,{@mean,@std},'lineprops','-b','transparent',1);
shadedErrorBar(x,AllNoStim,{@mean,@std},'lineprops','-k','transparent',1);
legend('Stim', 'No Stim','Location','southwest','Orientation','horizontal');

AS = AllStim(:); NS = AllNoStim(:);

subplot(1,3,3)
%stim performance average after switch create box plot with scatter of
%individual trials
StimAVG_AF = nanmean(AvgAS(:,1));
NoStimAVG_AF = nanmean(AvgAS(:,2));

b = bar([StimAVG_AF NoStimAVG_AF]);
b.FaceColor='white';
xticklabels({'PPC', 'No Stim'});ylim([0 1])
hold on; varargout=sigstar([1 2], P);
scatter(ones(length(AvgAS(:,1)),1),AvgAS(:,1),'k')
text(.8,.1,strcat('N=',int2str(length(AvgAS(:,1))))); text(1.8,.1,strcat('N=',int2str(length(AvgAS(:,2)))));
scatter(2*ones(length(AvgAS(:,2)),1),AvgAS(:,2),'k');xlim([0 3])
title('Performance After Switch (wnd:40 trials)')
hold off