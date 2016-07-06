ca
n = 300; % padsize
d = dir('*.tif');
Mpad = padarray(M',n+1,nan);
THpad = padarray(THP',n+1,nan);
FXpad = padarray(FX',n+1,nan);
figure(1)
figure(2)
counter = 0;
ii=0;
while ii<length(d)
    if ~C(ii+1)
        ii= ii+6;
    else
        ii = ii+1;
    end
    
    
    
    
    counter = counter+1;
    I = imread(d(ii).name);
    figure(1)
    
    cla
    imshow(I)
    title(['Frame: ' num2str(ii)])
    ho
    plot(xw{ii},yw{ii},'.')
    
    plot(scale(Mpad(ii:ii+n))*100+900);ln3
    plot(scale(FXpad(ii:ii+n))*100+800);ln3
    plot(scale(THpad(ii:ii+n))*100+700);ln3
    imtext(.1,.1,'M')
    imtext(.1,.2,'FX')
    imtext(.1,.3,'THP')
    drawnow
    figure(2)
    if counter >2
        rm(1)
    else
        plot(THpad(1:ii+n),Mpad(1:ii+n),'k.')
    end
    if THpad(ii+n)==0
        continue
    end
    
    plot(THpad(1:ii+n),Mpad(1:ii+n),'k.')
    ho
    scatter(THpad(ii+n),Mpad(ii+n),30,'r','filled')
    
    xlabel('THP')
    ylabel('M')
    pause(.1)
    drawnow
end
