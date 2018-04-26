function[IMG,rand,avg_percent,raw_average,conv_average]=SwitchPerf(before,after, sessionData)
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Roberto\Matlab Code\');

%set before as how many trials before a switch, set after as number of
%trials after a switch. Function will get performance in this block. Ex 20
%trials before switch to 40 trials after switch.

dif = diff(sessionData(4,:)); frame_switch = find(dif~=0); block_switch = sessionData(end,frame_switch);

[TrialInf] = TrialInformation(sessionData);
[percent,interval]=PercentCorrectInterval_RBL(2,TrialInf(:,2)');

[strat] = RandNotRand(TrialInf,5);

start = before; endd = after;

%holds the average performance based on the window specified (interval) and
%the start and end points based on before and after
avg_percent = zeros(1,before+after);

%holds the individual performance for each block based on before and after
%points specified
perc_matrix = zeros(length(block_switch),before+after);
conv_percent_matrix = zeros(length(block_switch),before+after); %gaussian filtered performance for each block
conv_average = zeros(1,before+after);

%vectore based on binomial distribution of wethere mouse is performing at
%random
randnorand = zeros(1,before+after);

%holds the raw performance based on [0 0 1 0 1 1] (no reward, reward)
raw_average = zeros(1,before+after);

%convolve entire correct/incorrect vector
total_conv = Convolve(TrialInf(:,2),5,10);

%convolve entire window based correct/incorrect array
wnd_convolve = Convolve(percent,2,5);

count = 0;
if length(block_switch)==0
    avg_percent=1; conv_RewardperTrial=1; raw_average=1; conv_average=1;
    return
end

IMG = figure;
for h=block_switch
    s = h - start; e = h + endd;
    %check to see that the last block has enough trials after last switch
    if e<length(percent)
        count = count+1;
        %hold performance based on window specified in percenCorrecInterval
        avg_percent = avg_percent+wnd_convolve(s:e-1); %this was already passed through convolution function
        perc_matrix(count,:) = wnd_convolve(s:e-1);
        
        [conv_matrix] = total_conv(s:e-1);
        conv_percent_matrix(count,:)=conv_matrix;
        conv_average = conv_average + conv_matrix';
        
        raw_average = raw_average + TrialInf(s:e-1,2)';
        
        
        randnorand = randnorand + strat(s:e-1)';
    end
    
    %if session finished less than 40 trials after last switch then change
    %ending index
    if length(TrialInf)-s < 60
        endd = length(TrialInf)-s;
        wnd_last = zeros(60,1);
        wnd_last(1:endd) = wnd_convolve(s:length(TrialInf)-1);
        wnd_last(endd:60) = NaN;
        
        p = plot([-20:39],wnd_last); set(p,'Color',[.6 .6 .6])
        hold on;
        
    else
        %plot convoluted trace of performance around switch point
        p = plot([-20:39],wnd_convolve(s:e-1)); set(p,'Color',[.6 .6 .6])
        hold on;
    end
end

%holds average of random measure arounf switches (based on binomial distribution)
rand = randnorand/count;

%rand(find(rand>=.5)) = .5; rand(find(rand<.5)) = 0; % set not random behavior as .5, random behavior as 0

%get average (after getting window average) of performance through switches
avg_percent = avg_percent/count;  %already passed through convolution function

%gaussian convolution of average performance
% conv_RewardperTrial = Convolve(avg_percent,2,5);

raw_average = raw_average/count;
%average of gaussian convoluted performances
conv_average = conv_average/count;


%plot average convoluted perfomance arround switches
s = plot([-20:39],avg_percent,'k');set(s, 'LineWidth',2);ylim([0 1]);title('Convoluted Average Performance (window = 2)');
plot([-20:39],rand,'r');ylim([0 1]); hold off
legend([s p], 'Average', 'Individual','Location','northoutside','Orientation','horizontal');


end