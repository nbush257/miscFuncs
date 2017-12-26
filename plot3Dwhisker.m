function plot3Dwhisker(w,stride,start)
max_x = nan(length(w),1);
max_y = nan(length(w),1);
max_z = nan(length(w),1);

min_x = nan(length(w),1);
min_y = nan(length(w),1);
min_z = nan(length(w),1);
lims = nan(length(w),6);
for ii = 1:length(w)
    if isempty(w(ii).x)
        continue
    end
    
    lims(ii,4) = max(w(ii).x);
    lims(ii,5) = max(w(ii).y);
    lims(ii,6) = max(w(ii).z);
    
    lims(ii,1) = min(w(ii).x);
    lims(ii,2) = min(w(ii).y);
    lims(ii,3) = min(w(ii).z);
end
lims2(:,1:3) = nanmean(lims(:,1:3))-nanstd(lims(:,1:3))*3;
lims2(:,4:6) = nanmean(lims(:,4:6))+nanstd(lims(:,4:6))*3;

first = true;


for ii =start:stride:length(w)
    if isempty(w(ii).x)
        continue
    end
    
    subplot(2,2,1:2)
    cla
    plot3(w(ii).x,w(ii).y,w(ii).z,'.-')
    axis equal
    grid on

    if first
        ax1 = gca;
        first = false;
    end
    ax = gca;
    ax.XLim = [lims2(1) lims2(4)];
    ax.YLim = [lims2(2) lims2(5)];
    ax.ZLim = [lims2(3) lims2(6)];
    
    subplot(2,2,3)
    cla
    plot3(w(ii).x,w(ii).y,w(ii).z,'.-')
    view(0,90)
    ax = gca;
    axis equal
    ax.XLim = [lims2(1) lims2(4)];
    ax.YLim = [lims2(2) lims2(5)];
    ax.ZLim = [lims2(3) lims2(6)];
    
    subplot(2,2,4)
    cla
    plot3(w(ii).x,w(ii).y,w(ii).z,'.-')
    view(0,0)
    ax = gca;
    axis equal
    ax.XLim = [lims2(1) lims2(4)];
    ax.YLim = [lims2(2) lims2(5)];
    ax.ZLim = [lims2(3) lims2(6)];
    
    
    drawnow
    
end
