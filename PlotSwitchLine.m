function PlotSwitchLine(stimLine,conLine,stimCavg,conCavg)

subplot(2,3,[3 6]);hold on; ylim([0 100])
xlim([0;length(stimLine)])
for i = 1:size(stimLine,1)
    plot(stimLine(i,:),':b');
end 
plot(polyval(stimCavg,[1:length(stimLine)]),'b');
text(5,90,strcat('y = ',num2str(stimCavg(1),3),'x+',num2str(stimCavg(2),3)),'Color','Blue')


% subplot(2,3,6);hold on;ylim([-10 100])
xlim([0;length(stimLine)])
for i = 1:size(stimLine,1)
    plot(conLine(i,:),':k');
end 
plot(polyval(conCavg,[1:length(stimLine)]),'-k');
text(5,85,strcat('y = ',num2str(conCavg(1),3),'x+',num2str(conCavg(2),3)))
hold off

end 