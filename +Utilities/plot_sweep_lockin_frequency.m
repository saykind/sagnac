minFreq = 20e-2;
maxFreq = 50e3;
idx = (minFreq < logdata.frequency) & (logdata.frequency < maxFreq);

figure; 
plot(logdata.frequency(idx)/1e3, logdata.Q(idx)); 
ylabel('Phase, deg');
xlabel('Frequency, kHz');
yyaxis right; 
plot(logdata.frequency(idx)/1e3, logdata.R(idx)*1e6); 
ylabel('Magnitude, \mu V'); 
grid on;