function[timeplot]=TimePlots(TrialInf,stimAreas)
% function to plot times per trial for stim and nonstim trials. Function
% should separate times for stim and non stim trials plot them separatly
% and fit a box and whisker plot ontop

time_stim1 = TrialInf(TrialInf(:,end)==1,3); % stimAreas(1) ACC
time_stim2 = TrialInf(TrialInf(:,end)==2,3); % stimAreas(2) PPC
time_control = TrialInf(TrialInf(:,end)==3,3); % Control

time_nostim = TrialInf(TrialInf(:,10)==0,3);

%get amount of trials with stimulation and non stimulation
%create array with same size for each
y_stim1 = ones(size(time_stim1));
y_stim2 = 2*ones(size(time_stim2));
y_nostim = 3*ones(size(time_nostim));

all_pts = [y_stim1 ;y_stim2;y_nostim];

% Experiments where more than one area is stimulated
if isempty(time_control) == 0 && isempty(time_stim2)==0
    timeplot = figure;
    subplot(2,1,1)
    scatter(find(TrialInf(:,11)==1),time_stim1,'b'); hold on
    scatter(find(TrialInf(:,11)==2),time_stim2,'m');
    scatter(find(TrialInf(:,end)==3),time_control,'k')
    scatter(find(TrialInf(:,11)==0),time_nostim,'k');
    ylabel('Time (s)'); xlabel('Trial')
    legend(stimAreas,'No Stim'); legend('Location','best');legend('boxoff');
    legend('Orientation','horizontal'); hold off
    
    subplot(2,1,2);
    boxplot([time_stim1 ;time_stim2;time_nostim],all_pts,'Orientation','horizontal','Color','k','Widths',.9);hold on;scatter(time_stim1, y_stim1,'b');
    scatter(time_stim2, y_stim2,'m');scatter(time_nostim, y_nostim,'k'); ylim([0 4]); set(gca,'ytick',[])
    xlabel('Time (s)');hold off
elseif  isempty(time_control)
    
    timeplot = figure;
    subplot(2,1,1)
    scatter(find(TrialInf(:,11)==1),time_stim1,'b'); hold on
    scatter(find(TrialInf(:,10)==0),time_nostim,'k')
    ylabel('Time (s)'); xlabel('Trial')
    legend(stimAreas); legend('Location','best');legend('boxoff');
    legend('Orientation','horizontal'); hold off
    
    subplot(2,1,2);
    boxplot([time_stim1 ;time_nostim],all_pts,'Orientation','horizontal','Color','k','Widths',.9);hold on;scatter(time_stim1, y_stim1,'b');
    scatter(time_nostim, (2/3)*y_nostim,'k'); ylim([0 4]); set(gca,'ytick',[])
    xlabel('Time (s)');hold off
    
end



end 