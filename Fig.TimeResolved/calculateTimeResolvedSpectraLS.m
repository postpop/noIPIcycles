cc()
addpath('../code')
% files with pulsetimes/intervals of5 different datasets and annotations
fileNames = {'Stern2014_FSSCoen2014.mat'}

%%
ipiCutoffLow = 15/1000;    % [ms] lower cutoff for ipis - anything shorter is likely segmentation error
ipiCutoffHigh = 75/1000;   % [ms] upper cutoff for ipis - anything longer will be removed from analysis
OFAC = 20;        % Lomb Scargle oversampling factor (see help lomb)
HIFAC = 0.4;      % Lomb Scargle (see help lomb)
alpha = 0.05;     % significance level for peak detection
period = 5*60;    % calc spec over 5min windows
overlap = period/2; % with 50% overlap

F = 1./(20:.1:150);
dK = load(['../data/' 'Stern2014_KyriacouManual2017.mat']); %  manual annotation by Kyriacou et al. (2017)
randLabel = {'original','shuffled'}; % cut recordings to the part that was manually annotated manually or use full recording
%%
for fil = 1:length(fileNames) % for each annotation - manual Kyriacou et al. 2017, automatic with parameters from Stern et al. (2014) and Coen et al. (2014)
   disp(fileNames{fil})
   d = load(['../data/' fileNames{fil}]); % load results from all flies for the current segmentation
   clear a spec peak
   for ic = 1:length(ipiCutoffHigh) % cut off IPIs at 55 or 75 ms
      for ct = 1:2  % cut recordings to the part that was manually annotated manually or use full recording
         for fly = 1:size(d.ipi,2) % for each fly
            
            try
               disp(d.flyNames{fly})
               ipi = d.ipi(:,fly);        % ipis in seconds
               t = d.pulseTimes(:,fly);   % pulses times in seconds
               
               [t, ipi] = cleanData(t, ipi, ipiCutoffLow, ipiCutoffHigh(ic));
               
               if ct == 2 % randomize ipi sequence
                  ipi = ipi(randperm(length(ipi)));
               end
               
               %% calculate spectra using cosinor
               % cut into 5min bins with 50% overlap - only use bins with
               % at least N ipis, keep significant peaks only
%                chunks = linspace(min(t), max(t)-period, overlap);
               chunks = linspace(0, 45*60-period, overlap);
               for chk = 1:length(chunks)
                  fprintf('.')
                  thisIdx = find(t>chunks(chk) & t<=chunks(chk)+period);
                  spec.N(fly,chk) = length(thisIdx);
                  if spec.N(fly,chk)>100
                     [thisSpec, thisPeak, thisA] = ipiSpectra(t(thisIdx),ipi(thisIdx), OFAC, HIFAC, alpha, F);
                     % reassemble data
                     spec.F{fly,chk} = thisSpec.F; spec.P{fly,chk} = thisSpec.P; spec.p{fly,chk} = thisSpec.p;
                     peak.amp{fly,chk} = thisPeak.amp; peak.loc{fly,chk} = thisPeak.loc;
                     peak.prob{fly,chk} = thisPeak.prob; peak.significant{fly,chk} = thisPeak.significant;
                     a.F = thisA.F; a.spec(:,fly,chk) = thisA.spec;
                  end
               end
               fprintf('!\n')
               a.flyNames{fly} = d.flyNames{fly};
            catch ME
               disp(ME.getReport())
            end
         end
         saveFileName = sprintf('%s_specLS_ipiCutoff%dms_%s', fileNames{fil}(1:end-4), ipiCutoffHigh(ic)*1000, randLabel{ct});
         fprintf('saving to %s.\n', saveFileName)
         save(saveFileName, 'spec', 'peak', 'a')
      end
   end
end