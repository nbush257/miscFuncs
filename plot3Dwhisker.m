function plot3Dwhisker(w)
for ii =1:length(w)
    if isempty(w(ii).x)
        continue
    end
    
    plot3(w(ii).x,w(ii).y,w(ii).z,'o-')
    pause(.01)
end
