 function[fig]=DiffSign(diffs,Cavgs,Savgs)
clear i; 

fig =  figure('rend','painters','pos',[10 10 900 600]); 
subplot(2,1,1);ylim([-.8 .8])
for i = 1:size(diffs,1)
    plot(diffs(i,:),'--ok');xticklabels({'1-10','','11-20','','21-30','','31-40','','41-50'})
    xlabel('Trial Windows');ylabel('Control - Stim (performance)');hold on;
end 
plot(mean(diffs),'-or'); plot(0:size(diffs,1)+2,zeros(size(diffs,1)+3,1)',':k');
xlim([.5 5.5]);
hold off;

control = mean(Cavgs);
errorsC = nanstd(Cavgs)/sqrt(length(Cavgs));

stims = mean(Savgs);
errorsS = nanstd(Savgs)/sqrt(length(Savgs));

subplot(2,1,2)
barr = [];% [control ACC]
P = [];SE = zeros(10,1);y = zeros(10,1);
%account for multiple ttests with bonferroni correction
a = .05/length(control);
i=0;
for n = 1:length(control) %rows = days, columns = trial windows
    barr = [barr;control(n) stims(n)];
    
    if n+i < length(control)*2
        i = i+1;
        
        %get standard error and y value for each error bar
        SE(n+i-1)= errorsC(i);SE(n+i)=errorsS(i);
        y(n+i-1) = control(i);y(n+i)=stims(i);
    end
    
    [h,p] = ttest2(Cavgs(:,n),Savgs(:,n),'Alpha',a);
    
    P = [P;p];
end

%find center of each bar

B =  bar(barr,'w');
hold on
X=[];    
X=cell2mat(get(B,'XData')).' + [B.XOffset];X = reshape(X',[10,1]);

hold on; errorbar(X,y,SE,'k.')
xticklabels({'1-10','11-20','21-30','31-40','41-50'})
xlabel('Trial Windows');ylabel('Performance');
B(1).EdgeColor = 'k';B(2).EdgeColor = 'b';
varargout=sigstar({[.8 1.2],[1.8 2.2],[2.8 3.2],[3.8 4.2],[4.8 5.2]},P);
legend('Control','ACC','Location','northwest');
legend('boxoff'); 

end 
