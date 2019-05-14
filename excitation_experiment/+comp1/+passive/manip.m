x = comp1.passive.model();
x.manipulate_plot_func = {@comp1.manip_func};

x.manipulate([x.find('Dendrite*gbar'); x.find('Dendrite*AMPAergic*gmax'); x.find('Dendrite*NMDAergic*gmax')])
