function FitLog_Line_Growth(ydata,stim)

if stim ==1 
    color = 'b';
else 
    color = 'k';
end 

X = [1:length(ydata)];

%get logarithmic growth curve, Outputs: Qpre (logistic model fit to data)
%see [ Qpre, p, sm, varcov] = fit_logistic(t,Q) for more details.
[ Qpre, p, sm, varcov] = fit_logistic(X,ydata);

%calculate coefficient of determination for log fit
[r2Log,r2adjLog]=rsquared(ydata, Qpre);

% [fitobject,gof] = fit(log(ydata)',ydata','poly2');
% P = [fitobject.p1 fitobject.p2 fitobject.p3];
% y = polyval(P,X)/100;



%get one degree polynomial fit to ydata
mdl = fitlm(X,ydata,'linear');
P = num2str(round(mdl.Coefficients.pValue(2),3));

%calculate coefficient of determination for linear fit 
r2Line=mdl.Rsquared.Adjusted;

%plot original plus fits
%F = figure;


h1 = plot(ydata,color);hold on
h2 = plot(X,ones(length(X),1)*.5,'Color',[0.5 0.5 0.5]);
h3 = plot(mdl,'Color',color); h3(1).Marker = '.'; legend('off')
ylim([.2 1]);xlim([0 length(ydata)-1])


if (0<=r2Log) && (1>=r2Log)
h4 = plot(Qpre,strcat('m','-.'));
legend([h1 h3(2) h4],'Original',strcat('R2 = ',num2str(r2Line), ', P = ',P),strcat('R2 = ',num2str(r2Log)),'Location','southeast')
legend('boxoff')
else 
    legend([h1 h3(2)],'Original',strcat('R2 = ',num2str(r2Line), ', P = ',P),'Location','northwest')
end 
ylabel('Percent Correct'); xlabel('Trial From Switch')
title(' ')

if length(ydata) > 52
plot(50*ones(11,1),[0:.1:1],'k','HandleVisibility','off'); 
end 

end  