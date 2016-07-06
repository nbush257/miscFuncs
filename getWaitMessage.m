%wait messages
function message = getWaitMessage;
messages = {'Helping an old lady across the street','Washing the dog','Dont forget to call your parents','I never liked star wars','This is taking too long...','Are we there yet?','Reticulating Splines','You need more coffee'};
l = length(messages);
message = messages{randi(l)};
