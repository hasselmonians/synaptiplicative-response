function I = getCurrent(V_pre, V_post)
  % computes the steady-state current as a function of presynaptic and postsynaptic membrane potential
  % uses equations for the Borgers/Jahr-Stevens NMDA synapse

  [s_inf, tau_r, u] = getGatingFunctions();

  
