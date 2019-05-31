function [cost, costParts, response, V] = simulate(x, ~, ~)

  %% Preamble
  % compute the steady-state
  % this has to be done here because the parameters change
  x = setSteadyState(x);

  % preallocate output variables
  cost      = 0;
  response  = zeros(3, 1);
  V         = zeros(x.t_end / x.dt, 3);

  % useful variables
  comps     = x.find('compartment');
  epsilon   = 0.01;
  lambda    = [1, 1, 0];

  % set up a presynaptic AMPAergic waveform pulse
  pulseWidth_AMPA   = round(90 / x.dt); % time steps
  pulseHeight_AMPA  = 60; % mV
  pulseStart_AMPA   = round(2 / x.dt); % time steps
  pulseStop_AMPA    = pulseStart_AMPA + pulseWidth_AMPA; % time steps
  pulse_AMPA        = -90 * ones(length(V), 1);
  pulse_AMPA(pulseStart_AMPA:pulseStop_AMPA) = pulseHeight_AMPA;

  % set up presynaptic NMDAergic waveform pulse
  pulseWidth_NMDA   = round(2 / x.dt);
  pulseHeight_NMDA  = 60;
  pulseStart_NMDA   = round(60 / x.dt);
  pulseStop_NMDA    = pulseStart_NMDA + pulseWidth_NMDA;
  pulse_NMDA        = -90 * ones(length(V), 1);
  pulse_NMDA(pulseStart_NMDA:pulseStop_NMDA) = pulseHeight_NMDA;

  [response(1), V(:,1)]   = comp1.simulate_core(x, comps, 1, pulse_AMPA, pulse_NMDA);
  [response(2), V(:,2)]   = comp1.simulate_core(x, comps, 2, pulse_AMPA, pulse_NMDA);
  [response(3), V(:,3)]   = comp1.simulate_core(x, comps, 3, pulse_AMPA, pulse_NMDA);

  [cost, costParts] = costFunction(response, epsilon, lambda);

end % function
