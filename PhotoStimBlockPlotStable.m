function [PhotoStimFig,Avg_fig]=PhotoStimBlockPlotStable(TrialInf,trial_switch,stimAreas)
%use this function to see how inhibiting an area consistently after stable
%performance affects percent correct

i = 0;
perNonStim_stimblock = []; perStim = []; perNonStim = [];
rPPC = [];lPPC = []; rS1 = []; lS1 =[];  rNS = []; lNS = []; %these matrixes hold percent correct per each area stim
%on right left

%check to see if there sessin was ended after a photostim block started but
%before the ruls switch happened
% last_stim_trial = find(TrialInf(:,10)==1); last_stim_trial = last_stim_trial(end);
% if last_stim_trial > trial_switch(end) %session was ended before rule switch
%     trial_switch = [trial_switch last_stim_trial];
% end

for n= [1 trial_switch]
    first_stim =0; last_stim = 0;
    stimAreasCorrect = zeros(length(stimAreas),1)';
    i=i+1;
    if n == 1
        if isempty(trial_switch)
           trial_switch = 1; 
        end
        start = 1; endd = trial_switch(1);
        stim_trials = find(TrialInf(start:endd,10)==1);
        first_stim = stim_trials(1); last_stim = trial_switch(i);
        
        non_stim_end = first_stim;
    elseif n == trial_switch(length(trial_switch))   %last block
        start = trial_switch(length(trial_switch));
        endd=length(TrialInf);
        
        blocknum = length(trial_switch);
        %check to see there is at least 5 trials after switch
        if endd > start+5
            stim_trials = find(TrialInf(start+1:endd,10)==1);
            
            if isempty(stim_trials)~= 1 %check that there are stim trials in the last block
                first_stim = stim_trials(1)+start; last_stim = endd;
                blocknum = length(trial_switch)+1;%get number of blocks where there were enough trials for barplots
            end
            non_stim_end = endd;
        else
            blocknum = length(trial_switch); %in this case the last block was too short
            break
        end
        
    else
        start = n; endd = trial_switch(i);
        stim_trials = find(TrialInf(start+1:endd,10)==1);
        first_stim = stim_trials(1)+start; last_stim = trial_switch(i);
        
        non_stim_end = first_stim;
    end
    
    %loop through stim trials in this rule block
    nonStimCorr = 0;
    if isempty(stim_trials)~= 1
        for trial = first_stim:last_stim
            
            %divide into Stim trials and non stim trials and check correctness
            if TrialInf(trial,10) == 1 % these are only stimulation trials
                if TrialInf(trial,2)==1 %correct trial
                    for st = 1:length(stimAreas) %will loop though however many different stim areas there are
                        if TrialInf(trial,11) == st
                            %stimAreasCorrect will be a 1xN (N = number of different areas stimulated)
                            %that has the count for the correct trials in each stimulation area
                            %the index indo stimAreasCorrect is the same index to get the name of the area in StimAreas
                            %for ex: if stimAreas = [PPC S1], and stimAreasCorrect  = [21 12]
                            %this would correspond to 21 correct trials with PPC  stimulation...
                            stimAreasCorrect(st) =  stimAreasCorrect(st)+1;
                        end
                    end
                    
                end
                
                
            else %these are the non-stim trials in the stim block for this rule switch block
                if TrialInf(trial,2)==1
                    nonStimCorr = nonStimCorr + 1;
                end
            end
        end
    end
    %get percentages correct for this rule block --------------------------
    if first_stim ~= last_stim
        perNonStim_stimblock(i) = nonStimCorr/length(find(TrialInf(first_stim:last_stim,10)==0));
        
        clear j;
        for j = 1:length(stimAreas)
            stimAreasCorrect(j) = stimAreasCorrect(j)/length(find(TrialInf(first_stim:last_stim,11)==j));
        end
        
        perStim = [perStim;stimAreasCorrect]; %percent correct on each stimulation area in each rule block
    end
    
    %-----------------------------------------------------------------------------------------------------------
    %get percent correct in non stim block
    perNonStim(i) = length(find(TrialInf(start:non_stim_end,2)==1))/(non_stim_end-start);
    
    
    
    %Get percentages for left right for each stim condition
    
    
    clear n
    if isempty(stim_trials)~= 1
        if first_stim ~= last_stim
            
            right = find(TrialInf(first_stim:last_stim,4)==-1);
            left = find(TrialInf(first_stim:last_stim,4)==1);
            correct = find(TrialInf(first_stim:last_stim,2)==1);
            
            
            for jj = 1:length(stimAreas)
                
                stimtri = find(TrialInf(first_stim:last_stim,11)==jj);
                stimtriR = intersect(stimtri,right);
                stimtriL = intersect(stimtri,left);
                
                right_per = length(intersect(stimtriR,correct))/length(stimtriR);
                left_per = length(intersect(stimtriL,correct))/length(stimtriL);
                
                %check to see what conditioin it is
                if jj == 1 %PPC trials
                    rPPC = [rPPC; right_per];lPPC = [lPPC;left_per];
                elseif jj == 2
                    rS1 = [rS1; right_per]; lS1 =[lS1;left_per];
                end
            end
            
            rNS = [rNS; length(intersect(right,correct))/length(right)];
            lNS = [lNS;length(intersect(left,correct))/length(left)];
            
        end
    end
    
    
    
end
rPPC = mean(rPPC); lPPC = mean(lPPC);
rS1 = mean(rS1); lS1 = mean(lS1);
rNS = mean(rNS); lNS = mean(lNS);
%these matrixes have average percent correct for each tim condition for
%left and right trials
R_Lppc = [lPPC rPPC]; R_Ls1 = [lS1 rS1];R_Lns = [lNS rNS];


BlocksStim = []; blStim = [];
for n=1:blocknum
    % [stimloc1 stimloc2 ..... stimlocN ]
    blStim = [perNonStim_stimblock(n) perStim(n,:)];
    BlocksStim = [BlocksStim ; blStim];
end
stimAvg = mean(BlocksStim);


PhotoStimFig = figure;
%subplot(2,1,2)
B = bar(BlocksStim);
hold on;
legend([B(1) B(2)],'Non Stim', 'ACC');
legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
%l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
xlabel('Block'); ylabel('Fraction Correct')
hold off


Avg_fig = figure;
B = bar(stimAvg);
hold on;% l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
B.FaceColor = 'R';B.FaceColor ='R';
xticklabels({'Non Stim', 'ACC'})
ylabel('Fraction Correct');hold off

RL_fig = figure;
B = bar([R_Lns; R_Lppc; R_Ls1]);
hold on;
legend([B(1) B(2)],'left', 'right');
legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
%l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
xticklabels({'Non Stim', 'ACC'})
hold off

end