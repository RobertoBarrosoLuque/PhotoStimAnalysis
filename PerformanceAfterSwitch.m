function[IMG,AVGs,AVGsLR]= PerformanceAfterSwitch(TrialInf,trial_switch,trial,stimAreas,pl)
%[IMG,AVGs,AVGsLR]
%function calculates the performance after a switch point between
%to compare performance after stimulated and non stim blocks,input trial is
%the the last trial after a switch to which you want performance to be
%calculated
%set pl = 1 if you want plots

stimPer = [];stimLeft = []; stimRight = [];
NostimPer = [];NostimRight = []; NostimLeft = [];
for n= [trial_switch]
    
    
    if n == trial_switch(length(trial_switch))   %last block
        start = trial_switch(length(trial_switch));
    else   %middle blocks
        start = n;
    end
    
    endd = start + trial;
    if endd>TrialInf(end,1) %not enough trials to compute percent on last block
        break
    else
        
        correct = find(TrialInf(start:endd,2)==1);
        current = sum(TrialInf(start:endd,2));
        right = find(TrialInf(start:endd,4)==-1);
        left = find(TrialInf(start:endd,4)==1);
        
        if TrialInf(start+1,10)==1 %stim block
            
            stimPer = [stimPer; current/(trial+1)];
            stimLeft = [stimLeft; length(intersect(left,correct))/length(left)];
            stimRight = [stimRight; length(intersect(right,correct))/length(right)];
            
        else   %No stim block 
            NostimPer = [NostimPer; current/(trial+1)];
            NostimLeft = [NostimLeft; length(intersect(left,correct))/length(left)];
            NostimRight = [NostimRight; length(intersect(right,correct))/length(right)];
            
        end
        
    end
    
end

AVGstim = mean(stimPer); AVGNostim = mean(NostimPer);

AVGstimR = mean(stimRight); AVGstimL = mean(stimLeft);
AVGNostimR = mean(NostimRight); AVGNostimL = mean(NostimLeft);

AVGs = [AVGstim; AVGNostim];
AVGsLR = [AVGstimR AVGstimL ; AVGNostimR AVGNostimL];
%
if pl == 1
    
    IMG = figure;
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.25, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
    subplot(2,1,1)
    B = bar([AVGstim; AVGNostim]); xticklabels({stimAreas{1};'No stim Block'});
    ylabel('Percentage Correct');
    
    LR = [AVGstimR AVGstimL ; AVGNostimR AVGNostimL];
    subplot(2,1,2)
    C = bar(LR);
    legend('Right', 'Left')
    legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
    legend('Right', 'Left','Right', 'Left');lgd.FontSize = 6;
    ylabel('Percentage Correct');
    xticklabels({stimAreas{1};'No stim Block'});
else 
    IMG = NaN;
end


end