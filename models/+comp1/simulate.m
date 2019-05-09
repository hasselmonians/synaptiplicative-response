function [cost, costParts, R, V] = simulate(x, ~, ~)

  %% Preamble

  % compute the steady-state
  % this has to be done here because the parameters change
  x = setSteadyState(x);

  % preallocate output variables
  cost        = 0;
  response    = zeros(3,1);
  V           = zeros(x.t_end / x.dt, 3);

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

  [R(1), V(:,1)]   = comp1.simulate_core(x, comps, 1, pulseStart, pulseStop, pulseHeight);
  [R(2), V(:,2)]   = comp1.simulate_core(x, comps, 2, pulseStart, pulseStop, pulseHeight);
  [R(3), V(:,3)]   = comp1.simulate_core(x, comps, 3, pulseStart, pulseStop, pulseHeight);

  [cost, costParts] = costFunction(R, epsilon, lambda);

end % function
