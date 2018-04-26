function [TrialInf] = TrialInformation(sessionData)
%Function computes the information of each trial, TrialInf is a matrix
%where column 2 has 1 for rewarded trials 0 for non rewarded.
%Column 3 has time of movement periods per trial
%column 4 has 1 for left trials -1 for right trials
%column 5 has 1 for checker 0 for non checker
%column 6 has what exact condition [1,16]
%column 7 has lick info
%column 8 has condition in terms of vert = 1, horz = 2, angle 1 = 3, angle 2 = 4
%column 9 has choice made, -1 for left 1 for right

[~, ~, ~, ~, indx_moving, ~,~, ~] = return_BehavTimePoints(sessionData);

trial_change = diff(sessionData(end,:));
%photo stim experiments
indx_change = find(trial_change==1)+1;




if size(indx_change,2)~=size(indx_moving,1)
    indx_change = [1 indx_change];
end

condition = sessionData(1,indx_change);

TrialInf = [1:length(indx_change)]';
%jR and jL are indices into the indx change matrix for right/left trials
%got correct. jC/jG are indices for checker vs non checker trials
i = 0; jR=[]; jL = []; jC = []; jG = [];
%rewardedTr has 1 for trials that were rewarded and 0 otherwise
rewardedTr = zeros(length(indx_change),1);
time_per_trial = zeros(length(indx_change),1);
chNONch=zeros(length(indx_change),1);
left_right = zeros(length(indx_change),1);
lickInfo = zeros(length(indx_change),1);
cond = zeros(length(indx_change),1);
choice = zeros(length(indx_change),1);

r_index = sessionData(end,find(sessionData(9,:)==1));
rewardedTr(r_index)=1;


for j = indx_change    % here 1 = left, -1 = right
    i = i+1;
    if sessionData(1,j)==1                          %checker right VERTICAL
        jR=[jR i]; jC = [jC i];
        left_right(i)=-1;
        chNONch(i)=1;
        cond(i)=1;
    elseif sessionData(1,j) ==2                     %checker left HORIZONTAL
        jL=[jL i];jC = [jC i];
        left_right(i)=1;
        chNONch(i)=1;
        cond(i)=2;
    elseif sessionData(1,j) ==3                     %checker left VERTICAL
        jL=[jL i];jC = [jC i];
        left_right(i)=1;
        chNONch(i)=1;
        cond(i)=1;
    elseif sessionData(1,j) ==4                     %checker right HORIZONTAL
        jR=[jR i];jC = [jC i];
        left_right(i)=-1;
        chNONch(i)=1;
        cond(i)=2;
    elseif sessionData(1,j) ==5                     %grating right VERTICAL
        jR=[jR i];jG = [jG i];
        left_right(i)=-1;
        chNONch(i)=0;
        cond(i)=1;
    elseif sessionData(1,j) ==6                     %grating left HORIZONTAL
        jL=[jL i];jG = [jG i];
        left_right(i)=1;
        chNONch(i)=0;
        cond(i)=2;
    elseif sessionData(1,j) ==7                     %grating left VERTICAL
        jL=[jL i];jG = [jG i];
        left_right(i)=1;
        chNONch(i)=0;
        cond(i)=1;
    elseif sessionData(1,j) ==8                     %grating right HORIZONTAL
        jR=[jR i];jG = [jG i];
        left_right(i)=-1;
        chNONch(i)=0;
        cond(i)=2;
    end
    
    
    %
    %     if any(sessionData(1,:)>8) %more than 2 conditions
    %         if sessionData(1,j)==9                          %78 checker right
    %             jR=[jR i]; jC = [jC i];
    %             left_right(i)=-1;
    %             chNONch(i)=1; cond(i)=3;
    %         elseif sessionData(1,j) ==10                     %12 checker left
    %             jL=[jL i];jC = [jC i];
    %             left_right(i)=1;
    %             chNONch(i)=1; cond(i)=4;
    %         elseif sessionData(1,j) ==11                     %78 checker left
    %             jL=[jL i];jC = [jC i];
    %             left_right(i)=1;
    %             chNONch(i)=1; cond(i)=3;
    %         elseif sessionData(1,j) ==12                     %12 checker right
    %             jR=[jR i];jC = [jC i];
    %             left_right(i)=-1;
    %             chNONch(i)=1; cond(i)=4;
    %         elseif sessionData(1,j) ==13                    %78 grating right
    %             jR=[jR i];jG = [jG i];
    %             left_right(i)=-1;
    %             chNONch(i)=0; cond(i)=3;
    %         elseif sessionData(1,j) ==14                    %12 grating left
    %             jL=[jL i];jG = [jG i];
    %             left_right(i)=1;
    %             chNONch(i)=0; cond(i)=4;
    %         elseif sessionData(1,j) ==15                    %78 grating left
    %             jL=[jL i];jG = [jG i];
    %             left_right(i)=1;
    %             chNONch(i)=0; cond(i)=3;
    %         elseif sessionData(1,j) ==16                    %12 grating right
    %             jR=[jR i];jG = [jG i];
    %             left_right(i)=-1;
    %             chNONch(i)=0; cond(i)=4;
    %         end
    %     end
    %
    
    
    if rewardedTr(i)==1
        if left_right(i) == 1 %correct choice was left
            choice(i) = -1; %mouse turned left
        else
            choice(i) = 1; %mouse turned right
        end
    elseif rewardedTr(i)==0%mouse made incorrect choice
        if left_right(i) == 1 %correct choice was left
            choice(i) = 1; %mouse turned right
        else
            choice(i) = -1; %mouse turned left
        end
    end
    
    if j==indx_change(1)
        start = 1; endd = indx_change(2);
    elseif j ~=indx_change(length(indx_change))
        start=indx_change(i);endd = indx_change(i+1);
    end
    
    licks = 0;
    for n = start:endd-1  %there is a lick every time you go from no signal to signal (0->1)
        if sessionData(7,n) == 1 && sessionData(7,n+1) == 0
            licks = licks+1;
        end
    end
    
    %get amount of licks per trial
    lickss = sum(sessionData(7,start:endd));
    lickInfo(i) = licks;
    
end

time_movement = zeros(length(indx_moving),1);
for n = 1:length(indx_moving)
    start = indx_moving(n,1); endd = indx_moving(n,2);
    time_movement(n)= sum(sessionData(10,start:endd));
end


%For photostimulation experiment find trials where stimulation was on
if size(sessionData,1) > 14
    stim = find(sessionData(11,:) == 1);
    stim = sessionData(end, stim);
    stim_trials = unique(stim);
    
    
    TrialInf(:,10) = zeros(length(TrialInf),1);
    TrialInf(stim_trials,10) = 1;
end

TrialInf(:,2) = rewardedTr;
TrialInf(:,3) = time_movement(1:length(TrialInf));
TrialInf(:,4) = left_right;   % what the correct decision is
TrialInf(:,5) = chNONch;
TrialInf(:,6) = condition;
TrialInf(:,7) = lickInfo;
TrialInf(:,8) = cond;
TrialInf(:,9) = choice;  %actual choice



