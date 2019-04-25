function [cost, costParts, R] = simulate(x, ~, ~)

  %% Preamble

  % compute the steady-state
  % this has to be done here because the parameters change
  x.t_end = 5e3;
  x.V_clamp = [NaN, -60, -60];
  V = x.integrate;
  x.t_end = 100;
  x.snapshot('steady-state');

  % preallocate output variables
  cost        = 0;
  response    = zeros(3,1);

  % useful variables
  comps       = x.find('compartment');  % list of all compartments
  epsilon     = 0.01;                   % mV, minimum allowed response
  lambda      = [1, 0, 0];              % weighting of multiplicative, additive, and supralinear costs

  % set up presynaptic waveform pulse
  pulseWidth  = round(2 / x.dt);
  pulseHeight = 60;
  pulseStart  = round(2 / x.dt);
  pulseStop   = pulseStart + pulseWidth;

  %% Perform the three simulations

  R(1)        = simulation_core(x, comps, 1, pulseStart, pulseStop, pulseHeight);
  R(2)        = simulation_core(x, comps, 2, pulseStart, pulseStop, pulseHeight);
  R(3)        = simulation_core(x, comps, 3, pulseStart, pulseStop, pulseHeight);

  [cost, costParts] = costFunction(R, epsilon, lambda);

end % function

function r = simulation_core(x, comps, trial, pulseStart, pulseStop, pulseHeight)
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
