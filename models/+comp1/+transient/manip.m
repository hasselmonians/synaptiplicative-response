% creates a manipulation figure that allows for manual optimization/exploration
% of the parameter space

x = comp1.transient.model();
x.manipulate_plot_func = {@comp1.manip_func};

x.manipulate([x.find('*gbar'); x.find('*NMDAergic*gmax')])
