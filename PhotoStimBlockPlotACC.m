function [PhotoStimFig,Avg_fig]=PhotoStimBlockPlotACC(TrialInf,trial_switch,stimAreas)
%use this function when stimulation is after stable performance to get
%percentage correct bars for stimulus vs non stimulus trials 

i = 0;
perStim = []; perNonStim = [];perRightStim = []; perLeftStim = [];perRight = []; perLeft = [];
 %these matrixes hold percent correct per each area stim
%on right left

%check to see if there sessin was ended after a photostim block started but
%before the ruls switch happened
% last_stim_trial = find(TrialInf(:,10)==1); last_stim_trial = last_stim_trial(end);
% if last_stim_trial > trial_switch(end) %session was ended before rule switch
%     trial_switch = [trial_switch last_stim_trial];
% end

for n= [1 trial_switch]
    i=i+1;
    %get start and end of the current rule block
    
    correct = find(TrialInf(:,2)==1);
    right = find(TrialInf(:,4)==-1);
    left = find(TrialInf(:,4)==1);
    if n == 1
        startB = 1; enddB = trial_switch(1);
        %find first stim trial for that block
        stim = find(TrialInf(startB:enddB,10)==1); %all stim trials for this block (why is this 52 instead of 50??)
        FirstStim = stim(1);
        no_stim30 = FirstStim-30: FirstStim -1;

    elseif n == trial_switch(length(trial_switch))
        startB = trial_switch(length(trial_switch));
        enddB=length(TrialInf);
        stim = find(TrialInf(startB+1:enddB-1,10)==1)+startB-1;
        
        if isempty(stim) == 0 %still got stim trials in last block
            FirstStim = stim(1);
            no_stim30 = FirstStim-30: FirstStim -1;
        else %no stim trials in last block 
            stim = NaN;
        end 
        
        
    else
        startB = n+1; enddB = trial_switch(i);
        
        stim = find(TrialInf(startB:enddB-1,10)==1)+startB-1; %all stim trials for this block (why is this 52 instead of 50??)
        FirstStim = stim(1);
        no_stim30 = FirstStim-30: FirstStim -1;

    end

        
    %get percentage correct For stim trials
    perStim(i) = length(intersect(stim,correct))/length(stim);
    stimR = intersect(stim,right);stimL = intersect(stim,left);
    
    perstimRight(i) = length(intersect(stimR,correct))/length(stimR); 
    perstimLeft(i) = length(intersect(stimL,correct))/length(stimL); 
    
    
    %get percentage correct For no stim trials
    perNonStim(i) = length(intersect(correct,no_stim30))/length(no_stim30);
    nostimR = intersect(no_stim30,right);nostimL = intersect(no_stim30,left);

    perRight(i) = length(intersect(nostimR,correct))/length(nostimR); 
    perLeft(i) =  length(intersect(nostimL,correct))/length(nostimL);
end


blocknum = length(trial_switch)+1;

Blocks = []; LeftRight = [];
for n=1:blocknum

    if perStim(n) == 0
        perStim(n)= NaN;
    elseif perNonStim(n) == 0
        perNonStim(n) = NaN;
    end 
    Blocks = [Blocks; perStim(n) perNonStim(n)];
    LeftRight = [LeftRight; perRight(n) perLeft(n) perstimRight(n) perstimLeft(n)];
    
    
end
stimAvg = mean(Blocks);


PhotoStimFig = figure;
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.25, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
subplot(2,1,1)
B = bar(Blocks);
hold on;
legend([B(1) B(2)],'ACC Stim', 'No Stim');
B(1).FaceColor = 'b'; B(2).FaceColor = 'k'; 

legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
%l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
xlabel('Block'); ylabel('Fraction Correct')
hold off

subplot(2,1,2)
C = bar(LeftRight);
hold on;C(1).FaceColor = 'k'; C(2).FaceColor = [.5 .5 .5]; C(3).FaceColor = 'b'; C(4).FaceColor = [0 0 .5];
legend([C(1) C(2) C(3) C(4)],'Right', 'Left','Right Stim', 'Left Stim');
legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
%l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
xlabel('Block'); ylabel('Fraction Correct')
hold off

av = nanmean(Blocks,1);
Avg_fig = figure; 
B = bar([av(1);av(2)]);
xticklabels({'ACC','Control'});B(1).FaceColor = 'k'; 

end