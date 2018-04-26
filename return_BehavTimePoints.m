function[trialInds, trialTimes, Rews_delay_times, ITI_times, mov_trialTimes, RewardperTrial, numtrials, checkerOnset] = return_BehavTimePoints(sessionData)

% get trial indices
trialStart = find(diff(sessionData(end,:)));
trialStart = trialStart + 1;
trialInds = 1:numel(trialStart)+1;
trialInds(1) = 1;
trialInds(2:end) = trialStart;

numtrials = numel(trialInds);

% get indices of sessionData for movement part of trial, not rewardDelay or ITI, to plot movement trajectories
inITIs = sessionData(8,:);
inITIs(find(inITIs == -2)) = nan;
% inITIs: 0 during movement, -1 during reward delay, +1 during ITI delay,
% but also one zero point during transition from -1 to +1 (at reward time)

% to get movement trial end and start times, use diff == -1 
trialTimes = find(diff(inITIs) == -1);
trialTimes = trialTimes+1;% add an element to preserve vector length (diff reduces size by 1)

% store the CheckerOnsets (only applicable in Rew trials!)
checkerOnset = find(sessionData(8,:) == -2);

% get Rew delay times, ITI times and mov times -------------
% (inITI is -1 during rewardDelay time)
Rews_delay = find(inITIs== -1);
Rews_delay_diffed = diff(Rews_delay);
Rews_delay_diffed(find(Rews_delay_diffed == 2)) = 1;
Rews_delay_inds = find(Rews_delay_diffed > 1);

% (inITI is +1 during delay to next trial)
ITIs = find(inITIs == 1);
ITIs_diffed = diff(ITIs);
ITI_inds = find(ITIs_diffed > 1);

% store trialTimes in matrix with row: trial number, columns: movement trial start and end points
mov_trialTimes = zeros(numtrials, 2);
mov_trialTimes(1,:) = [1, trialTimes(1)-1]; % first trial starts at index = 1

Rews_delay_times = zeros(numtrials,2);
Rews_delay_times(1,:) = [Rews_delay(1), Rews_delay(Rews_delay_inds(1))];
ITI_times = zeros(numtrials-1,2); % no ITI for last trial
ITI_times(1,:) = [ITIs(1); ITIs(ITI_inds(1))];

for i = 2:numtrials
    ind = i+(i-2); % adjust the index to get beginnings and ends of long diff=-1 intervals, but exclude the reward delay and ITI times
    mov_trialTimes(i,:) = [trialTimes(ind), trialTimes(ind+1)-1];
    
    if i < numtrials-1
        Rews_delay_times(i,:) = [Rews_delay(Rews_delay_inds(i-1)+1), Rews_delay(Rews_delay_inds(i))];
        ITI_times(i,:) = [ITIs(ITI_inds(i-1)+1), ITIs(ITI_inds(i))];
    elseif i < numtrials 
         Rews_delay_times(i,:) = [Rews_delay(Rews_delay_inds(i-1)+1), Rews_delay(Rews_delay_inds(i))];
         ITI_times(i,:) = [ITIs(ITI_inds(end)+1), ITIs(end)];
    else
        Rews_delay_times(i,:) = [Rews_delay(Rews_delay_inds(end)+1), Rews_delay(end)]; 
    end
end

% Check if Reward was delivered in a given trial
RewardTimes = find(sessionData(9,:));
RewardperTrial = zeros(size(trialInds));

for i = 1:numel(RewardTimes)
   preTrials = find((trialInds - RewardTimes(i)) < 0);
   preTrial = preTrials(end);
   RewardperTrial(preTrial) = 1;
end

end