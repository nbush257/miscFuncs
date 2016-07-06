function idx = manualSpikeSort_GUI(spikes)

if size(spikes,2)<size(spikes,1)
    spikes = spikes';
end
plot(spikes,'k');
uicontrol('Style','popupmenu', 'String',[1,2,3,4,5],'Position',[100 100 50 10 ])

keepSorting = 1;
while keepSorting
    [vecX,vecY,but] = ginput(2);
    if but(1)~=but(2)
        continue
    end
    % add to new cluster
    if but(1) == 1
    % find intersections
    
    end
    
    % remove spikes
    if but(1) == 3
        % find intersections
    end
    
        
    