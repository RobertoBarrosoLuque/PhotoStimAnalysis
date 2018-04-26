%Script to compare stimulation between PPC experiments and ACC experiments

addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions\');
addpath('C:\Users\Roberto\Desktop\sync-master\')

%main file where all Preprocessed files are
Mfile = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\StimAnalaysis\';
%save file
Sfile = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\FiguresPhotoStim\Averages\';

ID = 16;
save = 1;

StimPattern = 'Movement\';

%%
%Run through all trial  ACC Data first
loc = 'ACC\'; loc = strcat(loc,StimPattern);
file2load = strcat(Mfile,loc,int2str(ID));
[ dirL ] = dir(strcat(file2load));

AvgASACC = []; LRasACC= []; %average after switch and averages left right after switch

%set size of window                AT = All Trial
%TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;
before = 20; after = 50;

AllStimACC = [];AllNoStimACC = []; diffsACC = [];CavgsACC = []; SavgsACC = [];
stimLineACC = []; conLineACC = []; stimC = []; conC = [];

x = -20:50;

totalAvgStim = zeros(1,before+after+1); totalAvgNoStim = zeros(1,before+after+1);
Stim_count = zeros(1,71);NoStim_count = zeros(1,71);
stimAreas = {'ACC','Control'};

for i = 1:size(dirL,1)-2
    
    load(strcat(file2load,'\',dirL(i+2).name,'\Preprocessed'))
    
    trial_switch = PreProcessed.trial_switch;
    sessionData = PreProcessed.sessionData;
    TrialInf = PreProcessed.TrialInf;
    
    
    %    only use first two blocks
    if length(trial_switch)>=3
        trial_switch = trial_switch(1:3);
    else
        continue
    end
    
    [IMG,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after, TrialInf,trial_switch,0);
    AllStimACC= [AllStimACC; AvgStim]; AllNoStimACC = [AllNoStimACC; AvgNoStim];
    
    
    [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,50,stimAreas,0);
    AvgASACC = [AvgASACC;AVGs']; LRasACC= [LRasACC;[AVGsLR(1,:) AVGsLR(2,:)]];
    
    
    %WINDOW PERFORMANCES
    [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);
    
    diffsACC = [diffsACC;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
    
    CavgsACC =[CavgsACC;controlAVGs'];
    SavgsACC=[SavgsACC;stimAVGs'];
    
    %fit line and save coefficients
    [yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,1,50);
    stimLineACC = [stimLineACC;yStim]; conLineACC = [conLineACC;yCon];
    stimC = [stimC;coeffStim]; conC = [conC;coeffCon];
    
    
end
%perform ttest to test for significance between ACC mean and Control mean
[h,P] =ttest2(AvgASACC(:,1),AvgASACC(:,2));
%calculate mean performance for ALL trial Stimulation
DaysAvgStimACC = nanmean(AllStimACC); DaysAvgNoStimACC = nanmean(AllNoStimACC);

[ALLT]=DiffSign(diffsACC,CavgsACC,SavgsACC);
P = mtit(strcat('ID: ',int2str(ID),' ACC'));

stimCavgACC = mean(stimC);
conCavgACC = mean(conC);

[fitAll] = figure('rend','painters','pos',[10 10 900 600]);
subplot(2,3,[1:2])
FitLog_Line_Growth(DaysAvgNoStimACC(21:end),0);
subplot(2,3,[4:5]);
FitLog_Line_Growth(DaysAvgStimACC(21:end),1);

PlotSwitchLine(stimLineACC,conLineACC,stimCavgACC,conCavgACC)
P = mtit(strcat('ID: ',int2str(ID),'ACC'));



%%


loc = 'PPC\';loc = strcat(loc,StimPattern);
file2load = strcat(Mfile,loc,int2str(ID));
[ dirL ] = dir(strcat(file2load));

AvgASPPC = []; LRasPPC= []; %average after switch and averages left right after switch

%set size of window                AT = All Trial
%TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;
before = 20; after = 50;

AllStimPPC = [];AllNoStimPPC = []; diffsPPC = [];CavgsPPC = []; SavgsPPC = [];
stimLinePPC = []; conLinePPC = []; stimC = []; conC = [];

x = -20:50;

totalAvgStim = zeros(1,before+after+1); totalAvgNoStim = zeros(1,before+after+1);
Stim_count = zeros(1,71);NoStim_count = zeros(1,71);
stimAreas = {'PPC','Control'};

for i = 1:size(dirL,1)-2
    
    load(strcat(file2load,'\',dirL(i+2).name,'\Preprocessed'))
    
    trial_switch = PreProcessed.trial_switch;
    sessionData = PreProcessed.sessionData;
    TrialInf = PreProcessed.TrialInf;
    
    
    %    only use first two blocks
    if length(trial_switch)>=3
        trial_switch = trial_switch(1:3);
    else
        continue
    end
    
    [IMG,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after, TrialInf,trial_switch,0);
    AllStimPPC= [AllStimPPC; AvgStim]; AllNoStimPPC = [AllNoStimPPC; AvgNoStim];
    
    
    [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,50,stimAreas,0);
    AvgASPPC = [AvgASPPC;AVGs']; LRasPPC= [LRasPPC;[AVGsLR(1,:) AVGsLR(2,:)]];
    
    
    %WINDOW PERFORMANCES
    [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);
    
    diffsPPC = [diffsPPC;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
    
    CavgsPPC =[CavgsPPC;controlAVGs'];
    SavgsPPC=[SavgsPPC;stimAVGs'];
    
    %fit line and save coefficients
    [yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,1,50);
    stimLinePPC = [stimLinePPC;yStim]; conLinePPC = [conLinePPC;yCon];
    stimC = [stimC;coeffStim]; conC = [conC;coeffCon];
    
    
end
%perform ttest to test for significance between ACC mean and Control mean
[h,P] =ttest2(AvgASPPC(:,1),AvgASPPC(:,2));
%calculate mean performance for ALL trial Stimulation
DaysAvgStimPPC = nanmean(AllStimPPC); DaysAvgNoStimPPC = nanmean(AllNoStimPPC);

[ALLT]=DiffSign(diffsPPC,CavgsPPC,SavgsPPC);
P = mtit(strcat('ID: ',int2str(ID),' PPC'));

stimCavgPPC = mean(stimC);
conCavgPPC = mean(conC);

[fitAll] = figure('rend','painters','pos',[10 10 900 600]);
subplot(2,3,[1:2])
FitLog_Line_Growth(DaysAvgNoStimPPC(21:end),0);
subplot(2,3,[4:5]);
FitLog_Line_Growth(DaysAvgStimPPC(21:end),1);

PlotSwitchLine(stimLinePPC,conLinePPC,stimCavgPPC,conCavgPPC)
P = mtit(strcat('ID: ',int2str(ID),'PPC'));


%%

%if not then average them all together
CompEp  = figure('rend','painters','pos',[10 10 900 600]);

p = plot([-before:after],DaysAvgNoStimPPC ,'k');hold on
s = plot([-before:after],DaysAvgStimACC,'b');
p = plot([-before:after],DaysAvgStimPPC,'m');hold off
title(strcat('Performance Around Switch :',int2str(ID)));
shadedErrorBar(x,AllNoStimPPC,{@mean,@std},'lineprops','-k','transparent',1);
shadedErrorBar(x,AllStimACC,{@mean,@std},'lineprops','b','transparent',1);
shadedErrorBar(x,AllStimPPC,{@mean,@std},'lineprops','m','transparent',1);
legend('No Stim','ACC','PPC','Location','southwest','Orientation','horizontal');

