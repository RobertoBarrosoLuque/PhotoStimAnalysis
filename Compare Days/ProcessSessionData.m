% function loads session data and sync files for stim experiments and saves
%preprocessed TrialInf matrix for faster retrieval in future analyis  

%stimCond = Alltrial,Movement,Feedback

function ProcessSessionData(ID,days,stimCond)
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions\');
addpath('C:\Users\Roberto\Desktop\sync-master\')

file = strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\',int2str(ID));
%set save file directory 
savefile = strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\StimAnalaysis\PPC');

for n = 1:size(days,1)    
    days{n}
    [ dirL ] = dir(strcat(file,days{n},'\'));
    load(strcat(file,days{n},'\',dirL(end).name))
    
    filename = strcat(file,days{n},'\session_1\sessionData');
    load(filename)
      
    [TrialInf] = TrialInformation(sessionData);
    stimInfo = sync.stimRecord;
    [stimInf,TrialInf,stimAreas] = StimInfo(sessionData, stimInfo, TrialInf);
    
    dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);
    
    %save trial inf, sessionData and Switches in PreProcessed structure
    PreProcessed.TrialInf = TrialInf;
    PreProcessed.sessionData = sessionData;
    PreProcessed.trial_switch = trial_switch; 

    mkdir(strcat(savefile,'\',stimCond,'\',int2str(ID),days{n}));
    save(strcat(savefile,'\',stimCond,'\',int2str(ID),days{n},'\PreProcessed'),'PreProcessed')
end 


end 


