function x = model()

  x = xolotl;

  %% Instantiate compartments and conductances

  x.add('compartment', 'Dendrite', 'Cm', 30, 'radius', 4e-3, 'len', 110e-3);

  % add only a leak current
  x.Dendrite.add('Leak', 'gbar', 0.1, 'E', -70);

  %% Add presynaptic compartments

  x.add('compartment', 'Presynaptic1', 'Cm', 30, 'radius', 4e-3, 'len', 110e-3);
  x.add('compartment', 'Presynaptic2', 'Cm', 30, 'radius', 4e-3, 'len', 110e-3);

  % add only a leak current
  x.Presynaptic1.add('Leak', 'gbar', 0.1, 'E', -70);
  x.Presynaptic2.add('Leak', 'gbar', 0.1, 'E', -70);

  %% Connect presynaptic compartments to postsynaptic compartments

  x.connect('Presynaptic1', 'Dendrite', 'borgers/AMPAergic', 'gmax', 0, 'tau_d', 2, 'tau_r', 2, 'E', 0);
  x.connect('Presynaptic2', 'Dendrite', 'borgers/NMDAergic', 'gmax', 0, 'Mg', 2, 'tau_d', 30, 'tau_r', 2, 'E', 0);

end
