% test a simple model of the dendrite based on Behabadi et al. 2012
% proximal-distal, time-invariant 2-compartment model

% preamble
cond_scale = 1;

% instantiate the xolotl object
x = xolotl;

% create the compartments
x.add('compartment', 'prox', 'Cm', 10, 'radius', 0.001, 'len', 0.010);
x.add('compartment', 'dist', 'Cm', 10, 'radius', 0.001, 'len', 0.010);
x.add('compartment', 'presynaptic');

% add leak currents
x.prox.add('Leak', 'gbar', @() 4*cond_scale, 'E', -70);
x.dist.add('Leak', 'gbar', @() 4*cond_scale, 'E', -70);

% connect the compartments
x.connect('prox', 'dist', 'gmax', @() 2.5*cond_scale);

% add synapses from controlling compartment to proximal and distal compartments
x.connect('presynaptic', 'prox', 'borgers/NMDAergic', 'gmax', @() 0.5*cond_scale, 'E', 0);
x.connect('presynaptic', 'dist', 'borgers/NMDAergic', 'gmax', @() 0.0*cond_scale, 'E', 0);
