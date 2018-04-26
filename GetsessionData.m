%Get sessionData
clear all;close all;

numtrials = 196;

directory = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\17\13-Apr-2018\session_1\';

sessionData = [];

for i = 1:numtrials
   if i<10
       current = 'Trial#00';
   elseif i>=10 && i<100
       current = 'Trial#0';
   else 
       current = 'Trial#';
   end
   file = strcat(directory,current,int2str(i));
   load(file)
   
   trial = size(behavData,1)+1;
   behavData(trial,:)=i;
   sessionData = [sessionData behavData];
   i
end 

save(strcat(directory,'sessionData'),'sessionData')