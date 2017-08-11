clear all
load('CantonS_KHIPIs_LLR=0.mat')
d = IPI_results(14).IPI.d;
t = IPI_results(14).IPI.t;

%Fig.2
%2A - Original Data
yy = smooth(t/60/1e4,d,200,'rloess');
plot(t/60/1e4,d/10,'.k')
ylim([10 70])
xlim([0 10])
hold on
set(gca,'box','off')
ylabel('Inter-Pulse Interval (ms)','FontSize',36)
set(gca,'FontSize',36)
xlabel('Time (min)','FontSize',36)
plot(t/60/1e4,yy/10,'Color', [0.617 0.14 0.56],'LineWidth',6)
titl = title('Original Data','FontSize',36)
P = get(titl,'Position')
set(titl,'Position',[P(1) P(2)-4 P(3)])
hold off

%2B : 10 min sine
clf
time = 1:t(end);
fs = 1e4;
f = 1/(55*fs);%freq = 1/period
A = 20; %amplitude 2msec
x = A *sin(2*pi*f*t);

plot(t/60/1e4,x/10,'LineWidth',6)
xlim([0 10])
ylim([-30 30])
set(gca,'box','off')
set(gca,'FontSize',36)
xlabel('Time (min)','FontSize',36)
ylabel('Inter-Pulse Interval (ms)','FontSize',36)
titl = title('IPI cycle','FontSize',36)
P = get(titl,'Position')
set(titl,'Position',[P(1) P(2)-4 P(3)])


%2C raw data with sine imposed on top
clf
d_sine = x(:) + d(:); 
yy = smooth(t/60/1e4,d_sine,200,'rloess');
plot(t/60/1e4,d_sine/10,'.k')
hold on
plot(t/60/1e4,yy/10,'Color', [0.617 0.14 0.56],'LineWidth',6);
ylim([10 70])
xlim([0 10])
set(gca,'box','off')
set(gca,'FontSize',36)
xlabel('Time (min)','FontSize',36)
ylabel('Inter-Pulse Interval (ms)','FontSize',36)

titl = title('Original Data + IPI Cycle','FontSize',36)
P = get(titl,'Position')
set(titl,'Position',[P(1) P(2)-4 P(3)])

%Fig.2D: original data
clf
yy = smooth(t/60/1e4,d,200,'rloess');
plot(t/60/1e4,d/10,'.k')
ylim([20 65])
xlim([0 45])
hold on
set(gca,'box','off')
ylabel('Inter-Pulse Interval (ms)','FontSize',36)
set(gca,'FontSize',36)
xlabel('Time (min)','FontSize',36)
plot(t/60/1e4,yy/10,'Color', [0.617 0.14 0.56],'LineWidth',3);
title('Original Data','FontSize',36)
hold off

%Fig.2E: LS of original data
clf
[P,f,alpha] = lomb(d,t/1e4);
[a,z] = significance(d,t/1e4);
plot(1./f,P,'k')
hold on
xlim([20 150])
styles = {':','-.','--'};
for i = 1:numel(styles)
    line([20,130],[z(i),z(i)],'Color','k','LineStyle',styles{i});
    text(131,z(i),strcat('\alpha = ',num2str(a(i))),'fontsize',36); 
end
xlabel('Period (sec)','FontSize',36)
ylabel('Normalized Power','FontSize',36)
set(gca,'FontSize',36)
set(gca,'box','off')
hold off

%Fig.2F: Original data + IPI cycle
clf
yy_sine = smooth(t/60/1e4,d_sine,200,'rloess');
plot(t/60/1e4,d_sine/10,'.k')
ylim([20 65])
xlim([0 45])
hold on
set(gca,'box','off')
ylabel('Inter-Pulse Interval (ms)','FontSize',36)
set(gca,'FontSize',36)
xlabel('Time (min)','FontSize',36)
plot(t/60/1e4,yy_sine/10,'Color', [0.617 0.14 0.56],'LineWidth',3);
title('Original Data + IPI Cycle','FontSize',36)
hold off

%Fig.2G: LS of Original data + IPI cycle
clf
[P,f,alpha] = lomb(d_sine,t/1e4);
[a,z] = significance(d_sine,t);
figure(3)
plot(1./f,P,'k')
xlim([20 150])
styles = {':','-.','--'};
%a = [0.001 0.01 0.05];
for i = 1:numel(styles)
    line([20,130],[z(i),z(i)],'Color','k','LineStyle',styles{i});
    text(131,z(i),strcat('\alpha = ',num2str(a(i))),'fontsize',36); 
end
xlabel('Period (sec)','FontSize',36)
ylabel('Power','FontSize',36)
set(gca,'FontSize',36)
set(gca,'box','off')

% Fig.2H: 5% data (675 IPIs) + IPI cycle 
% Note that data are selected randomly each time and plot will 
% therefore look different each time code is run
clf
j = 0.05;
num = numel(d_sine);
rnd_num = rand(num,1);
t_thresholded = t(rnd_num<j);
d_sine_thresholded = d_sine(rnd_num<j);
yy_one = smooth(t_thresholded/60/1e4,d_sine_thresholded,15,'rloess');
plot(t_thresholded/60/1e4,d_sine_thresholded/10,'.k')
ylim([20 65])
xlim([0 45])
hold on
set(gca,'box','off')
ylabel('Inter-Pulse Interval (ms)','FontSize',36)
set(gca,'FontSize',36)
xlabel('Time (min)','FontSize',36)
plot(t_thresholded/60/1e4,yy_one/10,'Color', [0.617 0.14 0.56],'LineWidth',3);
title('5% Original Data + IPI Cycle','FontSize',36)
hold off

% Fig.2I: LS of 5% data (675 IPIs) + IPI cycle 
% Note that data are selected randomly each time and plot will 
% therefore look different each time code is run

clf
[P,f,alpha] = lomb(d_sine_thresholded,t_thresholded/1e4);
[a,z] = significance(d_sine_thresholded,t_thresholded);
figure(3)
plot(1./f,P,'k')
xlim([20 150])
styles = {':','-.','--'};
%a = [0.001 0.01 0.05];
for i = 1:numel(styles)
    line([20,130],[z(i),z(i)],'Color','k','LineStyle',styles{i});
    text(131,z(i),strcat('\alpha = ',num2str(a(i))),'fontsize',36); 
end
xlabel('Period (sec)','FontSize',36)
ylabel('Power','FontSize',36)
set(gca,'FontSize',36)
set(gca,'box','off')
