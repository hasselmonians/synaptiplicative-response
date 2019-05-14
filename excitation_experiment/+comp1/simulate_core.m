function [r, V] = simulation_core(x, comps, trial, pulse_AMPA, pulse_NMDA)
  
  % save indices for later
  index = zeros(2, 1);
  index(1) = strcmp(comps, 'Presynaptic1');
  index(2) = strcmp(comps, 'Presynaptic2');
  index(3) = strcmp(comps, 'Dendrite');
  
  % reset to steady-state
  x.reset('steady-state');
  
  % set the voltage clamp in the correct presynaptic compartment
  V_clamp       = NaN(x.t_end / x.dt, length(comps));
  
  
  switch trial
  case 1
    % zap the first compartment (AMPAergic)
    V_clamp(:, index(1)) = pulse_AMPA;
  case 2
    % zap the second compartment (NMDAergic)
    V_clamp(:, index(2)) = pulse_NMDA;
  case 3
    % zap both compartments
    V_clamp(:, index(1)) = pulse_AMPA;
    V_clamp(:, index(2)) = pulse_NMDA;
  end
  
  % clamp the specified compartments
  x.V_clamp     = V_clamp;
  % perform the simulation
  V             = x.integrate;
  % compute the EPSP amplitude
  V             = V(:, index(3));
  r             = responseHeight(V);
  
end % function
