%%
% Gif 2j
% effect of reducing amplitude from 2 ms to 0 on power of detecting
% rhythm
clear all
load('CantonS_KHIPIs_LLR=0.mat')

fs = 1e4;
power = nan(numel(IPI_results),numel(0:1:20));
lomb_results = cell(numel(IPI_results),numel(0:1:20));
for sample = 1:numel(IPI_results)
    d = IPI_results(sample).IPI.d;
    if numel(d) >=1000
        t = IPI_results(sample).IPI.t;
        freq = 1/(55*fs);%freq = 1/period
        amplitude = 0:1:20;
        sign = nan(numel(amplitude),1);
        
        for j = 1:numel(amplitude)
            x = amplitude(j) * sin(2*pi*freq*t);
            d_sine = x(:) + d(:); %raw data with sine imposed on top
            [P,f,alpha] = lomb(d_sine,t./1e4);
            peak = min(alpha(f>1/60 & f<1/50));
            if peak < 0.05
                sign(j) = 1;
            else
                sign(j) = 0;
            end
            lomb_results{sample,j} = [P,f,alpha];
        end
    end
    power(sample,:) = sign;
end


%plot Power results
figure(1)
hold on
plot(amplitude/10,nanmean(power),'-o','LineWidth',2)
ylim([0 1.05])
xlim([amplitude(1)/10 amplitude(end)/10])
xlabel('Periodicity Amplitude (msec)','FontSize',26)
ylabel('Power P < 0.05','FontSize',26)
set(gca,'FontSize',24)
set(gca,'box','off')
hold off