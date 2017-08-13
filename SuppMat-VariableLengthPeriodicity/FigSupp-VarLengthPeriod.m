%%
% Fig S3a
% Power analysis with variable fraction of song containing periodicity
%

%Power analysis
%repeat and calculate % of times get frequency between 50-60 seconds
%(0.0167 - 0.02 Hz)
clear all
load('CantonS_KHIPIs_LLR=0.mat')
%test for 45 minute songs
periodicity_range = 1:45;%range of song containing periodicity in minutes
%test for 10 minute songs
%periodicity_range = 1:10;%range of song containing periodicity in minutes
n=0;
m=0;
power = nan(numel(IPI_results),numel(periodicity_range));
for sample = 1:numel(IPI_results)
    d = IPI_results(sample).IPI.d;
    t = IPI_results(sample).IPI.t;
    %alternative: select ten minute song
    %d = d(t<10*60*1e4);
    %t = t(t<10*60*1e4);
    if numel(d) > 1000
        n=n+1;
        %add periodicity for part of song
        for time_range = periodicity_range
            m=m+1;
            fs = 1e4;
            f = 1/(55*fs);%freq = 1/period
            A = 20; %amplitude 2msec
            cyclic_range = t<time_range*60*fs;
            x_cyclic = A *sin(2*pi*f*t(cyclic_range));
            x_noncyclic = zeros(numel(t(~cyclic_range)),1)';
            x = cat(2,x_cyclic,x_noncyclic);
            d_sine = x(:) + d(:); %raw data with sine imposed on top
            
            [P,f,alpha] = lomb(d_sine,t./1e4);
            peak = min(alpha(f>1/60 & f<1/50));
            if peak < 0.05
                sign = 1;
            else
                sign = 0;
            end
            power(n,m) = sign;
        end
    end
    m=0;
end

%plot Power results
figure(2)
plot(nanmean(power),'.-k')
xlabel('Minutes of periodicity in 45 min song','FontSize',24)
ylabel('Power','FontSize',24)
set(gca,'FontSize',14)
set(gca,'box','off')
xlim([1 45])