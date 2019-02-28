%% set up the model of a CA3 cell from Traub et al. 1991
% https://www.physiology.org/doi/pdf/10.1152/jn.1991.66.2.635

% instantiate the xolotl object
x = xolotl;

% instantiate the apical dendrite compartments
x.add('compartment', 'ApicalDendrite', 'Cm', 30, 'radius', 2.89/1e3, 'len', 120/1e3);
x.ApicalDendrite.add('traub/CalciumMech', 'f', 1, 'tau_Ca', 1);
x.ApicalDendrite.add('traub/NaV', 'gbar', 0, 'E', 50);
x.ApicalDendrite.add('traub/Cal', 'gbar', 0, 'E', 30);
x.ApicalDendrite.add('traub/Kd', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('traub/Kahp', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('traub/Kc', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('traub/ACurrent', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('Leak', 'gbar', 1, 'E', -50);
x.slice('ApicalDendrite', 10);

% instantiate the basal dendrite compartments
x.add('compartment', 'BasalDendrite', 'Cm', 30, 'radius', 4.23/1e3, 'len', 125/1e3);
x.BasalDendrite.add('traub/CalciumMech', 'f', 1, 'tau_Ca', 1);
x.BasalDendrite.add('traub/NaV', 'gbar', 0, 'E', 50);
x.BasalDendrite.add('traub/Cal', 'gbar', 40, 'E', 30);
x.BasalDendrite.add('traub/Kd', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('traub/Kahp', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('traub/Kc', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('traub/ACurrent', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('Leak', 'gbar', 1, 'E', -50);
x.slice('BasalDendrite', 8);

% instantiate the somatic compartment
x.add('compartment', 'Somatic', 'Cm', 30, 'radius', 2.42/1e3, 'len', 110/1e3);
x.Somatic.tree_idx = 0;
x.Somatic.add('traub/CalciumMech', 'f', 1, 'tau_Ca', 1);
x.Somatic.add('traub/NaV', 'gbar', 300, 'E', 50);
x.Somatic.add('traub/Cal', 'gbar', 40, 'E', 30);
x.Somatic.add('traub/Kd', 'gbar', 150, 'E', -80);
x.Somatic.add('traub/Kahp', 'gbar', 8, 'E', -80);
x.Somatic.add('traub/Kc', 'gbar', 100, 'E', -80);
x.Somatic.add('traub/ACurrent', 'gbar', 50, 'E', -80);
x.Somatic.add('Leak', 'gbar', 1, 'E', -50);

% connect the apical and the basal dendrites to the soma
x.connect('ApicalDendrite10', 'Somatic', 'Axial', 'gmax', 100);
x.connect('Somatic', 'ApicalDendrite10', 'Axial', 'gmax', 100);
x.connect('BasalDendrite1', 'Somatic', 'Axial', 'gmax', 100);
x.connect('Somatic', 'BasalDendrite1', 'Axial', 'gmax', 100);
