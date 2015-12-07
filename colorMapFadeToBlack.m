%% Make Colormap that fades to black
% Color should be a string with one of the following values:
% red, green, blue, magenta, yellow, cyan, ltBlue, ltGreen, pink, orange,
% purple, gray.
% n should be number of values to be mapped to colors

%%

function [cMap] = colorMapFadeToBlack(color, n)

% top colors
colors.red = [1 0 0]; 
colors.green = [0 1 0]; 
colors.blue = [0 0 1]; 
colors.magenta = [1 0 1];
colors.yellow = [1 1 0]; 
colors.cyan = [0 1 1]; 
colors.ltBlue = [.60 .70 1]; 
colors.ltGreen = [.90 1 .90]; 
colors.pink = [1 .90 .90]; 
colors.orange = [1 .75 0]; 
colors.purple = [.8 .45 .85]; 
colors.gray = [0.95 0.95 0.95]; 

% find the color you want
map = zeros(n,3);
map(1,:) = colors.(color);

% find how much to decrement by for a given n
dec = map(1,:).*[1/(n) 1/(n) 1/(n)];

% fade to almost black over n iterations
for i = 2:n
    
    % find the color you want to start with
     map(i,:) = map(i-1,:)-dec;
    
end

cMap = map;

end

