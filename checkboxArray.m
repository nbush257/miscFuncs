%Created by Nick Bush 7/10/14

%creates a gui in the shape of the vibrissal array made of check boxes.
%Returns a struct output where each field is a whisker. Also includes
%micros and quadrants for a more qualitative analysis. The field entries
%are binary vectors where 1 means the box was checked in a particular
%frame, 0 means it was not.

%On each refresh, the checkboxes are set to their previous value. For
%example if in frame 1, you check A1, Alpha and Beta, Frame 2 will
%automatically have A1, Alpha, and Beta checked.

%The parameters a b and c denote the position and size of each box.

%If you skip any frames using the slider, all interleaving frames will be
%set to noncontact. you can go back and change it though.

function array = checkboxArray
ca
numFrames = input('How Many Frames?');
global run currentFrame i% allows the gui to be quit via a call back pushbutton
run = 1;
i=1;
while run == 1 % the local function kill makes run=0
    
    
    
    
    h= figure;
    set(h,'Position',[200 200 800 700])
    
    c = 50;%initialize position parameters
    a = 500;
    b = 100;
    %% build the structure of the gui
    a1 = uicontrol('String','A1','Style','checkbox','Position',[b a c c]);
    b=b+100;
    a2 = uicontrol('String','A2','Style','checkbox','Position',[b a c c]);
    b=b+100;
    a3 = uicontrol('String','A3','Style','checkbox','Position',[b a c c]);
    b=b+100;
    a4 = uicontrol('String','A4','Style','checkbox','Position',[b a c c]);
    b=b+100;
    
    
    a = 400;
    b = 100;
    
    
    b1 = uicontrol('String','B1','Style','checkbox','Position',[b a c c]);
    b=b+100;
    b2 = uicontrol('String','B2','Style','checkbox','Position',[b a c c]);
    b=b+100;
    b3 = uicontrol('String','B3','Style','checkbox','Position',[b a c c]);
    b=b+100;
    b4 = uicontrol('String','B4','Style','checkbox','Position',[b a c c]);
    b=b+100;
    
    
    a = 300;
    b =100;
    c1 = uicontrol('String','C1','Style','checkbox','Position',[b a c c]);
    b=b+100;
    c2 = uicontrol('String','C2','Style','checkbox','Position',[b a c c]);
    b=b+100;
    c3 = uicontrol('String','C3','Style','checkbox','Position',[b a c c]);
    b=b+100;
    c4 = uicontrol('String','C4','Style','checkbox','Position',[b a c c]);
    b=b+100;
    c5 = uicontrol('String','C5','Style','checkbox','Position',[b a c c]);
    b=b+100;
    c6 = uicontrol('String','C6','Style','checkbox','Position',[b a c c]);
    b=b+100;
    c7 = uicontrol('String','C7','Style','checkbox','Position',[b a c c]);
    
    a = 200;
    b = 100;
    
    d1 = uicontrol('String','D1','Style','checkbox','Position',[b a c c]);
    b=b+100;
    d2 = uicontrol('String','D2','Style','checkbox','Position',[b a c c]);
    b=b+100;
    d3 = uicontrol('String','D3','Style','checkbox','Position',[b a c c]);
    b=b+100;
    d4 = uicontrol('String','D4','Style','checkbox','Position',[b a c c]);
    b=b+100;
    d5 = uicontrol('String','D5','Style','checkbox','Position',[b a c c]);
    b=b+100;
    d6 = uicontrol('String','D6','Style','checkbox','Position',[b a c c]);
    b=b+100;
    d7 = uicontrol('String','D7','Style','checkbox','Position',[b a c c]);
    
    a = 100;
    
    b = 100;
    
    e1 = uicontrol('String','E1','Style','checkbox','Position',[b a c c]);
    b=b+100;
    e2 = uicontrol('String','E2','Style','checkbox','Position',[b a c c]);
    b=b+100;
    e3 = uicontrol('String','E3','Style','checkbox','Position',[b a c c]);
    b=b+100;
    e4 = uicontrol('String','E4','Style','checkbox','Position',[b a c c]);
    b=b+100;
    e5 = uicontrol('String','E5','Style','checkbox','Position',[b a c c]);
    b=b+100;
    e6 = uicontrol('String','E6','Style','checkbox','Position',[b a c c]);
    b=b+100;
    e7 = uicontrol('String','E7','Style','checkbox','Position',[b a c c]);
    
    
    b=0;
    a=150;
    delta = uicontrol('String','Delta','Style','checkbox','Position',[b a c c]);
    a=a+100;
    gamma = uicontrol('String','Gamma','Style','checkbox','Position',[b a c c]);
    a=a+100;
    beta = uicontrol('String','Beta','Style','checkbox','Position',[b a c c]);
    a=a+100;
    alpha = uicontrol('String','Alpha','Style','checkbox','Position',[b a c c]);
    
    b = 550;
    a = 400;
    %Quadrants and micros
    rd = uicontrol('String','DorsoRostral','Style','checkbox','Position',[b+100 a+100 c+50 c+20]);
    cd = uicontrol('String','DorsoCaudal','Style','checkbox','Position',[b a+100 c+50 c+20]);
    rv = uicontrol('String','VentroRostral','Style','checkbox','Position',[b+100 a c+50 c+20]);
    cv = uicontrol('String','VentroCaudal','Style','checkbox','Position',[b a c+50 c+20]);
    micros = uicontrol('String','Micros','Style','checkbox','Position',[100 0 300 50]);
    
    txt = uicontrol('Style','text','Position',[400 620 100 20],'String',int2str(i));
    frame = uicontrol('String', 'Frame Number','Style','Slider','Min',1,'Max',numFrames,'Position',[400 600 100 20],'Callback',@updateSlider,'SliderStep',[1/numFrames 10/numFrames]);
    
    set(frame,'Value',i);
    
    
    
    %labels
    annotation('textbox',[.9 .9 .1 .1], 'String','Rostral ->');
    %creates button to exit the gui
    quit = uicontrol('Style','pushbutton','Position',[0 0 50 100],'Callback',@kill,'String','quit');
    
    %% sets the state of the check boxes to the previous value
    if i>1
        set(a1,'Value',array.a1(i-1))
        set(a2,'Value',array.a2(i-1))
        set(a3,'Value',array.a3(i-1))
        set(a4,'Value',array.a4(i-1))
        
        set(b1,'Value',array.b1(i-1))
        set(b2,'Value',array.b2(i-1))
        set(b3,'Value',array.b3(i-1))
        set(b4,'Value',array.b4(i-1))
        
        set(c1,'Value',array.c1(i-1))
        set(c2,'Value',array.c2(i-1))
        set(c3,'Value',array.c3(i-1))
        set(c4,'Value',array.c4(i-1))
        set(c5,'Value',array.c5(i-1))
        set(c6,'Value',array.c6(i-1))
        set(c7,'Value',array.c7(i-1))
        
        set(d1,'Value',array.d1(i-1))
        set(d2,'Value',array.d2(i-1))
        set(d3,'Value',array.d3(i-1))
        set(d4,'Value',array.d4(i-1))
        set(d5,'Value',array.d5(i-1))
        set(d6,'Value',array.d6(i-1))
        set(d7,'Value',array.d7(i-1))
        
        set(e1,'Value',array.e1(i-1))
        set(e2,'Value',array.e2(i-1))
        set(e3,'Value',array.e3(i-1))
        set(e4,'Value',array.e4(i-1))
        set(e5,'Value',array.e5(i-1))
        set(e6,'Value',array.e6(i-1))
        set(e7,'Value',array.e7(i-1))
        
        set(alpha,'Value',array.alpha(i-1));
        set(beta,'Value',array.beta(i-1));
        set(gamma,'Value',array.gamma(i-1));
        set(delta,'Value',array.delta(i-1));
        
        set(rv,'Value',array.delta(i-1));
        set(cv,'Value',array.delta(i-1));
        set(rd,'Value',array.delta(i-1));
        set(cd,'Value',array.delta(i-1));
        set(micros,'Value',array.micros(i-1));
        
    end
    
    pause
    
    %exits the gui if the quit button is pressed. This part is not really
    %well written, kinda funky, but the best I could get.
    if run == 0
        break
    end
    
    %% Saves the entries into the 'array' struct.
    i = round(i);
    array.a1(i) = get(a1,'Value');
    array.a2(i) = get(a2,'Value');
    array.a3(i) = get(a3,'Value');
    array.a4(i) = get(a4,'Value');
    
    array.b1(i) = get(b1,'Value');
    array.b2(i) = get(b2,'Value');
    array.b3(i) = get(b3,'Value');
    array.b4(i) = get(b4,'Value');
    
    array.c1(i) = get(c1,'Value');
    array.c2(i) = get(c2,'Value');
    array.c3(i) = get(c3,'Value');
    array.c4(i) = get(c4,'Value');
    array.c5(i) = get(c5,'Value');
    array.c6(i) = get(c6,'Value');
    array.c7(i) = get(c7,'Value');
    
    array.d1(i) = get(d1,'Value');
    array.d2(i) = get(d2,'Value');
    array.d3(i) = get(d3,'Value');
    array.d4(i) = get(d4,'Value');
    array.d5(i) = get(d5,'Value');
    array.d6(i) = get(d6,'Value');
    array.d7(i) = get(d7,'Value');
    
    array.e1(i) = get(e1,'Value');
    array.e2(i) = get(e2,'Value');
    array.e3(i) = get(e3,'Value');
    array.e4(i) = get(e4,'Value');
    array.e5(i) = get(e5,'Value');
    array.e6(i) = get(e6,'Value');
    array.e7(i) = get(e7,'Value');
    
    array.alpha(i) = get(alpha,'Value');
    array.beta(i) = get(beta,'Value');
    array.gamma(i) = get(gamma,'Value');
    array.delta(i) = get(delta,'Value');
    
    array.rv(i)=get(rv,'Value');
    array.rd(i)=get(rd,'Value');
    array.cv(i)=get(cv,'Value');
    array.cd(i)=get(cd,'Value');
    array.micros(i)=get(micros,'Value');
    
    close(h);
    i = i+1;
    
    
    
    
end


end

%% Local function to exit the gui by setting run = 0
function kill(hObject,eventdata)
global run
close all
run = 0;
disp('Press enter to exit the function')
end


function updateSlider(hObject,eventdata)
global i;
i = get(hObject,'Value');
i = round(i);
txt = uicontrol('Style','text','Position',[400 620 100 20],'String',int2str(i));
end

