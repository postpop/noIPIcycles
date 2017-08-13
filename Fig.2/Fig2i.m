%%
% Fig 2i
% Power analysis after randomly dropingp 10sec bins
%%

clear all
load('CantonS_KHIPIs_LLR=0.mat')

%Power analysis
%repeat and calculate % of times get frequency between 50-60 seconds
%(0.0167 - 0.02 Hz)
good_samples = [4 14 15 16 24];
n=0;
power_cell = cell(numel(good_samples),1);
sample_size_cell = power_cell;
for sample = good_samples
    d = IPI_results(sample).IPI.d;
    t = IPI_results(sample).IPI.t;
    time = 1:t(end);
    fs = 1e4;
    f = 1/(55*fs);%freq = 1/period
    A = 20; %amplitude 2msec
    x = A *sin(2*pi*f*t);
    d_sine = x(:) + d(:); %raw data with sine imposed on top

    num_bins = floor(t(end)/1e5); %num of 10sec bins
    reps = 100;
    power = [];
    sample_size = [];
    prop_data = 0.03:.01:.20;
    for j = prop_data
        sign = zeros(reps,1);
        N = NaN(reps,1);
        for m = 1:reps
            rnd_bins = rand(num_bins,1);
            threshold = j;
            t_thresholded = [];
            d_sine_thresholded = [];
            for i = 1:numel(rnd_bins)
                if rnd_bins(i) < threshold
                    start = i*1e5 - 1e5;
                    t_bin = t(t>=start & t< i*1e5);
                    t_thresholded = cat(2,t_thresholded,t_bin);
                    d_sine_bin = d_sine(t>=start & t< i*1e5);
                    d_sine_thresholded = cat(2,d_sine_thresholded,d_sine_bin');
                end
            end
            if ~isempty(t_thresholded)%lomb crashes if array empty
                [P,f,alpha] = lomb(d_sine_thresholded,t_thresholded./1e4);
                peak = min(alpha(f>1/60 & f<1/50));
                if peak < 0.05
                    sign(m) = 1;
                end
                N(m) = numel(t_thresholded);
            end
        end
        power = cat(1,power,sum(sign)/reps);
        sample_size = cat(1,sample_size,nanmean(N));
    end
    n=n+1;
    power_cell{n} = power;
    sample_size_cell{n} = sample_size;
end

%plot Power results
figure(2)
hold on
for i= 1:5
    plot(sample_size_cell{i},power_cell{i},'LineWidth',2)
end
ylim([0 1.05])
xlabel('Number of IPIs','FontSize',26)
ylabel('Power P < 0.05','FontSize',26)
set(gca,'FontSize',24)
set(gca,'box','off')


