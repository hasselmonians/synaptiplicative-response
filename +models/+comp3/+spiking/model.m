function x = model()

  x = xolotl;
  N = 2;

  %% Instantiate compartments and conductances

  x.add('compartment', 'Dendrite', 'Cm', 30, 'radius', 4e-3, 'len', N * 110e-3);

  % add only a leak current
  x.Dendrite.add('Leak', 'gbar', 0.1, 'E', -50);

  % slice the compartment
  x.slice('Dendrite', N);

  %% Add presynaptic compartments

  x.add('compartment', 'Presynaptic1', 'Cm', 30, 'radius', 4e-3, 'len', 110e-3);
  x.add('compartment', 'Presynaptic2', 'Cm', 30, 'radius', 4e-3, 'len', 110e-3);

  %% Connect presynaptic compartments to postsynaptic compartments

  x.connect('Presynaptic1', 'Dendrite1', 'borgers/NMDAergic', 'gmax', 0, 'Mg', 2, 'tau_d', 2, 'tau_r', 10);
  x.connect('Presynaptic2', 'Dendrite2', 'borgers/NMDAergic', 'gmax', 0, 'Mg', 2, 'tau_d', 2, 'tau_r', 10);

  %% Bookkeeping

  % determine the steady-state
  x.t_end = 10e3;
  x.integrate;
  x.t_end = 100; % only need a short time to measure EPSP
  x.snapshot('steadystate');

end
