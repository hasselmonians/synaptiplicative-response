function x = make_dendriteModel(N, postsynaptic)
    % produces a model of CA1/CA3 dendrites in xolotl
    %
    % N is the number of compartments
    %
    % postsynaptic is a 2x1 cell array containing character vector indices
    % to which compartments should be postsynaptic to the NMDA synapses
    %
    % measurements cited in Traub et al. 1991
    % based on Turner & Schwartzkroin 1980, 1983; & others

    %% Instantiate the xolotl object

    x = xolotl;

    %% Instantiate compartments and conductances

    % add basilar dendrite compartment
    x.add('compartment', 'Dendrite', 'Cm', 30, 'radius', 2.42/1e3, 'len', N*110/1e3);

    % add conductances with no maximal conductance
    % maximal conductance values are arbitrary
    x.Dendrite.add('traub/CalciumMech', 'f', 7769, 'tau_Ca', 13.33);
    x.Dendrite.add('traub/NaV', 'gbar', 0.1, 'E', 50);
    x.Dendrite.add('traub/Cal', 'gbar', 0.1, 'E', 30);
    x.Dendrite.add('traub/Kd', 'gbar', 0.1, 'E', -80);
    x.Dendrite.add('traub/Kahp', 'gbar', 0.1, 'E', -80);
    x.Dendrite.add('traub/KCa', 'gbar', 0.1, 'E', -80);
    x.Dendrite.add('traub/ACurrent', 'gbar', 0.1, 'E', -80);
    x.Dendrite.add('Leak', 'gbar', 1, 'E', -50);

    % slice the compartments into N sub-compartments
    x.slice('Dendrite', N);

    %% Add presynaptic compartments

    % this compartment will be voltage-clamped so it doesn't need any conductances
    x.add('compartment', 'Presynaptic1', 'Cm', 30, 'Cm', 30, 'radius', 2.42/1e3, 'len', 110/1e3)
    x.add('compartment', 'Presynaptic2', 'Cm', 30, 'Cm', 30, 'radius', 2.42/1e3, 'len', 110/1e3)

    %% Connect presynaptic compartments to postsynaptic compartments

    x.connect('Presynaptic1', ['Dendrite', postsynaptic{1}], 'borgers/NMDAergic', 'gbar', 0, 'Mg', 2, 'tau_d', 2, 'tau_r', 10);
    x.connect('Presynaptic2', ['Dendrite', postsynaptic{2}], 'borgers/NMDAergic', 'gbar', 0, 'Mg', 2, 'tau_d', 2, 'tau_r', 10);
