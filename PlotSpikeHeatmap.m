function PlotSpikeHeatmap(spikes)
%% function PlotSpikeHeatmap(spikes)
% ========================================
% creates a heatmap of a spike waveform. This highlights how good a sort is
% by weighting the heatmap based on the number of spikes. It you simply
% plot an overlay of the spikes, the image overrepresents the false
% positives, and doesn't show how many spikes are overlapping
% ========================================
% INUPTS:
%           spikes - a matrix of spikes where the first dimension is time
%              (rows) and the second dimension is spike number (columns).
%              (Generally 60 x N)
%=========================================
% NEB 2016
%%
if size(spikes,1)>size(spikes,2)
    spikes = spikes';
    disp('Spikes should have timepoints on the rows, and observations on the columns.\nIf you have fewer spikes than number of timepoints in a spike this function will be incorrect')
end


vVec = spikes(:);
tVec = repmat(1:size(spikes,1),1,size(spikes,2));
[I,N] = hist3([vVec tVec'],[round(max(vVec)-min(vVec)) size(spikes,1)]);

f1 = figure;
imagesc(N{2},N{1},I)
set(gca,'YDir','normal')
hold on
errorbar(mean(spikes,2),std(spikes'),'k.');ln2;
title(vertcat({'Sorted Spike','errorbars = +/-S.D.'}))
xlabel('Time (samples)')
ylabel('Voltage (\muV)')

