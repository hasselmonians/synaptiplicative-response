function V = experiment(x)
  % perform the synaptic pulse experiment
  x = setSteadyState(x);

  % set up presynaptic waveform pulse
  pulseWidth  = round(2 / x.dt);
  pulseHeight = 50;
  pulseStart  = round(2 / x.dt);
  pulseStop   = pulseStart + pulseWidth;

  % output variable
  V = NaN(x.t_end / x.dt, 3);
  time = (1:length(V))*x.dt;
  waveform = -60 * ones(x.t_end / x.dt, 1);
  waveform(pulseStart:pulseStop, 1) = pulseHeight;

  % set the voltage clamp in the correct presynaptic compartments
  for ii = [1 2 3]
    x.reset('steady-state');
    V_clamp = NaN(x.t_end / x.dt, length(comps));

    if ii == 1
      % zap the first compartment
      V_clamp(:, strcmp(comps, 'Presynaptic1')) = waveform;
    elseif ii == 2
      % zap the second compartment
      V_clamp(:, strcmp(comps, 'Presynaptic2')) = waveform;
    else
      % zap both compartments
      V_clamp(:, strcmp(comps, 'Presynaptic1')) = waveform;
      V_clamp(:, strcmp(comps, 'Presynaptic2')) = waveform;
    end

    % clamp the specified compartments
    x.V_clamp = V_clamp;
    % perform the simulation
    Vtemp = x.integrate;
    % store the correct voltage
    V(:, ii) = Vtemp(:, strcmp(comps, 'Dendrite'));

  end
