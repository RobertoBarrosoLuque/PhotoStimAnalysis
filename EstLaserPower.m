%Estimate laser poser in MW
function EstLaserPower(sync)
 
% access the photodiode measurements for different laser command signals
volts = sync.laserCalibration.laserVolt;
pd = sync.laserCalibration.photodiodeVolt;
 
rge = range(pd);
low = min(pd) + 0.05*rge;
high = max(pd) - 0.05*rge;
iStart = find(pd>low, 1, 'first');
iEnd = find(pd<high, 1, 'last');
 
x_vals = volts(iStart:iEnd);
yvals = pd/max(pd)*sync.laserCalibration.maxLaserMw;
y_vals = yvals(iStart:iEnd);
figure()
plot(x_vals, y_vals);
 
% get max laser command signal in Volts
LaserCommand = sync.stimRecord(1).info.stimCommand(:,1);
max_Volt = max(LaserCommand);
 
peakLaserPower = invpred(y_vals, x_vals, max_Volt) ;
meanLaserPower = peakLaserPower / 4;
end
