function [cost, costParts, response, V] = simulate(x, ~, ~)
  
  % function to be passed to the optimizer
  % Arguments:
  %   x: the xolotl object
  %
  % Outputs:
  %   cost: 1x1 containing the result of the objective function
  %   costParts: 4x1 containing four different contributing factors to the cost
  %     costParts(1): cost due to failing to meet a minimum response height
  %     costParts(2): cost due to distance from multiplicative target
  %     costParts(3): cost due to closeness to additive response target
  %     costParts(4): cost due to failure for response to be in a (supralinear range)
  %   response: 3x1 containing the response amplitudes for the three trials
  %   V: n x 3 containing the voltage traces for the three trials

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
  lambda      = [1, 1, 0];              % weighting of multiplicative, additive, and supralinear costs

  % set up presynaptic waveform pulse
  pulseWidth  = round(2 / x.dt);
  pulseHeight = 60;
  pulseStart  = round(2 / x.dt);
  pulseStop   = pulseStart + pulseWidth;

  %% Perform the three simulations

  [response(1), V(:,1)]   = comp1.simulate_core(x, comps, 1, pulseStart, pulseStop, pulseHeight);
  [response(2), V(:,2)]   = comp1.simulate_core(x, comps, 2, pulseStart, pulseStop, pulseHeight);
  [response(3), V(:,3)]   = comp1.simulate_core(x, comps, 3, pulseStart, pulseStop, pulseHeight);

  [cost, costParts] = costFunction(response, epsilon, lambda);

end % function
