cc()
randLabel = {'original', 'shuffled'};
% load Cosinor spectra for manually segemented song (original and shuffled IPIs)
for ii = 1:2
   d{ii} = load(['Stern2014_FSSCoen2014_specLS_ipiCutoff75ms_' randLabel{ii}]);
end

period = 5*60;    % calc spec over 5min windows
overlap = period/2; % with 50% overlap
T = linspace(1, 45, period/2);
dK = load(['../data/' 'Stern2014_KyriacouManual2017.mat']); %  manual annotation by Kyriacou et al. (2017)

%%
for ii = 1:length(d)
   flyIdx = find(~cellfun(@isempty,d{ii}.a.flyNames));
   %    flyIdx = nonEmpty(contains(d{ii}.a.flyNames(nonEmpty), 'perL') | contains(d{ii}.a.flyNames(nonEmpty), 'CS'));
   flyIdx = flyIdx(endsWith(d{ii}.a.flyNames(flyIdx), dK.flyNames));
   flyNames = d{ii}.a.flyNames(flyIdx);
   flyG = contains(d{ii}.a.flyNames(flyIdx), 'CS')';
   clf
   hold on
   
   allProb = [];
   allPer = [];
   allSpec = [];
   allFly = [];
   allChk = [];
   for fly = 1:length(flyIdx)
      disp(d{ii}.a.flyNames(flyIdx(fly)))
      for chk = 1:size(d{ii}.peak.amp,2)
         thisSpec = d{ii}.peak.amp{flyIdx(fly),chk};
         F = d{ii}.spec.F{flyIdx(fly),chk};
         thisPer = 1./F(d{ii}.peak.loc{flyIdx(fly), chk});
         thisProb = d{ii}.peak.prob{flyIdx(fly), chk};
         badIdx = thisPer<20 | thisPer>150 | d{ii}.spec.N(fly,chk)<100;
         thisSpec(badIdx) = [];
         thisProb(badIdx) = [];
         thisPer(badIdx) = [];
         allProb = [allProb; thisProb];
         allPer = [allPer; thisPer];
         allSpec = [allSpec; thisSpec];
         allChk = [allChk; chk*ones(size(thisSpec))];
         allFly = [allFly; fly*ones(size(thisSpec))];
      end
   end
   %%
   clf
   mySubPlot(3,5,1,1:2)
   ghist(allPer(allProb<0.05), flyG(allFly(allProb<0.05)),20:10:150,1)
   legend({'CS', 'perL'}, 'Box','off')
   ylabel('pdf')
   xlabel('period of significant peaks')
   set(gca, 'YLim',[0 0.55])
   [ksh, ksp] = kstest2(allPer(allProb<0.05 & flyG(allFly)==0), allPer(allProb<0.05 & flyG(allFly)==1));
   title(sprintf('KS, p=%1.1e', ksp))
   
   mySubPlot(3,5,1,3:4)
   ghist(allPer(allProb<0.05), flyG(allFly(allProb<0.05)),20:10:150,0)
   ylabel('count')
   xlabel('period of significant peaks')
   set(gca, 'YLim',[0 200])
   set(gcas, 'XLim', [16 154])
   
   mySubPlot(3,5,1,5)
   boxplot(allPer(allProb<0.05), flyG(allFly(allProb<0.05)))
   prs = ranksum(allPer(allProb<0.05 & flyG(allFly)==0), allPer(allProb<0.05 & flyG(allFly)==1))
   set(gca, 'XTick', [1 2], 'XTickLabel', {'CS', 'perL'}, 'YLim', [16 154], 'YTick', [20 50 100 150])
   ylabel('period of significant peaks')
   title(sprintf('ranksum p=%1.1e', prs))
   try
      perm = nan(150,2);
      pers = nan(150,2);
      pern = nan(150,2);
      for gg = 1:2
         [m, s, g, n] = grpstats(allPer(allProb<0.05 & flyG(allFly)==gg-1), allChk(allProb<0.05 & flyG(allFly)==gg-1), {@mean, @std, 'gname', 'numel'});
         g = str2double(g);
         perm(g,gg) = m;
         pers(g,gg) = s;
         pern(g,gg) = n;
      end
      
      subplot(312)
      plot(T, pern./[sum(flyG==1) sum(flyG==0)], 'LineWidth', 2)
      legend({'CS', 'perL'}, 'Box','off')
      axis('tight')
      set(gca, 'YLim', [0 1])
      xlabel('time during courtship [minutes]')
      ylabel('number of significant peaks')
      [r2v, r2p] = rsq(T, pern(:,2));
      text(10, 0.7,sprintf('r^2=%1.2f (p=%1.1e)', r2v, r2p))
      [r2v, r2p] = rsq(T, pern(:,1));
      text(10, 0.8,sprintf('r^2=%1.2f (p=%1.1e)', r2v, r2p))
      
      subplot(313)
      [hL] = myErrorBar(T, perm, pers)
      axis('tight')
      xlabel('time during courtship [minutes]')
      legend(hL, {'CS', 'perL'}, 'Box','off')
      ylabel('period of significant peaks [seconds]')
      set(gca, 'YLim',[0 150])
      set(hL, 'LineWidth', 2)
      hline([20 150])
      [r2v, r2p] = rsq(T, perm(:,1));
      text(10, 120,sprintf('r^2=%1.2f (p=%1.1e)', r2v, r2p))
      [r2v, r2p] = rsq(T, perm(:,2));
      text(10, 100,sprintf('r^2=%1.2f (p=%1.1e)', r2v, r2p))
      
   end
   clp()
   if mfilename()
      figexp([mfilename() '_' randLabel{ii}], 0.9, 1.0)
   end
end