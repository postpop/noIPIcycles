%%
% Fig S1
% histogram of P values for manually annotated data
%%

clear all
load('CSmanual.mat')
samples = CSsamples;

peak_best = nan(numel(samples),1);
peak_wide = peak_best;
for sample = 1:numel(samples)
    d = CSipi(:,sample);
    t = CStime(:,sample);
    empties = isnan(d);
    d = d(~empties);
    t = t(~empties);
    [~,f,alpha] = lomb(d,t);
    peak_best(sample) = min(alpha(f>1/60 & f<1/50));
    peak_wide(sample) = min(alpha(f>1/150 & f<1/20));
end
%sensitivity
sens_best = sum(peak_best < 0.05)/numel(peak_best);
%0.04
sens_wide = sum(peak_wide < 0.05)/numel(peak_wide);
%0.16

% plot histogram for figure
hist(peak_wide,30) 
