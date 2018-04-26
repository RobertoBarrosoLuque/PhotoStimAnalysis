function [fig] = lineplot(TrialInf, trial_switch)
%---------------------Right vs Left Plots-----------------------------------------

%[strat] = RandNotRand(TrialInf,5);
%strat(find(strat>=.5)) = .5; strat(find(strat<.5)) = -.5;

fig = figure;


if any(TrialInf(:,6)>8) %more than 2 condition
    subplot(3,1,1)
end

% plot(strat, 'Color', [.3 .3 .3])
% hold on
xlabel('Trial #'); ylabel('Right vs Left Trials');

if size(TrialInf,2) < 10 %check to see there was no photostim
    for i=1:length(TrialInf)
        if TrialInf(i,4)==1 %left trial
            p = line([i i], [0 1]);
            if TrialInf(i,2)==1 %rewarded
                set(p,'Color','m')
            else %not rewarded
                set(p,'LineStyle', ':')
            end
        else %right trials
            p = line([i i],[-1 0]);
            if TrialInf(i,2)==1 %rewarded
                set(p,'Color','g')
            else %not rewarded
                set(p,'LineStyle', ':')
            end
        end
        
        clear p
    end
    
    if trial_switch ~=0   % there was at least one switch
        for i= trial_switch
            p = line([i i], [-1 1]);
            set(p, 'Color', 'k')
        end
        xlim([0 length(TrialInf)])
        hold off
    end
end





if any(TrialInf(:,6)>8) %more than 2 condition
%     subplot(4,1,2); ylabel('ang2 vs ang1 Trials'); xlabel('trial #')
%     hold on
indx = find(TrialInf(:,6)>8);
%     for n = indx'
%         %check if angle is ang1 or ang2
%         if  TrialInf(n,6)==9 || TrialInf(n,6)==11 || TrialInf(n,6)==13 || TrialInf(i,6)==15 %ang1 trials
%             p = line([n n], [0 1]);
%             set(p,'Color','r')
%             if TrialInf(n,2)==0 %not rewarded
%                 set(p,'LineStyle', ':')
%             end
%         elseif TrialInf(n,6)==10 || TrialInf(n,6)==ang2 || TrialInf(n,6)==14 || TrialInf(n,6)==16 %ang2 trials
%             p = line([n n], [-1 0]);
%             set(p,'Color','b')
%             if TrialInf(n,2)==0 %not rewarded
%                 set(p,'LineStyle', ':')
%             end
%         end
%     end
%     for i= trial_switch
%         p = line([i i], [-1 1]);
%         set(p, 'Color', 'k')
%     end
%     xlim([0 length(TrialInf)])
%     
    subplot(3,1,2); title('Angle 2'); ylabel('Non-ch vs Ch'); xlabel('trial #')         %ang2 trials checker vs non checker
    hold on
    for n = indx'
        if TrialInf(n,6)==10 || TrialInf(n,6)==12 || TrialInf(n,6)==14 || TrialInf(n,6)==16
            if TrialInf(n,5)==1 %checker trials
                p = line([n n], [0 1]);
                set(p,'Color','r')
                if TrialInf(n,2)==0 %not rewarded
                    set(p,'LineStyle', ':')
                end
            else
                p = line([n n], [-1 0]);
                set(p,'Color','b')
                if TrialInf(n,2)==0 %not rewarded
                    set(p,'LineStyle', ':')
                end
            end
            
        end
    end
    for i= trial_switch
        p = line([i i], [-1 1]);
        set(p, 'Color', 'k')
    end
    xlim([0 length(TrialInf)])
    
    
    
    subplot(3,1,3); title('Angle 1'); ylabel('Non-ch vs Ch');xlabel('trial #')         %ang1 trials checker vs non checker
    hold on
    for n = indx'
        if TrialInf(n,6)==9 || TrialInf(n,6)==11 || TrialInf(n,6)==13 || TrialInf(n,6)==15
            if TrialInf(n,5)==1 %checker trials
                p = line([n n], [0 1]);
                set(p,'Color','r')
                if TrialInf(n,2)==0 %not rewarded
                    set(p,'LineStyle', ':')
                end
            else
                p = line([n n], [-1 0]);
                set(p,'Color','b')
                if TrialInf(n,2)==0 %not rewarded
                    set(p,'LineStyle', ':')
                end
            end
            
        end
    end
    for i= trial_switch
        p = line([i i], [-1 1]);
        set(p, 'Color', 'k')
    end
    xlim([0 length(TrialInf)])
    
    
    
end


%Photo Stimulation Experiment check

if size(TrialInf,2) > 9 %will only have a 10th column if there is photosim
    
    for i=1:length(TrialInf)
        if TrialInf(i,4)==1 %left trial
            p = line([i i], [0 1]);
            if TrialInf(i,2)==1 && TrialInf(i,10) == 0 %rewarded no photostim
                set(p,'Color','m')
            elseif TrialInf(i,2)==1 && TrialInf(i,10) == 1 %rewarded phtostim ON
                set(p,'Color','m')
                set(p,'LineStyle', '--')
            elseif TrialInf(i,2)==0 && TrialInf(i,10) == 0 %not rewarded no photostim
                set(p,'LineStyle', ':')
                set(p,'Color', 	[.6 .6 .6])
            else %not rewarded photostim ON
                 set(p,'LineStyle', '--')
                 set(p,'Color', [.6 .6 .6])
            end
        else %right trials
            p = line([i i], [-1 0]);
            if TrialInf(i,2)==1 && TrialInf(i,10) == 0 %rewarded no photostim
                set(p,'Color','g')
            elseif TrialInf(i,2)==1 && TrialInf(i,10) == 1 %rewarded phtostim ON
                set(p,'Color','g')
                set(p,'LineStyle', '- -')
            elseif TrialInf(i,2)==0 && TrialInf(i,10) == 0 %not rewarded no photostim
                set(p,'LineStyle', ':')
                set(p,'Color', 	[.6 .6 .6])
            else %not rewarded photostim ON
                 set(p,'LineStyle', '--')
                 set(p,'Color', [.6 .6 .6])
        end
        
        clear p
    end
    
    if trial_switch ~=0   % there was at least one switch
        for i= trial_switch
            p = line([i i], [-1 1]);
            set(p, 'Color', 'k')
        end
        xlim([0 length(TrialInf)])
        hold off
    end

    
    
end 



end





