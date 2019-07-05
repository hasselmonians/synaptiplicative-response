% script that makes a bunch of plots to try to make sense of data

% canonical model
x = model();
x.set('*gmax', 30);
plotDelay(x);

return

% weaker synaptic connection
x = model();
x.set('*gmax', 15);
plotDelay(x);

% stronger synaptic connection
x = model();
x.set('*gmax', 60);
plotDelay(x);
