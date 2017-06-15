function h=formatFig(h,ht,wd)
%% function h=formatFig(h,ht,wd)


h.Units = 'in';
h.PaperUnits = h.Units;
h.PaperPosition = [0 0 wd ht];
h.Position = [1 1 wd ht];