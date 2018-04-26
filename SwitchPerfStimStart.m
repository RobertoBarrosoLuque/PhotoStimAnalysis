function [IMG,perc_matrix]=SwitchPerfStimStart(TrialInf,sessionData,before,after,plot)
%function gets performance arround stimulation blocks start points 


dif = diff(TrialInf(:,10));stim_start = find(dif~=0)+1; 

[total_conv] = Convolve(TrialInf(:,2),5,10);
perc_matrix = zeros(length(stim_start),before+after+1);

IMG = figure;
for n =1:length(stim_start)
    
    perc_matrix(n,:) = total_conv(stim_start(n)-before:stim_start(n)+after);
  
    if plot == 1
      l = plot(perc_matrix(n,:)','k');  
    end 

end 

end 