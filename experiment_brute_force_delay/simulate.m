function [responses, V, pulse, delay] = simulate(x, delay, V_clamp)
  % this function is used to simulate the voltage response amplitude
  % of two pulses, and then both together, to check for supralinearity

  %% Arguments:
  %   x: the xolotl object generated by model()
  %   delay: the delay in ms between the two pulses in the third response
  %   V_clamp: a 3x1 vector containing the
  %% Outputs:
  %   responses: a 3x1 vector containing the response heights for the three conditions
  %   V: an n x 1 vector containing the membrane potential
  %     for the Dendritic compartment for each trial

  if ~exist('delay', 'var')
    delay = 0;
  end

  if ~exist('V_clamp', 'var')
    V_clamp = [NaN -90 -90];
  end

  % compute the steady-state
  % this has to be done here because the parameters change each time
  x = setSteadyState(x, V_clamp);

  % preallocate output variables
  responses = zeros(3,1);
  V         = zeros(x.t_end / x.dt, 3);
  % Isyn      = zeros(x.t_end / x.dt, 2);

  % useful variables
  comps     = x.find('compartment');

  % set up a presynaptic waveform pulse
  % pulse(:,1) is the first pulse and pulse(:,2) is the delayed pulse
  pulseWidth  = round(2 / x.dt);
  pulseHeight = 60;
  pulseStart  = round(2 / x.dt);
  pulseStop   = pulseStart + pulseWidth;
  pulseDelay  = round(delay / x.dt);
  pulse       = -90 * ones(x.t_end / x.dt, 2);
  pulse(pulseStart:pulseStop, 1) = pulseHeight;
  pulse(pulseStart+pulseDelay:pulseStop+pulseDelay, 2) = pulseHeight;

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
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = pulse(:, 1);
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = -90 * ones(length(pulse), 1);
  case 2
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = -90 * ones(length(pulse), 1);
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = pulse(:, 2);
  case 3
    V_clamp(:, strcmp(comps, 'Presynaptic1')) = pulse(:,1);
    V_clamp(:, strcmp(comps, 'Presynaptic2')) = pulse(:,2);
  end

  % clamp the specified compartments
  x.V_clamp = V_clamp;

  % perform the simulation
  [V, ~, ~, ~, Isyn_raw] = x.integrate;

  % compute the EPSP amplitude
  V = V(:, strcmp(comps, 'Dendrite'));
  response = responseHeight(V);

  % organize the current trace
  % indices 3 and 6 represent the actual current in nanoamps
  % Isyn = Isyn_raw(:, [3, 6]);

end % function
