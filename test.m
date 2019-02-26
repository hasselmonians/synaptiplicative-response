% test a simple model of the dendrite based on Behabadi et al. 2012
% proximal-distal, time-invariant 2-compartment model

% instantiate the xolotl object
x = xolotl;

% create the compartments
x.add('compartment', 'proximal', 'Cm', 10, 'A', 0.01);
% x.add('compartment', 'distal', 'Cm', 10, 'radius', 0.001, 'len', 0.010);
x.add('compartment', 'presynaptic');

% add leak currents
x.proximal.add('Leak', 'gbar', 0, 'E', -70);
% x.distal.add('Leak', 'gbar', @() 4, 'E', -70);

% connect the compartments
% x.connect('proximal', 'distal', 'Axial', 'gmax', @() 2.5);

% add synapses from controlling compartment to proximal and distal compartments
x.connect('presynaptic', 'proximal', 'borgers/NMDAergic', 'gmax', 100, 'E', 0);
% x.connect('presynaptic', 'distal', 'borgers/NMDAergic', 'gmax', @() 0.0, 'E', 0);

% voltage clamp the presynaptic compartment
V_clamp = NaN * x.integrate;
nSteps = x.t_end / x.dt;
spike_start = round(0.2*nSteps);
spike_stop = spike_start + spike_start;
V_clamp(:,1) = -60;
V_clamp(spike_start:spike_stop, 1) = 50;
