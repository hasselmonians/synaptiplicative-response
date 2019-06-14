function [responses, V, pulse] = simulate(x)
  % this function is used to simulate the voltage response amplitude
  % of two pulses, and then both together, to check for supralinearity

  %% Arguments:
  %   x: the xolotl object generated by model()
  %% Outputs:
  %   responses: a 3x1 vector containing the response heights for the three conditions
  %   V: an n x 1 vector containing the membrane potential
  %     for the Dendritic compartment for each trial

  % compute the steady-state
  % this has to be done here because the parameters change each time
  x = setSteadyState(x);

  % preallocate output variables
  responses = zeros(3,1);
  V         = zeros(x.t_end / x.dt, 3);

  % useful variables
  comps     = x.find('compartment');

  % set up a presynaptic waveform pulse
  pulseWidth  = round(2 / x.dt);
  pulseHeight = 60;
  pulseStart  = round(2 / x.dt);
  pulseStop   = pulseStart + pulseWidth;
  pulse       = -70 * ones(x.t_end / x.dt, 1);
  pulse(pulseStart:pulseStop, 1) = pulseHeight;

  % perform the three simulations
  [responses(1), V(:, 1)]  = simulate_core(x, comps, 1, pulse);
  [responses(2), V(:, 2)]  = simulate_core(x, comps, 2, pulse);
  [responses(3), V(:, 3)]  = simulate_core(x, comps, 3, pulse);

end % function

function [response, V] = simulate_core(x, comps, index, pulse)
  % reset to steady-state
  x.reset('steady-state');

  % set the voltage clamp in the correct presynaptic compartments
  V_clamp = NaN(x.t_end / x.dt, length(comps));

  switch index
  case 1
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = pulse;
  case 2
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = pulse;
  case 3
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = pulse;
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = pulse;
  end

  % clamp the specified compartments
  x.V_clamp = V_clamp;

  % perform the simulation
  V = x.integrate;

  % compute the EPSP amplitude
  V = V(:, strcmp(comps, 'Dendrite'));
  response = responseHeight(V);

end % function
