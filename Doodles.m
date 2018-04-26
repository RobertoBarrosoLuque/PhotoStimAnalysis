
%find trials stimulated
stim_trials = find(TrialInf(start:endd,10)==1);
stim_correct = length(intersect(stim_trials,correct));
per_stim_corr = stim_correct/length(stim_trials);
BlockInf(i).stimCorrect = per_stim_corr;
 
%get firtst photo stimulated trial
if n ~= trial_switch(end)
    start_photostim = stim_trials(1)+n-1;
    end_photostim = trial_switch(i);
    nonstim_trialsStimBlock = find(TrialInf(start_photostim:end_photostim,10)==0)+start_photostim-1;
    per_nonstim_StimBlock = length(intersect(nonstim_trialsStimBlock,all_correct))/length(nonstim_trialsStimBlock);
    BlockInf(i).NonStim_StimBlockCorrect = per_nonstim_StimBlock;
   
    %find trials before stim block
    nonstim_trials = find(TrialInf(start:start_photostim,10)==0);
    nonstim_correct = length(intersect(nonstim_trials,correct));
    per_nonstim_corr = nonstim_correct/length(nonstim_trials);
   
    BlockInf(i).NonstimCorrect = per_nonstim_corr;
   
else
    nonstim_trials = find(TrialInf(start:endd,10)==0);
    nonstim_correct = length(intersect(nonstim_trials,correct));
    per_nonstim_corr = nonstim_correct/length(nonstim_trials);
   
    BlockInf(i).NonstimCorrect = per_nonstim_corr;
   
    BlockInf(i).NonStim_StimBlockCorrect = NaN;
end
 
 
 
 
for n=1:length(trial_switch)+1
   
    xPhotoStim = [BlockInf(n).NonstimCorrect BlockInf(n).NonStim_StimBlockCorrect BlockInf(n).stimCorrect];
    yPhotoStim = [yPhotoStim; xPhotoStim];
   
en
 
 
 
%%
PPC = find(TrialInf(first_stim:last_stim,11)==1);
 
indx = PPC + first_stim -1;
PPCcorr = length(find(TrialInf(indx,2)==1));
 
PPCcorr/length(PPC)
%%
S1 = find(TrialInf(first_stim:last_stim,11)==2);
 
indx = S1 + first_stim -1;
S1corr = length(find(TrialInf(indx,2)==1));
 
S1corr/length(S1)
 
