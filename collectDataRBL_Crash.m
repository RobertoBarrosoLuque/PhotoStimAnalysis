function [sessionData] = collectDataRBL_Crash(num_trials, directory)

sessionData = [];
%\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\1\24-Aug-2017\session_1

for i = 1:num_trials
    if i<=9
        current = 'Trial#00';
    elseif i>9 && i<100
        current = 'Trial#0';
    else
        current = 'Trial#';
    end
    filename = strcat(directory,'\',current,int2str(i));
    load(filename)
    trial = i*ones(1,size(behavData,2));
    behavData = [behavData; trial];
    
    sessionData = cat(2,sessionData,behavData);
    
    
end

save(strcat(directory,'\sessionData'),'sessionData')

end