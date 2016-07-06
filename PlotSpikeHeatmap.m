function PlotSpikeHeatmap(spikes)
% plot spike heatmap
if size(spikes,1)>size(spikes,2)
    spikes = spikes';
end
vVec = spikes(:);
tVec = repmat(1:size(spikes,1),1,size(spikes,2));
[I,N] = hist3([vVec tVec'],[round(max(vVec)-min(vVec)) size(spikes,1)]);
f1 = figure;
imagesc(N{2},N{1},I)
set(gca,'YDir','normal')
ho
errorbar(mean(spikes,2),std(spikes'),'k.');ln2;
title(vertcat({'Sorted Spike','errorbars = +/-S.D.'}))
xlabel('Time (samples)')
ylabel('Voltage (\muV)')

