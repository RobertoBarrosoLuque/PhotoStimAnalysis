function[IMG,AvgStim, AvgNoStim]=SwitchPerfPhotoStim(before,after, TrialInf,trial_switch,pl)
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\');
%set before as how many trials before a switch, set after as number of
%trials after a switch. Function will get performance in this block. Ex 20
%trials before switch to 40 trials after switch.
%Convolve(original,sigma,sz)
%set pl = 1 if you want plots
[conv_performance] = Convolve(TrialInf(:,2),5,7);
% [strat] = RandNotRand(TrialInf,5);

start = before; endd = after; block_switch = trial_switch;

%holds the average performance based on the window specified (interval) and
%the start and end points based on before and after
avg_percentStim = [];
avg_percentNoStim = [];

count = 0;
if length(block_switch)==0
    avg_percent=1; conv_RewardperTrial=1; raw_average=1; conv_average=1;
    return
end


i=0;
if pl == 1
    IMG = figure;
    ylabel('Convoluted Average Performance');xlabel('Trial From Switch Point')
    hold on
else 
    IMG = NaN;
end

for h=block_switch
    i = i+1;
    s = h - start; e = h + endd;
    %check if there is enough trials on last block
    if e>TrialInf(end,1)
        break
        %         temp = zeros(1,e);
        %         temp(s:length(conv_performance)) = conv_performance(s:length(conv_performance));
        %         temp(length(conv_performance)+1:e) = NaN;
        %
        %         conv_performance = temp;
    end
    
    %check to see if this was a stim or non stim block
    if TrialInf(h+1,10)==1 && TrialInf(h+10,10)==1 %photo stim block
        Stim =conv_performance(s:e);
        avg_percentStim = [avg_percentStim;Stim'];
        
        if pl == 1
            m = plot([-before:after],Stim', 'Color','b');
            set(m,'LineStyle', ':')
        end
        
    else
        NoStim = conv_performance(s:e);
        
        if e>TrialInf(end,1)
            NoStim = NoStim';
        end
        
        avg_percentNoStim = [avg_percentNoStim ; NoStim'];
        
        if pl == 1
            l = plot([-before:after],NoStim', 'Color','k');
            set(l,'LineStyle', ':')
        end
    end
    
end

AvgStim = nanmean(avg_percentStim,1);

AvgNoStim = nanmean(avg_percentNoStim,1);

%plot average convoluted perfomance arround switches
if pl == 1
    s = plot([-before:after],AvgStim,'b');
    p = plot([-before:after],AvgNoStim,'k');
    
    hold off
    legend([s p], 'Stim', 'No Stim','Location','southwest','Orientation','horizontal');
end

end