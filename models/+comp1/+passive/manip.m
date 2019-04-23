% creates a manipulation figure that allows for manual optimization/exploration
% of the parameter space

x = comp1.passive.model();
x.manipulate_plot_func = {@comp1.manip_func};

x.manipulate([x.find('Dendrite*gbar'); x.find('Dendrite*NMDAergic*gmax')])
