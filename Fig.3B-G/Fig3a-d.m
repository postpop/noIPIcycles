%%
%
% Data in these panels are from sample 14, which had > 1000 IPIs after
% thresholding at 25 msec
%
%%

%%
% Fig S4e
%%

clear all
load('thresholded_data.mat')
%sample 14 produced song with > 1000 IPIs after 25 ms threshold.
%plot original data
t = original_data(:,1);
d = original_data(:,2);
scatter(t./1e4/60,d./10,'.k')
xlim([0 45])
ylim([10 70])
xlabel('Time (min)','FontSize',36)
ylabel('IPI (msec)','FontSize',36)
set(gca,'FontSize',36)
set(gca,'box','off')
yy = smooth(t/60/1e4,d,51,'rloess');
hold on
plot(t/60/1e4,yy/10,'Color', [0.617 0.14 0.56],'LineWidth',3);
hold off

% Fig3b
% plot LS results
P = original_LS(:,1);
f = original_LS(:,2);
[a,z] = significance(d,t);
figure(3)
plot(1./f,P,'k')
xlim([20 150])
ylim([0 220])
styles = {':','-.','--'};
%a = [0.001 0.01 0.05];
for i = 1:numel(styles)
    line([20,130],[z(i),z(i)],'Color','k','LineStyle',styles{i});
    text(131,z(i),strcat('\alpha = ',num2str(a(i))),'fontsize',36); 
end
xlabel('Period (sec)','FontSize',36)
ylabel('Normalized Power','FontSize',36)
set(gca,'FontSize',36)
set(gca,'box','off')

% Fig3c
% plot data thresholded at 25 msec
clf
t = threshold_data(:,1);
d = threshold_data(:,2);
scatter(t./1e4/60,d./10,'.k')
xlim([0 45])
ylim([10 70])
xlabel('Time (min)','FontSize',36)
ylabel('IPI (msec)','FontSize',36)
set(gca,'FontSize',36)
set(gca,'box','off')
yy = smooth(t/60/1e4,d,51,'rloess');
hold on
plot(t/60/1e4,yy/10,'Color', [0.617 0.14 0.56],'LineWidth',3);
hold off

% Fig3d
% plot LS results for thresholded data
P = threshold_LS(:,1);
f = threshold_LS(:,2);
[a,z] = significance(d,t);
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
ylabel('Normalized Power','FontSize',36)
set(gca,'FontSize',36)
set(gca,'box','off')