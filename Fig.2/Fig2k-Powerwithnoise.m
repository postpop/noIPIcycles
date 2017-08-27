%%
% Figure 2k
% Power analysis with noisy song after randomly dropping IPIs
% repeat and calculate % of times get frequency between 50-60 seconds
% (0.0167 - 0.02 Hz)
%%
clear all
load('CantonS_KHIPIs_LLR=0.mat')
%range_noise = 0.5:0.5:3; %range of signal to noise ratios for putative cycles
%range_noise =  [.05 .1 .25 .5 1 1.5 2]; %range of signal to noise ratios for putative cycles
range_noise =  [.1 .25 .5 1 1.5 2]; %range of signal to noise ratios for putative cycles
prop_data = 500:250:3000;
good_samples = [4 11 14 15 16 24];%samples with > 10,000 IPIs
n=0;
power_cell = cell(numel(good_samples),1);
sample_size_cell = power_cell;
for sample = good_samples
    d = IPI_results(sample).IPI.d;
    t = IPI_results(sample).IPI.t;
    time = 1:t(end);
    fs = 1e4;
    freq = 1/(55*fs);%freq = 1/period
    A = 20; %amplitude 2msec
    
    k=0;
    noise = range_noise;
    power_array = nan(numel(noise),numel(prop_data));
    for SNR  = noise
        KHcycle = A *sin(2*pi*freq*t);
        % Add noise
        % rmsrnd = sqrt(mean(randn(size(x,2),1).^2));
        % rmsx = sqrt(mean(x.^2));
        
        stdx = std(KHcycle);
        
        noisedKHcycle = KHcycle + (stdx/SNR) .* randn(1,size(KHcycle,2));

        d_noised_sine = d(:) + noisedKHcycle(:); %raw data with sine imposed on top
        d_sine = d(:) + KHcycle(:);
        
        reps = 50;
        power = [];
        sample_size = [];
        
        sample = prop_data;
        for j = sample
            sign = zeros(reps,1);
            N = NaN(reps,1);
            for m = 1:reps
                %select prop_data fraction of samples from time series
                rnd_samples = sort(randsample(numel(t),j));%randsample returns in random order, need to sort
                rnd_t_samples = t(rnd_samples);
                rnd_d_samples = d_noised_sine(rnd_samples);
                
                if ~isempty(rnd_t_samples)%lomb crashes if array empty
                    [P,f,alpha] = lomb(rnd_d_samples,rnd_t_samples./1e4);
                    peak = min(alpha(f>1/60 & f<1/50));
                    if peak < 0.05
                        sign(m) = 1;
                    end
                end
            end
            power = cat(1,power,sum(sign)/reps);%store power for each proportion of data
            sample_size = cat(1,sample_size,prop_data);
        end
        %store power from each proportion for each subsample of data in 2D
        %array
        k=k+1
        power_array(k,:) = power;%rows are SNR, columns are sample size
    end
    n=n+1
    %store power and sample size 
    power_cell{n} = power_array;
    sample_size_cell{n} = sample_size;
end

%plot Power results
power_array = cat(3,power_cell{:});
mean_power = mean(power_array,3);
imagesc(mean_power)
set(gca,'YDir','normal')
set(gca,'xtick',1:1:12)
set(gca,'XTickLabel',{'500' '' '1000' '' '1500' '' '2000' '' '2500' '' '3000' })
%set(gca,'XTickLabel',prop_data)
set(gca,'YTickLabel',range_noise)
xlabel('Number of IPIs','FontSize',26)
ylabel('Signal to Noise Ratio','FontSize',26)
set(gca,'FontSize',20)
colorbar
legend off

%% Plot example KH cycles with range of SNR 
figure(2)
noise = range_noise;
sample = 1;
n=0;
t = IPI_results(sample).IPI.t;
time = 1:t(end);
fs = 1e4;
freq = 1/(55*fs);%freq = 1/period
A = 20; %amplitude 2msec
KHcycle = A *sin(2*pi*freq*t);
stdx = std(KHcycle);
for SNR  = fliplr(noise)
    noisedKHcycle = KHcycle + (stdx/SNR) .* randn(1,size(KHcycle,2));
    n=n+1;
    subplot(6,1,n)
    plot(t./1e4,noisedKHcycle,'.-k')
    axis('off')
end
linkaxes
xlim([1 900])
ylim([min(noisedKHcycle(1:900)) max(noisedKHcycle(1:900))])
