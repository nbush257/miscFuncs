function [cMap] = colormapFade(color,n,toBlack)
%% function [cMap] = colormapFade(color,[n (int),toBlack(bool)])
%% Make Colormap that fades to black
% Color should be a string with one of the following values:
% red, green, blue, magenta, yellow, cyan, ltBlue, ltGreen, pink, orange,
% purple, gray.
% n should be number of values to be mapped to colors

%% Originally written my Chris Bresee. Modified by NEB 2015_12_08 to be able to fade to
% white and to take standard color string inputs when possible
%%
if nargin <2
    fprintf('Defaulting to 100 spacings\n')
    n = 100;
end
if nargin <3
    fprintf('Defaulting to Fade To Black\n')
    toBlack =1;
end


% top colors
colors.red = [1 0 0]; colors.r = [1 0 0];
colors.green = [0 1 0]; colors.g = [0 1 0];
colors.blue = [0 0 1];  colors.b = [0 0 1];
colors.magenta = [1 0 1];colors.m = [1 0 1];
colors.yellow = [1 1 0]; colors.y = [1 1 0];
colors.cyan = [0 1 1]; colors.c = [0 1 1];
colors.ltBlue = [.60 .70 1];
colors.ltGreen = [.90 1 .90];
colors.pink = [1 .90 .90];
colors.orange = [1 .75 0];
colors.purple = [.8 .45 .85];
colors.gray = [0.95 0.95 0.95]; colors.k = [.5 .5 .5];

% find the color you want
map = zeros(n,3);
map(1,:) = colors.(color);

% find how much to decrement by for a given n
dec = map(1,:).*[1/(n) 1/(n) 1/(n)];


% fade to almost black over n iterations
if toBlack
    for i = 2:n
        
        % find the color you want to start with
        map(i,:) = map(i-1,:)-dec;
        
    end
else
    for ii =1:3
        if map(1,ii) == 1
            map(:,ii) = ones(n,1);
        else
            map(:,ii) = linspace(map(1,ii),.95,n);
        end
    end
end
cMap = map;

end

