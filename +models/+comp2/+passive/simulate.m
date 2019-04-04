function [cost, R] = simulation(x, ~, ~)

  % preallocate output variables
  cost        = 0;
  response    = zeros(3,1);

  % useful variables
  nSteps      = x.t_end / x.dt;         % number of time steps
  comps       = x.find('compartment');  % list of all compartments
  epsilon     = 100;                    % microvolts, minimum allowed response
  lambda      = [1, 0, 0];              % weighting of multiplicative, additive, and supralinear costs

  % set up presynaptic waveform pulse
  pulseWidth  = round(3 / x.dt);
  pulseHeight = 30;
  pulseStart  = round(2 / x.dt);
  pulseStop   = pulseStart + pulseWidth;

  %% Perform the three simulations

  R(1)        = simulation_core(x, nSteps, comps, 1, pulseStart, pulseStop, pulseHeight);
  R(2)        = simulation_core(x, nSteps, comps, 2, pulseStart, pulseStop, pulseHeight);
  R(3)        = simulation_core(x, nSteps, comps, 3, pulseStart, pulseStop, pulseHeight);

  cost        = costFunction(R, epsilon, lambda);

end % function

function r = simulation_core(x, nSteps, comps, trial, pulseStart, pulseStop, pulseHeight)
  % reset to steady-state
  x.reset('steadystate');

  % set the voltage clamp in the correct presynaptic compartments
  V_clamp     = NaN(nSteps, length(comps));
  switch trial
  case 1
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic1')) = pulseHeight;
  case 2
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic2')) = pulseHeight;
  case 3
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic1')) = pulseHeight;
    V_clamp(pulseStart:pulseStop, strcmp(comps, 'Presynaptic2')) = pulseHeight;
  end

  keyboard

  % clamp the specified compartments
  x.V_clamp   = V_clamp;
  % perform the simulation
  V           = x.integrate;
  % compute the EPSP amplitude
  r           = responseHeight(V(:, strcmp(comps, 'Dendrite1')));
end % function
