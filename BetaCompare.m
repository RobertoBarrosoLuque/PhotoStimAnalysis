%Compare beta values from multiple logistic regression between different
%stimulation conditions

animal = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\18';
sessions =  {'\07-Mar-2018';'\08-Mar-2018';'\09-Mar-2018';'\12-Mar-2018';'\14-Mar-2018';'\15-Mar-2018';'\16-Mar-2018'...
    ;'\19-Mar-2018';'\20-Mar-2018';'\23-Mar-2018'};



betaACC = []; betaNoStim = [];
ALLTrialInf = [];ALLTrialInfStim = [];

%use only 70% as training set and 30% as test set 
train = size(sessions,1)-round(size(sessions,1)/4);

test = train:size(sessions,1);

for i = 1:size(sessions,1)%train
    %load sessionData
    sessions{i}
    
    %get beta coefficients
    filename = strcat(animal,sessions{i},'\session_1\sessionData');
    load(filename)
    
    [TrialInf] = TrialInformation(sessionData);
    
    
    first_stim = find(TrialInf(:,10)==1);
    Stim_trials=TrialInf(first_stim(1):first_stim(1)+51,:);
    
    [bACC,dACC,statsACC] = MLogReg(Stim_trials);
    
    dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);
    
    NoStim_Trials = TrialInf(trial_switch(2):trial_switch(2)+50,:);
    [bNS,dNS,statsNS] = MLogReg(NoStim_Trials);
    
    betaACC = [betaACC bACC(2:9)];
    betaNoStim = [betaNoStim bNS(2:9)];
    
    if i==1
        ALLTrialInfStim = [ALLTrialInfStim;Stim_trials];
        ALLTrialInf = [ALLTrialInf;NoStim_Trials];
        
    else
        nn = ones(8,size(TrialInf,2))*NaN;
        Stim_trials = [nn;Stim_trials];
        NoStim_trials = [nn; NoStim_Trials];
        
        ALLTrialInfStim = [ALLTrialInfStim;Stim_trials];
        ALLTrialInf = [ALLTrialInf;NoStim_trials];
    end
    
    
end


%TEST Trials
TestInfStim = [];
TestInf = [];
for i = test 
    %load sessionData
    sessions{i}
    
    %get beta coefficients
    filename = strcat(animal,sessions{i},'\session_1\sessionData');
    load(filename)
    
    [TrialInf] = TrialInformation(sessionData);
    
    
    first_stim = find(TrialInf(:,10)==1);
    Stim_trials=TrialInf(first_stim(1):first_stim(1)+51,:);
    
    %[bACC,dACC,statsACC] = MLogReg(Stim_trials);
    
    dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);
    
    NoStim_Trials = TrialInf(trial_switch(2):trial_switch(2)+50,:);
   % [bNS,dNS,statsNS] = MLogReg(NoStim_Trials);
    
    %betaACC = [betaACC bACC(2:9)];
    %betaNoStim = [betaNoStim bNS(2:9)];
    
    if i==1
        TestInfStim = [ TestInfStim;Stim_trials];
        TestInf = [TestInf;NoStim_Trials];
        
    else
        nn = ones(8,size(TrialInf,2))*NaN;
        Stim_trials = [nn;Stim_trials];
        NoStim_trials = [nn; NoStim_Trials];
        
        TestInfStim = [TestInfStim;Stim_trials];
        TestInf = [TestInf;NoStim_trials];
    end
    
    
end



AVG_B_ACC = nanmean(betaACC');
AVG_B = nanmean(betaNoStim');

[bACC,dACC,statsACC] = MLogReg(ALLTrialInfStim);
[bNS,dNS,statsNS] = MLogReg(ALLTrialInf);

figure;
hold on 
errorbar(bACC(2:9),statsACC.se(2:9),'--bo');xlim([0 9]);
errorbar(bNS(2:9),statsNS.se(2:9),'-ko');xlim([0 9]);
xlabel('Trials from current'); ylabel('Beta Coefficient AVG')
legend('ACC Stim', 'No Stim');title('CA18')


theta = bACC(2:end).*X_rew;
predicted = bACC(1)+theta;
h_rw = sigmoid(predicted)
