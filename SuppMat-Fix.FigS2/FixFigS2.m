%%
% corrected Figure S2
% This plot from Figure 1 of Stern 2014 was derived from a section of song
% from sample PS_20130625111709_ch3, sample points approximately 
% 1162.3e4:1163.3e4. Corresponds to I re-examined the raw data and the IPI
% data derived from these raw data (both released publicly at the time the
% original paper was published). All the IPIs are present correctly, but 
% one data point was apparently dropped during construction of the figure.
%
% The code below plots the correct figure
%%
clear all
clf

load('PS_20130625111709_ch3_rdcd.mat')

time = IPI.IPI.t;
data = IPI.IPI.d;

figure
ax1 = subplot(2,1,1);
ax2 = subplot(2,1,2);
scatter(ax2,time/1e4,data/10,'k','filled')

xlim(ax2,[1162.3 1163.3])
plot(ax1,song,'Color',[.742 .742 .742])
xlim(ax1,[1 1e4])

%plot sines
hold(ax1,'on')
hold(ax2,'on')
plot(ax1,(Sinesstart-1162.3e4:Sinesstop-1162.3e4),sineclip,'b');

%plot pulses
for i = 1:numel(pulsesw0);
        a = pulsesw0(i);
        b = pulsesw1(i);
        t = (a-1162.3e4:b-1162.3e4);
        y = song(a-1162.3e4:b-1162.3e4);
        plot(ax1,t,y,'r'); %hold on;
end