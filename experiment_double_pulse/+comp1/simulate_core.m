function [r, V] = simulation_core(x, comps, trial, pulseStart, pulseStop, pulseHeight)
  
  % Arguments:
  %   x: the xolotl object
  %   comps: a cell array listing the compartment names (e.g. x.find('compartment'))
  %   trial: a scalar integer, 1, 2, or 3
  %   pulseStart: scalar integer in time-steps, when the pulse starts
  %   pulseStop: scalar integer in time-steps, when the pulse stops
  %   pulseHeight: scalar in mV, amplitude of the pulse
  % 
  % Outputs:
  %   r: 1x1 measuring the response amplitude in mV
  %   V: n x 1 recording the membrane potential time series in mV
  %     n = x.t_end / x.dt
  
  
  % reset to steady-state
  x.reset('steady-state');
  % x.t_end     = 100;

  % set the voltage clamp in the correct presynaptic compartments
  V_clamp     = NaN(x.t_end / x.dt, length(comps));

  switch trial
  case 1
    % zap the first compartment
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = -70;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic1')) = pulseHeight;
  case 2
    % zap the second compartment
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = -70;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic2')) = pulseHeight;
  case 3
    % zap both compartments
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = -70;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic1')) = pulseHeight;
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = -70;
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
    V           = V(:, strcmp(comps, 'Dendrite'));
  case 2
    r           = responseHeight(V(:, strcmp(comps, 'Dendrite')));
    V           = V(:, strcmp(comps, 'Dendrite'));
  case 3
    r           = responseHeight(V(:, strcmp(comps, 'Dendrite')));
    V           = V(:, strcmp(comps, 'Dendrite'));
  end

end % function
