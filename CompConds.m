function [fig] =CompConds(TrialInf, trial_switch)


fig = figure;
subplot(2,1,1); ylabel('Angle 1')
hold on
for n = 1:length(TrialInf)
    if TrialInf(n,6)==10 || TrialInf(n,6)==12 || TrialInf(n,6)==14 || TrialInf(n,6)==16  %12 deg condition
        p = line([n n], [0 1]);
        set(p,'Color','r')
        if TrialInf(n,2)==0 %not rewarded
            set(p,'LineStyle', ':')
        end
%     elseif TrialInf(n,6)==2 || TrialInf(n,6)==4 || TrialInf(n,6)==6 || TrialInf(n,6)==8  %0 deg condtion 
%         p = line([n n], [-1 0]);
%         set(p,'Color','b')
%         if TrialInf(n,2)==0 %not rewarded
%             set(p,'LineStyle', ':')
%         end
    end
end
for i= trial_switch
    p = line([i i], [-1 1]);
    set(p, 'Color', 'k')
end
xlim([0 length(TrialInf)]); ylim([0 1])
hold off




subplot(2,1,2); ylabel('Angle 2')
hold on
for n = 1:length(TrialInf)
    if TrialInf(n,6)==9 || TrialInf(n,6)==11 || TrialInf(n,6)==13 || TrialInf(i,6)==15 %78 deg condition
        p = line([n n], [0 1]);
        set(p,'Color','r')
        if TrialInf(n,2)==0 %not rewarded
            set(p,'LineStyle', ':')
        end
%     elseif TrialInf(n,6)==1 || TrialInf(n,6)==3 || TrialInf(n,6)==5 || TrialInf(n,6)==7  %90 deg condition
%         p = line([n n], [-1 0]);
%         set(p,'Color','b')
%         if TrialInf(n,2)==0 %not rewarded
%             set(p,'LineStyle', ':')
%         end
    end
end
for i= trial_switch
    p = line([i i], [-1 1]);
    set(p, 'Color', 'k')
end
xlim([0 length(TrialInf)]); ylim([0 1]);
hold off

end