function [r, V] = simulation_core(x, comps, trial, pulseStart, pulseStop, pulseHeight)
  % reset to steady-state
  x.reset('steady-state');
  % x.t_end     = 100;

  % set the voltage clamp in the correct presynaptic compartments
  V_clamp     = NaN(x.t_end / x.dt, length(comps));

  switch trial
  case 1
    % zap the first compartment
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = -60;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic1')) = pulseHeight;
  case 2
    % zap the second compartment
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = -60;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic2')) = pulseHeight;
  case 3
    % zap both compartments
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = -60;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic1')) = pulseHeight;
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = -60;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic2')) = pulseHeight;
  end

  % clamp the specified compartments
  x.V_clamp   = V_clamp;
  % perform the simulation
  V           = x.integrate;
  % compute the EPSP amplitude
  switch trial
  case 1
    r           = responseHeight(V(:, strcmp(comps, 'Dendrite')));
  case 2
    r           = responseHeight(V(:, strcmp(comps, 'Dendrite')));
  case 3
    r           = responseHeight(V(:, strcmp(comps, 'Dendrite')));
  end

end % function
