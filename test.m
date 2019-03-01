%% set up the model of a CA3 cell from Traub et al. 1991
% https://www.physiology.org/doi/pdf/10.1152/jn.1991.66.2.635

% instantiate the xolotl object
x = xolotl;

%% Instantiate compartments and conductances

% instantiate the apical dendrite compartments
x.add('compartment', 'ApicalDendrite', 'Cm', 30, 'radius', 2.89/1e3, 'len', 10*120/1e3);
x.ApicalDendrite.add('traub/CalciumMech', 'f', 5941, 'tau_Ca', 13.33);
x.ApicalDendrite.add('traub/NaV', 'gbar', 0, 'E', 50);
x.ApicalDendrite.add('traub/Cal', 'gbar', 0, 'E', 30);
x.ApicalDendrite.add('traub/Kd', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('traub/Kahp', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('traub/KCa', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('traub/ACurrent', 'gbar', 0, 'E', -80);
x.ApicalDendrite.add('Leak', 'gbar', 1, 'E', -50);

% instantiate the basal dendrite compartments
x.add('compartment', 'BasalDendrite', 'Cm', 30, 'radius', 4.23/1e3, 'len', 8*125/1e3);
x.BasalDendrite.add('traub/CalciumMech', 'f', 7769, 'tau_Ca', 13.33);
x.BasalDendrite.add('traub/NaV', 'gbar', 0, 'E', 50);
x.BasalDendrite.add('traub/Cal', 'gbar', 40, 'E', 30);
x.BasalDendrite.add('traub/Kd', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('traub/Kahp', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('traub/KCa', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('traub/ACurrent', 'gbar', 0, 'E', -80);
x.BasalDendrite.add('Leak', 'gbar', 1, 'E', -50);

% instantiate the somatic compartment
x.add('compartment', 'Somatic', 'Cm', 30, 'radius', 2.42/1e3, 'len', 110/1e3);
x.Somatic.add('traub/CalciumMech', 'f', 17402, 'tau_Ca', 13.33);
x.Somatic.add('traub/NaV', 'gbar', 300, 'E', 50);
x.Somatic.add('traub/Cal', 'gbar', 40, 'E', 30);
x.Somatic.add('traub/Kd', 'gbar', 150, 'E', -80);
x.Somatic.add('traub/Kahp', 'gbar', 8, 'E', -80);
x.Somatic.add('traub/KCa', 'gbar', 100, 'E', -80);
x.Somatic.add('traub/ACurrent', 'gbar', 50, 'E', -80);
x.Somatic.add('Leak', 'gbar', 1, 'E', -50);

%% Instantiate synapses

% slice the dendrites
x.slice('ApicalDendrite', 10);
x.slice('BasalDendrite', 8);
x.Somatic.tree_idx = 0;

% connect the apical and the basal dendrites to the soma
x.connect('ApicalDendrite10', 'Somatic', 'Axial', 'gmax', 100);
x.connect('Somatic', 'ApicalDendrite10', 'Axial', 'gmax', 100);
x.connect('BasalDendrite1', 'Somatic', 'Axial', 'gmax', 100);
x.connect('Somatic', 'BasalDendrite1', 'Axial', 'gmax', 100);

%% Set conductances for CA3 model

comps = x.find('compartment');
conds = {'NaV', 'Cal', 'Kd', 'Kahp', 'KCa', 'ACurrent', 'Leak'};
gbars = 10*[0 0 0 0 0 0 0.1; ...
         0 5 0 0.8 5.0 0 0.1; ...
         0 5 0 0.8 5 0 0.1; ...
         0 12 0 0.8 10 0 0.1; ...
         20 12 20 0.8 10 0 0.1; ...
         0 5 0 0.8 5 0 0.1; ...
         15 8 5 0.8 20 0 0.1; ...
         15 8 5 0.8 20 0 0.1; ...
         15 8 5 0.8 20 0 0.1; ...
         0 5 0 0.8 5 0 0.1; ...
         20 17 20 0.8 15 0 0.1; ...
         0 17 20 0.8 15 0.0 0.1; ...
         0 17 20 0.8 15 0.0 0.1; ...
         0 10 20 0.8 15 0.0 0.1; ...
         0 10 20 0.8 15 0.0 0.1; ...
         0 5 20 0.8 15 0.0 0.1; ...
         0 5 20 0.8 15 0.0 0.1; ...
         0 0 0 0 0 0 0.1; ...
         30 4 15 0.8 10 50 0.1];

for ii = 1:length(comps)
    for qq = 1:length(conds)
        x.(comps{ii}).(conds{qq}).gbar = gbars(ii, qq);
    end
end
