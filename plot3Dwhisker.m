function plot3Dwhisker(w,stride)
max_x = nan(length(w),1);
max_y = nan(length(w),1);
max_z = nan(length(w),1);

min_x = nan(length(w),1);
min_y = nan(length(w),1);
min_z = nan(length(w),1);

for ii = 1:length(w)
    if isempty(w(ii).x)
        continue
    end
    
    max_x(ii) = max(w(ii).x);
    max_y(ii) = max(w(ii).y);
    max_z(ii) = max(w(ii).z);
    
    min_x(ii) = min(w(ii).x);
    min_y(ii) = min(w(ii).y);
    min_z(ii) = min(w(ii).z);
    
end
max_x = max(max_x);
max_y = max(max_y);
max_z = max(max_z);

min_x = min(min_x);
min_y = min(min_y);
min_z = min(min_z);

first = true;


for ii =1:stride:length(w)
    if isempty(w(ii).x)
        continue
    end
    
    subplot(2,2,1:2)
    cla
    plot3(w(ii).x,w(ii).y,w(ii).z,'o-')
    axis equal

    if first
        ax1 = gca;
        first = false;
    end
    ax = gca;
    ax.XLim = ax1.XLim + 0.3*diff(ax1.XLim)*[-1 1];
    ax.YLim = ax1.YLim + 0.3*diff(ax1.YLim)*[-1 1];
    ax.ZLim = ax1.ZLim + 1*diff(ax1.ZLim)*[-1 1];
    
    subplot(2,2,3)
    cla
    plot3(w(ii).x,w(ii).y,w(ii).z,'o-')
    view(0,90)
    axis equal
    
    subplot(2,2,4)
    cla
    plot3(w(ii).x,w(ii).y,w(ii).z,'o-')
    view(0,0)
    axis equal
    
    
    drawnow
end
