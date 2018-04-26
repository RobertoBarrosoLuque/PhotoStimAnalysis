%Fit 1 degree polynomial based on least squares sense for performance
%around switches, get slope of best fit line
%yStim has y values for stim fit line, coeffstim has slope and y int for
%the same line. yCon has y values for control fit line, coeffCon has y int
%and slope for respective line
function[yStim,coeffStim,yCon,coeffCon]=FitPoly2Switch(TrialInf,trial_switch,bef,af)

%performance based on reward no reward
RawP = TrialInf(:,2);

%convolute performance using sigma = 5; gaussFilter =10
[conv_performance] = Convolve(TrialInf(:,2),5,10);
start = bef; endd = af; 

%Copy from SwitchPerPhotoStim function
avg_percentStim = [];
avg_percentNoStim = [];
i = 0;

for h=trial_switch
    i = i+1;
    s = h - start; e = h + endd;
    %check if there is enough trials on last block
    if e>TrialInf(end,1)
        break
    end
    
    %check to see if this was a stim or non stim block
    if TrialInf(h+1,10)==1 && TrialInf(h+10,10)==1 %photo stim block
        Stim =conv_performance(s:e);
        avg_percentStim = [avg_percentStim;Stim'];
    else
        NoStim = conv_performance(s:e);
        if e>TrialInf(end,1)
            NoStim = NoStim';
        end
        
        avg_percentNoStim = [avg_percentNoStim ; NoStim'];
    end
end

%fit line and save it to y variables
coeffStim = polyfit([bef:af+2],avg_percentStim,1);
%scale up to 0-100 (Percentages)
coeffStim = coeffStim*100;
yStim = polyval(coeffStim ,[bef:af+2]);

coeffCon = polyfit([bef:af+2],mean(avg_percentNoStim,1),1);
%scale up to 0-100 (Percentages)
coeffCon = coeffCon*100;
yCon = polyval(coeffCon,[bef:af+2]);

end
