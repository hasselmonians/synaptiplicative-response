function c = cost(x)
    % cost function to be evaluated by xfit
    % the goal is to find parameters which result in a multiplicative response

    nSteps      = x.t_end / x.dt;
    nComps      = length(x.find('compartment'));

    % convenience function
    findComp    = @(name) strcmp(x.find('compartment'), name);

    %% Set up presynaptic waveform

    pulseWidth  = 2 / x.dt;     % time steps
    pulseHeight = 30;           % mV
    pulseStart  = round(0.5 * nSteps);
    pulseStop   = pulseStart + pulseWidth;

    %% Pulse from the first synapse

    V_clamp     = NaN(nSteps, nComps);
    V_clamp(pulseStart:pulseStop, findComp('Presynaptic1');
    x.V_clamp   = V_clamp;
    V1          = x.integrate;

    %% Pulse from the second synapse

    V_clamp     = NaN(nSteps, nComps);
    V_clamp(pulseStart:pulseStop, findComp('Presynaptic2');
    x.V_clamp   = V_clamp;
    V2 = x.integrate;

    %% Pulse from both synapses

    V_clamp     = NaN(nSteps, nComps);
    V_clamp(pulseStart:pulseStop, findComp('Presynaptic1');
    V_clamp(pulseStart:pulseStop, findComp('Presynaptic2');
    V12         = x.integrate;

    %% Evalulate the responses

    R1          = responseHeight(V1, V1(pulseStart-2, strcmp(x.find('compartment', 'Dendrite2'))));
    R2          = responseHeight(V2, V2(pulseStart-2, strcmp(x.find('compartment', 'Dendrite3'))));
    % R12         = responseHeight(V2, V2(pulseStart-2, strcmp(x.find('compartment', 'Dendrite3'))));

    c = (R12 - R1*R2)^2;

end % function
