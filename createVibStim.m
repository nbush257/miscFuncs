sampFr = 44100;
c=0;
y = [];
stimLength = 5;
silenceLength = 5;
for i = [100:20:300]
    
    c = c+1;
    freq = i%round(log(i));
    
    t = [0:1/sampFr:stimLength];
    A = 1;
    silence = zeros(1,length(0:1/sampFr:silenceLength));
    y = [y A*sin(2*pi*freq*t) silence];
end
wavwrite(y,sampFr,'vibSequence_100to300_20hz_res.wav');