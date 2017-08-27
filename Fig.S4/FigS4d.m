%%
% Fig S4d
% Power analysis
% most vigorous 400 sec starting within first 5 min of song
% calculate % of times get frequency between 50-60 seconds
% (0.0167 - 0.02 Hz)

clear all
load('CantonS_KHIPIs_LLR=0.mat')

good_samples = [4 11 14 15 16 24];
n=0;
power_cell = cell(numel(good_samples),1);
sample_size_cell = power_cell;
for sample = good_samples
    d = IPI_results(sample).IPI.d;
    t = IPI_results(sample).IPI.t;
    
    %take most vigorous 400 sec starting in first 5 min
    t_start = zeros(5,1);
    t_end = t_start;
    numIPIs = t_start;
    for j = 0:1:5 %test first five minutes
        k = j+1;
        t_start(k) = j*(1e4*60);
        t_end(k) = t_start(k) + 400*1e4; %sample 400 second sections
        numIPIs(k) = numel(d(t>t_start(k) & t<t_end(k)));
    end
    
    d = d(t>t_start(numIPIs == max(numIPIs)) & t<t_end(numIPIs == max(numIPIs)));%take first 5 min
    t = t(t>t_start(numIPIs == max(numIPIs)) & t<t_end(numIPIs == max(numIPIs)));
    
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
    prop_data = 0.1:.05:1;%need more of data, cause dataset so low
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
            if numel(t_thresholded)>10%lomb crashes if array too small
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
for i= 1:6
    plot(sample_size_cell{i},power_cell{i},'LineWidth',2)
end
ylim([0 1.05])
xlabel('Number of IPIs','FontSize',26)
ylabel('Power P < 0.05','FontSize',26)
set(gca,'FontSize',24)
set(gca,'box','off')