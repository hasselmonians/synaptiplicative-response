% parameter optimization script for 1-compartment spiking models
% with no extra special conditions.

% ## Experimental protocol
%
% * Reach steady-state.
% * Zap presynaptic compartment #1.
% * Observe EPSPs in postsynaptic compartment #1.
% * Return to steady-state.
% * Zap presynaptic compartment #2
% * Observe EPSPs in postsynaptic compartment #1.
% * Return to steady-state.
% * Zap presynaptic compartments #1 & #2
% * Observe EPSPs in postsynaptic compartment #1.
%
% Optimize for the condition where EPSP #1 + EPSP #2 != EPSP #1 & EPSP #2.
% That is, that there is a nonlinear "multiplicative" response.

%% Set up xolotl and xfit

x           = comp1.spiking.model();
x.t_end     = 100; % ms, only need to record one EPSP

p           = xfit('particleswarm');
p.x         = x;
p.sim_func  = @comp1.simulate;

% parameters
param_names = [x.find('Dendrite*gbar'); x.find('Dendrite*NMDAergic*gmax')];
p.parameter_names = param_names;
return
p.lb        = zeros(1, length(p.parameter_names));
p.ub        = [100 30 100 30 30]; % uS/mm^2

% set procrustes options
p.options.MaxTime   = 900;
p.options.SwarmSize = 24;

%% Initialize outputs

nSims       = 100;
nEpochs     = 3;
nParams     = length(p.parameter_names);
params      = NaN(nSims, nParams);
cost        = NaN(nSims, 1);
costParts   = NaN(nSims, 4);
responses   = NaN(nSims, 3);

%% Fit parameters

filename    = ['data-comp1-spiking-' corelib.getComputerName '.mat'];

if exist(filename)
  load(filename)
  start_idx = find(isnan(cost),1,'first')
else
  start_idx = 1;
end

for ii = start_idx:nSims

  try

    % set seed
    p.seed = p.ub - 0.5 * p.ub .* rand(size(p.ub)); % start with high parameters > 0.5 * p.ub

    % run xfit
    for qq = 1:nEpochs
      p.fit;
    end

    % save
    params(ii, :)  = p.seed;
    [cost(ii), costParts(ii, :), responses(ii, :)] = p.sim_func(x);
    save(filename, 'cost', 'params', 'costParts', 'responses', 'param_names');
    disp(['saved simulation ' num2str(ii)])

  catch

    disp('Something went wrong.')

  end

end
