
clear all
load('all_temp.mat')
plot(all)
xlim([0 90])
ylim([20 30])
xlabel('Sample times (30 sec intervals)')
ylabel('Temperature °C')
