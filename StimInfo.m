function [stimInf,TrialInf,stimAreas] = StimInfo(sessionData, stimInfo, TrialInf)
%function to get stimulation location for each stim trial and to aline with
%trial info data to get one array
%first column has target name as a string
%second and third column have x,y coordinates from bregma

stimInf = cell(3,size(stimInfo,2))';

for i = 1:size(stimInfo,2)
    targets{i} = (stimInfo(i).info.targetName);
    stimInf{i,1} = stimInfo(i).info.targetName;
    stimInf{i,2} = stimInfo(i).info.gridvals.gridX;
    stimInf{i,3} = stimInfo(i).info.gridvals.gridY;
end

%get number of stimulated areas and assign them each a number 0,1,....,n
%stimNumArea has a number represenation of each area stimulated. The number
%is also the index into StimAreas to the name of the area stimulated

stimAreas = unique(targets); stimNum = length(stimAreas);
stimNumArea = [1:stimNum];

%assign the corresponding number for the target location to each stim trial
clear i;
info = zeros(size(stimInfo,2),1);

if length(stimAreas) > 1 %check if more than one area was stimulated
    for i = 1:size(stimInfo,2)
        
        %loop through number of stim areas for each trial
        for n = 1:length(stimAreas)
            if strcmp(stimAreas(n),stimInf(i,1))
                info(i) = stimNumArea(n);
            end
        end
    end
    
    count = 0;
    TrialInf11 = zeros(length(TrialInf),1);
    for n = 1:length(TrialInf)
        %look for stimulated trials and assign appropriate value of stimulation spot
        if TrialInf(n,10) == 1
            count = count+1;
            
            if count>length(info) %if index exceeds matrix dimensions break
                break
            end 
            
            TrialInf11(n) = info(count);
        end
        
    end
    
else %if there is only one stim area then all stim trials have the same stim ID
    TrialInf11 = zeros(length(TrialInf),1);
    TrialInf11(TrialInf(:,10)==1) = 1;
end


TrialInf(:,11) = TrialInf11;

end