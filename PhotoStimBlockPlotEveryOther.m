%PPC STABLE PERFORMANCE INTERLEVED BAR PLOTS
function [PhotoStimFig,Avg_fig]=PhotoStimBlockPlotEveryOther(TrialInf,trial_switch,stimAreas)
%[PhotoStimFig,Avg_fig]
%use this function to get block plot for experiments were stim happens in
%every other block
i = 0;
perStim = []; perControl = [];perRightStim = []; perLeftStim = [];perConRight = []; perConLeft = [];
NoStimPer  = [];


for n= [1 trial_switch]
    i = i+1;
    if n == 1
        if isempty(trial_switch)
            trial_switch = 1;
        end
        start = 1; endd = trial_switch(1);
        
        stim_trials = find(TrialInf(start:endd,10)==1);
        
        if isempty(stim_trials)==0 %check to see there are stim trials
            first_stim = stim_trials(1); last_stim = trial_switch(i);
            non_stim_end = first_stim;
        else %no stim trials
            first_stim =NaN;
        end
    elseif n == trial_switch(length(trial_switch))   %last block
        start = trial_switch(length(trial_switch));
        endd=length(TrialInf);
        
        blocknum = length(trial_switch);
        %check to see there is at least 5 trials after switch
        if endd > start+5
            stim_trials = find(TrialInf(start+1:endd,10)==1);
            blocknum = length(trial_switch)+1;%get number of blocks where there were enough trials for barplots
            if isempty(stim_trials)~= 1 %check that there are stim trials in the last block
                first_stim = stim_trials(1)+start; last_stim = endd;
                
            else %there were no stim trials
                first_stim = NaN;
            end
            non_stim_end = endd;
        else
            blocknum = length(trial_switch); %in this case the last block was too short
            break
        end
        
    else   %middle blocks
        start = n; endd = trial_switch(i);
        stim_trials = find(TrialInf(start+1:endd,10)==1);
        
        if isempty(stim_trials)==0
            first_stim = stim_trials(1)+start; last_stim = trial_switch(i);
            non_stim_end = first_stim;
            
        else
            first_stim = NaN;
        end
    end
    
    correct = find(TrialInf(start:endd,2)==1)+start-1;
    right = find(TrialInf(start:endd,4)==-1)+start-1;
    left = find(TrialInf(start:endd,4)==1)+start-1;
    
    if isnan(first_stim)== 0 %there are stim trials
        stim_trials = find(TrialInf(first_stim:last_stim,11)==1)+first_stim-1; %ACC is index = 1 in stimAreas
        perStim = [perStim; length(intersect(stim_trials,correct))/length(stim_trials)];
        
        control_trials = find(TrialInf(first_stim:last_stim,11)==2)+first_stim-1;
        perControl = [ perControl ; length(intersect(control_trials,correct))/length(control_trials)];
        
        stim_Right = intersect(stim_trials,right);
        perRightStim = [perRightStim; length(intersect(stim_Right,correct))/length(stim_Right)];
        
        stim_Left = intersect(stim_trials,left);
        perLeftStim = [perLeftStim; length(intersect(stim_Left,correct))/length(stim_Left)];
        
        control_Right =  intersect(control_trials,right);
        perConRight = [perConRight;length(intersect(control_Right,correct))/length(control_Right)];
        
        control_Left =  intersect(control_trials,left);
        perConLeft = [perConLeft;length(intersect(control_Left,correct))/length(control_Left)];
        
        NoStimPer = [NoStimPer; NaN];
    elseif isnan(first_stim)== 1 %there are no stim Trials
        
        perStim = [perStim; NaN];
        perControl = [perControl; NaN];
        perRightStim = [perRightStim; NaN];
        perLeftStim = [perLeftStim ; NaN];
        perConRight = [perConRight; NaN];
        perConLeft = [perConLeft; NaN];
        
        if endd-100 > start
            
            %look for firt trial 50 trials after switch where past 30
            %trials have >=80% correct
            
            s_block = start +50;
            thirty = sum(TrialInf(s_block-30:s_block,2))/30;
            if thirty<.80 %If mouse has not reached good performance after 50 trials
                while thirty>.80 %loop through trials until you find start
                    s_block=s_block+1;
                    thirty = sum(TrialInf(s_block-29:s_block,2))/30;
                end
            end
            NoStim = sum(TrialInf(s_block:s_block+49,2))/50;
            NoStimPer = [NoStimPer;NoStim];
        else
            NoStimPer = [NoStimPer; NaN];
        end
        
    end
    
end



Normal = []; blStim = [];LeftRight = [];xtickStim = {};xtick = {};sesPerf=[];
i=0;j = 0;
for n=1:length(perStim)
    % [stimloc1 stimloc2 ..... stimlocN]
    
    if isnan(perControl(n)) == 0 && isnan(perStim(n))==0
        i = i+1;
        blStim = [blStim; perStim(n) perControl(n)];
        LeftRight = [LeftRight;perConRight(n) perConLeft(n) perRightStim(n) perLeftStim(n)];
        xtickStim{i} = int2str(n);
        
    elseif isnan(NoStimPer(n))==0
        j = j+1;
        Normal = [Normal ; NoStimPer(n)];
        xtick{j} = int2str(n);
    end
end
stimAvg = blStim;
stimAvg = nanmean(blStim,1); AVG = [stimAvg mean(Normal)];

Avg_fig = figure;
B = bar(AVG);%varargout=sigstar({[1,2], [1,3], [2,3]});
xticklabels(stimAreas);B(1).FaceColor = 'k';
ylabel('Fraction Correct');ylim([0 1])



if size(blStim,1)>1 %more than one photo stim trial
    
    PhotoStimFig = figure;
    subplot(2,size(LeftRight,1),1:size(LeftRight,1))
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.25, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
    B = bar(blStim);xticklabels(xtickStim);ylim([0 1]);
    hold on;
    legend([B(1) B(2)],'PPC','Control');ylim([0 1])
    B(1).FaceColor = 'b'; B(2).FaceColor = 'k';
    xlabel('Blocks num');ylabel('Percentage Correct');
    
    colors = {'k',[.5 .5 .5],'b',[0 0 .5]};
    for i = 1:size(LeftRight,1)
        subplot(2,size(LeftRight,1),i+2)
        hold on
        for n = 1: length(LeftRight)
            C = bar(n,LeftRight(i,n)); C(1).FaceColor = colors{n};
        end
        set(gca,'xtick',[])
    end
    legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
    legend('Right', 'Left','Right', 'Left');lgd.FontSize = 6;
    hold off
    
    
else %there is only one stim block 
    PhotoStimFig = figure;
    subplot(2,size(LeftRight,1),1:size(LeftRight,1))
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.25, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
    B = bar(blStim');xticklabels(xtickStim);ylim([0 1]);
    hold on;
    legend([B(1) B(2)],'PPC','Control');
    B(1).FaceColor = 'b'; B(2).FaceColor = 'k';
    xlabel('Blocks num');ylabel('Percentage Correct');
    PhotoStimFig = figure;
    hold on
    colors = {'k',[.5 .5 .5],'b',[0 0 .5]};
    for n = 1: length(LeftRight)
        C = bar(n,LeftRight(i,n)); C(1).FaceColor = colors{n};
    end
    set(gca,'xtick',[])
    legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
    legend('Right Control', 'Left Control','Right Stim', 'Left Stim');lgd.FontSize = 6;
    hold off
    
    
end

end