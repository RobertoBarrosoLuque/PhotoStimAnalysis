function[percent,interval]=PercentCorrectInterval_RBL(int,correct_trials)
%correct_trials is array with 0 for no reward and 1 for reward 
%int is size of window to get average performance across that window
percents = [];
g=0;
for h=1:length(correct_trials)
    if h == length(correct_trials)
        current = sum(correct_trials(length(correct_trials)-1:length(correct_trials)))/int;
        percents(g)= current;
    else
        z = h+int-1;
        g=g+1;
        current = sum(correct_trials(h:z))/int;
        percents(g)= current;
    end
end  

percent = percents;
interval = int;
end 