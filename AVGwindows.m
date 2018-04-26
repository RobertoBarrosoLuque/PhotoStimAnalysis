%Calculate averages for stim vs no stim performance after switches for
%specific trial windows. Plot difference between averages as a function of
%the trial window 

function [dif,controlAVGs,stimAVGs] = AVGwindows(TrialInf,trial_switch)
%diff has control - stim performances
%controlAVGs and stimAVGs rows are performance in windows 


stimAVGs = [];
controlAVGs = []; 

windows = [1:10;11:20;21:30;31:40;41:50];

%only use fist two switches 
for n = trial_switch
    
    if n > trial_switch(2) %only use first two blocks 
        break 
    else %middle blocks
        start_block = n;
    end
    
    %loop through 10 trial windows 
    for i = 1:size(windows,1)
        start = windows(i,1)+start_block-1;
        endd = windows(i,10)+start_block-1;
        
        %stim blocks
        if TrialInf(start,10) == 1 && TrialInf(endd,10)==1
            perf = sum(TrialInf(start:endd,2))/10;
            stimAVGs = [stimAVGs;perf];
          
        %nostim blocks
        elseif TrialInf(start,10) == 0 && TrialInf(endd,10)==0
            perff = sum(TrialInf(start:endd,2))/10;
            controlAVGs = [controlAVGs;perff];
        end 
        
    end 
    
    
end 


%control - stim ; assuming on average control should have better performance 
dif = controlAVGs'-stimAVGs';


% plot(dif,'--ok');xticklabels({'1-10','','11-20','','21-30','','31-40','','41-50'})
% xlabel('Trial Windows');ylabel('Control - Stim (performance)')


end 