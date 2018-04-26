function [PhotoStimFig,Avg_fig,stimAvg]=PhotoStimBlockPlotInterleved(TrialInf,trial_switch,stimAreas)
%[PhotoStimFig,Avg_fig,stimAvg]
i = 0;
perNonStim_stimblock = []; perStim = []; perNonStim = [];
rStim1 = [];lStim1 = []; rStim2 = []; lStim2 =[];  rNS = []; lNS = []; 
rCon = []; lCon = [];
%these matrixes hold percent correct per each area stim
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
            else 
                break
            end
            non_stim_end = endd;
        else
            blocknum = length(trial_switch); %in this case the last block was too short
            break
        end
        
    else
        start = n; k = find(trial_switch==start)+1;
        endd = trial_switch(k);
        stim_trials = find(TrialInf(start+1:endd,10)==1);
        if isempty(stim_trials)==1
            i = i-1;
            continue
        end
        first_stim = stim_trials(1)+start; last_stim = trial_switch(k);
        
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
                            %for ex: if stimAreas = [Stim1 Stim2], and stimAreasCorrect  = [21 12]
                            %this would correspond to 21 correct trials with Stim1  stimulation...
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
                if jj == 1 %Stim1 trials
                    rStim1 = [rStim1; right_per];lStim1 = [lStim1;left_per];
                elseif jj == 2
                    rStim2 = [rStim2; right_per]; lStim2 =[lStim2;left_per];
                elseif jj == 3
                    rCon = [rCon; right_per ];
                    lCon = [lCon; left_per];
                end
            end       
        end
    else
        rNS = [rNS; length(intersect(right,correct))/length(right)];
        lNS = [lNS;length(intersect(left,correct))/length(left)];
    end
    
    
    
end
rStim1 = mean(rStim1); lStim1 = mean(lStim1);
rStim2 = mean(rStim2); lStim2 = mean(lStim2);
rNS = mean(rCon); lNS = mean(lCon);
%these matrixes have average percent correct for each tim condition for
%left and right trials
R_LStim1 = [lStim1 rStim1]; R_LStim2 = [lStim2 rStim2];R_Lns = [lNS rNS];


BlocksStim = []; blStim = [];
for n=1:size(perStim,1)%blocknum
    % [stimloc1 stimloc2 ..... stimlocN ] 
    blStim = [blStim; perNonStim_stimblock(n) perStim(n,:)];
    BlocksStim = [BlocksStim ; perStim(n,:)];
end

%if Stim2 was not used leave NaN values for Stim2
if size(perStim,2)<3
    blStim(:,1) = NaN;
end


stimAvg = blStim;
PhotoStimFig = figure;
if size(BlocksStim,1)>1
    stimAvg = nanmean(BlocksStim);
    
    subplot(2,1,1)
    B = bar(BlocksStim);
    hold on;
    legend([B(1) B(2) B(3)], stimAreas);
    legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
    %l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
    xlabel('PhotoStim Block'); ylabel('Fraction Correct')
    hold off
    
    subplot(2,1,2)
    B = bar([R_LStim1; R_LStim2; R_Lns;]);
    hold on;
    legend([B(1) B(2)],'left', 'right');
    legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
    %l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
    xticklabels(stimAreas)
    hold off
else 
    stimAvg = BlocksStim; 
    
    B = bar([R_LStim1; R_LStim2; R_Lns;]);
    hold on;
    legend([B(1) B(2)],'left', 'right');
    legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
    %l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
    xticklabels(stimAreas)
    hold off
end

Avg_fig = figure;
B = bar([stimAvg(1) stimAvg(2) stimAvg(3)]);
hold on;% l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
B.FaceColor = 'K';B.FaceColor ='W';
xticklabels(stimAreas)
ylabel('Fraction Correct');hold off


end