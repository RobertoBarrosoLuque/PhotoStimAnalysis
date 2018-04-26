%Script to analyze what strategy mouse is using during training and which
%rule it is following or if it is performing at random 

function [strat] =RandNotRand(TrialInf,wnd)

%column 2 of TrialInf has reward no reward matrix 
%wnd specifies window size 
reward = TrialInf(:,2);

%probability of success is always .5
p = .5;

%initiante array to record probabilities for trials
bin = zeros(length(reward),1);

count = 1;
for i = 1+wnd:length(TrialInf)
    
    %get performance array based on window 
    current = reward(i-wnd:i);
    %sum of current is x in binocdf
    X = sum(current);
    
    %get N for binocdf
    N = length(current);
    
    %get probability of getting X or less successes from N trials
    prob = binocdf(X,N,p);
    bin(i) = prob;
    
    count = count+1;


end

bin(1:1+wnd) = .5; bin(length(bin)-wnd:length(bin)) =.5;

strat = bin; 

end 