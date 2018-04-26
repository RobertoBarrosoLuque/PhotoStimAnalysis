%Script to compare stimulation after switches during different epochs (comparing stim during whole trial to only movement stim)
%Similar to CompareEpochStim file but uses preprocessed matrixes to save
%time also expands analysis to all trials in sessions (not only 50 after switch)

addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions\');
addpath('C:\Users\Roberto\Desktop\sync-master\')

%main file where all Preprocessed files are
Mfile = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\StimAnalaysis\';
%save file
Sfile = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\FiguresPhotoStim\Averages\';

ID = 18;
save = 0;
stimLocation = 'PPC\';


before = 20; after = 75;
%%
% %Run through all trial Data first
% StimPattern = 'Alltrial\';
% file2load = strcat(Mfile,stimLocation,StimPattern,int2str(ID));
% [ dirL ] = dir(strcat(file2load));
% 
% AvgASAllTrial = []; LRasAllTrial= []; %average after switch and averages left right after switch
% 
% %set size of window                AT = All Trial
% %TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;
% 
% AllStimAllTrial = [];AllNoStimAllTrial = []; diffsAT = [];CavgsAT = []; SavgsAT = [];
% stimLineAT = []; conLineAT = []; stimC = []; conC = [];
% 
% x = -20:50;
% 
% totalAvgStim = zeros(1,before+after+1); totalAvgNoStim = zeros(1,before+after+1);
% Stim_count = zeros(1,71);NoStim_count = zeros(1,71);
% stimAreas = {'ACC','Control'};
% 
% for i = 1:size(dirL,1)-2
%     
%     load(strcat(file2load,'\',dirL(i+2).name,'\Preprocessed'))
%     
%     trial_switch = PreProcessed.trial_switch;
%     sessionData = PreProcessed.sessionData;
%     TrialInf = PreProcessed.TrialInf;
%     
%     
%     %    only use first two blocks
%     if length(trial_switch)>=3
%         trial_switch = trial_switch(1:3);
%     else
%         continue
%     end
%     
%     [IMG,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after, TrialInf,trial_switch,0);
%     AllStimAllTrial= [AllStimAllTrial; AvgStim]; AllNoStimAllTrial = [AllNoStimAllTrial; AvgNoStim];
%     
%     
%     [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,50,stimAreas,0);
%     AvgASAllTrial = [AvgASAllTrial;AVGs']; LRasAllTrial= [LRasAllTrial;[AVGsLR(1,:) AVGsLR(2,:)]];
%     
%     
%     %WINDOW PERFORMANCES
%     [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);
%     
%     diffsAT = [diffsAT;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
%     
%     CavgsAT =[CavgsAT;controlAVGs'];
%     SavgsAT=[SavgsAT;stimAVGs'];
%     
%     %fit line and save coefficients
%     [yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,1,50);
%     stimLineAT = [stimLineAT;yStim]; conLineAT = [conLineAT;yCon];
%     stimC = [stimC;coeffStim]; conC = [conC;coeffCon];
%     
%     
% end
% %perform ttest to test for significance between ACC mean and Control mean
% [h,P] =ttest2(AvgASAllTrial(:,1),AvgASAllTrial(:,2));
% %calculate mean performance for ALL trial Stimulation
% DaysAvgStimAllTrial = nanmean(AllStimAllTrial); DaysAvgNoStimAllTrial = nanmean(AllNoStimAllTrial);
% 
% [ALLT]=DiffSign(diffsAT,CavgsAT,SavgsAT);
% P = mtit(strcat('ID: ',int2str(ID),' All Tial'));
% 
% 
% EP1 = figure('rend','painters','pos',[10 10 900 600]); 
% s = plot([-before:after],DaysAvgStimAllTrial,'b');hold on
% p = plot([-before:after],DaysAvgNoStimAllTrial,'k');hold off
% title(strcat('All Trial: ',int2str(ID)))
% shadedErrorBar(x,AllStimAllTrial,{@mean,@std},'lineprops','-b','transparent',1);
% shadedErrorBar(x,AllNoStimAllTrial,{@mean,@std},'lineprops','-k','transparent',1);
% legend('Stim', 'No Stim','Location','southwest','Orientation','horizontal');
% ylabel('Performance')
% 
% 
% stimCavgAT = mean(stimC);
% conCavgAT = mean(conC);
% 
% [fitAll] = figure('rend','painters','pos',[10 10 900 600]);
% subplot(2,3,[1:2])    
% FitLog_Line_Growth(DaysAvgNoStimAllTrial(21:end),0);
% subplot(2,3,[4:5]);
% FitLog_Line_Growth(DaysAvgStimAllTrial(21:end),1);
% 
% PlotSwitchLine(stimLineAT,conLineAT,stimCavgAT,conCavgAT)
% P = mtit(strcat('ID: ',int2str(ID),' All Tial'));
% 
% if save == 1
%     saveas(ALLT,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'ALLTdifferences'),'png')
%     saveas(fitAll,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'fitALL'),'png') 
%     saveas(EP1,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'AllTtrace'),'png')
% end 

%%
%Run through Movement Stim Data 


StimPattern = 'Movement\';
file2load = strcat(Mfile,stimLocation,StimPattern ,int2str(ID));
[ dirL ] = dir(strcat(file2load));

AvgASMove = []; LRasMove= []; %average after switch and averages left right after switch

%set size of window                AT = All Trial
%TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;

AllStimMove = [];AllNoStimMove = []; diffsMove = [];CavgsMove = []; SavgsMove = [];
stimLineMove = []; conLineMove = []; stimC = []; conC = [];

x = -20:75;

totalAvgStim = zeros(1,before+after+1); totalAvgNoStim = zeros(1,before+after+1);
Stim_count = zeros(1,71);NoStim_count = zeros(1,71);
stimAreas = {'ACC','Control'};

for i = 1:size(dirL,1)-2
    
    load(strcat(file2load,'\',dirL(i+2).name,'\Preprocessed'))
    
    trial_switch = PreProcessed.trial_switch;
    sessionData = PreProcessed.sessionData;
    TrialInf = PreProcessed.TrialInf;
    
    
    %    only use first two blocks
%     if length(trial_switch)>=3
%         trial_switch = trial_switch(1:3);
%     else
%         continue
%     end
    
    [IMG,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after, TrialInf,trial_switch,0);
    AllStimMove= [AllStimMove; AvgStim]; AllNoStimMove = [AllNoStimMove; AvgNoStim];
    
    
    [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,50,stimAreas,0);
    AvgASMove = [AvgASMove;AVGs']; LRasMove= [LRasMove;[AVGsLR(1,:) AVGsLR(2,:)]];
    
    
    %WINDOW PERFORMANCES
    [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);
    
    diffsMove = [diffsMove;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
    
    CavgsMove =[CavgsMove;controlAVGs'];
    SavgsMove=[SavgsMove;stimAVGs'];
    
    %fit line and save coefficients
    [yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,1,50);
    stimLineMove = [stimLineMove;yStim]; conLineMove = [conLineMove;yCon];
    stimC = [stimC;coeffStim]; conC = [conC;coeffCon];
    
    
end
%perform ttest to test for significance between ACC mean and Control mean
[h,P] =ttest2(AvgASMove(:,1),AvgASMove(:,2));
%calculate mean performance for ALL trial Stimulation
DaysAvgStimMove = nanmean(AllStimMove); DaysAvgNoStimMove = nanmean(AllNoStimMove);

[ALLMove]=DiffSign(diffsMove,CavgsMove,SavgsMove);
P = mtit(strcat('ID: ',int2str(ID),' Movement'));

stimCavgMove = mean(stimC);
conCavgMove = mean(conC);

[fitMove] =  figure('rend','painters','pos',[10 10 900 600]);
subplot(2,3,[1:2])
FitLog_Line_Growth(DaysAvgNoStimMove(21:end),0);
subplot(2,3,[4:5]);
FitLog_Line_Growth(DaysAvgStimMove(21:end),1);

PlotSwitchLine(stimLineMove,conLineMove,stimCavgMove,conCavgMove)
P = mtit(strcat('ID: ',int2str(ID),' Movement'));

if save == 1
    saveas(ALLMove,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'ALLMovedifferences'),'png')
    saveas(fitMove,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'fitMove'),'png')
end 

%%

% Run through feedback data 
StimPattern = 'Feedback\';


file2load = strcat(Mfile,stimLocation,StimPattern ,int2str(ID));
[ dirL ] = dir(strcat(file2load));

AvgASFB = []; LRasFB= []; %average after switch and averages left right after switch

%set size of window                AT = All Trial
%TrialInf(trial_switch(1):trial_switch(1)+50,10) =1;TrialInf(trial_switch(3):trial_switch(3)+50,10) =1;

AllStimFB = [];AllNoStimFB = []; diffsFB = [];CavgsFB = []; SavgsFB = [];
stimLineFB = []; conLineFB = []; stimC = []; conC = [];

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
%     if length(trial_switch)>=3
%         trial_switch = trial_switch(1:3);
%     else
%         continue
%     end
    
    [IMG,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after, TrialInf,trial_switch,0);
    AllStimFB= [AllStimFB; AvgStim]; AllNoStimFB = [AllNoStimFB; AvgNoStim];
    
    
    [~,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,50,stimAreas,0);
    AvgASFB = [AvgASFB;AVGs']; LRasFB= [LRasFB;[AVGsLR(1,:) AVGsLR(2,:)]];
    
    
    %WINDOW PERFORMANCES
    [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch);
    
    diffsFB = [diffsFB;dif]; %has control - stim for 1-10,11-20,21-20,31-40,41-50 windows
    
    CavgsFB =[CavgsFB;controlAVGs'];
    SavgsFB=[SavgsFB;stimAVGs'];
    
    %fit line and save coefficients
    [yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,1,50);
    stimLineFB = [stimLineFB;yStim]; conLineFB = [conLineFB;yCon];
    stimC = [stimC;coeffStim]; conC = [conC;coeffCon];
    
    
end
%perform ttest to test for significance between ACC mean and Control mean
[h,P] =ttest2(AvgASFB(:,1),AvgASFB(:,2));
%calculate mean performance for ALL trial Stimulation
DaysAvgStimFB = nanmean(AllStimFB); DaysAvgNoStimFB = nanmean(AllNoStimFB);

[ALLFB]=DiffSign(diffsFB,CavgsFB,SavgsFB);
P = mtit(strcat('ID: ',int2str(ID),' Feedback'));

stimCavgFB = mean(stimC);
conCavgFB = mean(conC);

[fitFB] =  figure('rend','painters','pos',[10 10 900 600]);
subplot(2,3,[1:2])
FitLog_Line_Growth(DaysAvgNoStimFB(21:end),0);
subplot(2,3,[4:5]);
FitLog_Line_Growth(DaysAvgStimFB(21:end),1);

PlotSwitchLine(stimLineFB,conLineFB,stimCavgFB,conCavgFB)
P = mtit(strcat('ID: ',int2str(ID),' Feedback'));

if save == 1
    saveas(ALLFB,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'ALLFBdifferences'),'png')
    saveas(fitFB,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'fitFB'),'png')
end 




%%
% Compare different stim epochs between them 

%first check if control traces between different trial types are different
%if not then average them all together
CompEp  = figure('rend','painters','pos',[10 10 900 600]);

% p = plot([-before:after],DaysAvgNoStimAllTrial,'k');hold on
% s = plot([-before:after],DaysAvgStimAllTrial,'b');
p = plot([-before:after],DaysAvgNoStimMove,'k');hold on
s = plot([-before:after],DaysAvgStimMove,'g');
p = plot([-before:after],DaysAvgStimFB,'m');hold off
title(strcat('Performance Around Switch :',int2str(ID)));
shadedErrorBar(-before:after,AllNoStimMove,{@mean,@std},'lineprops','-k','transparent',1);
% shadedErrorBar(x,AllNoStimAllTrial,{@mean,@std},'lineprops','-k','transparent',1);
% shadedErrorBar(x,AllStimAllTrial,{@mean,@std},'lineprops','-b','transparent',1);
shadedErrorBar(-before:after,AllStimMove,{@mean,@std},'lineprops','g','transparent',1);
shadedErrorBar(-before:after,AllStimFB,{@mean,@std},'lineprops','m','transparent',1);
legend('No Stim','Movement','Feedback','Location','southwest','Orientation','horizontal');

if after > 50
    hold on
    plot(50*ones(13,1),[0:.1:1.2],'k','HandleVisibility','off');
    hold off
end


if save == 1
    saveas(CompEp,strcat(Sfile,int2str(ID),'\',stimLocation,StimPattern,'CompEpoch'),'png')
end 


