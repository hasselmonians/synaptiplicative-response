% parameter optimization script for 2-compartment passive models
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

x           = comp2.passive.model();
x.t_end     = 100; % ms, only need to record one EPSP

p           = xfit('particleswarm');
p.x         = x;
p.sim_func  = @comp2.simulate;

% parameters
p.parameter_names = [x.find('*gbar'); x.find('*NMDAergic*gmax')];
p.lb        = zeros(1, length(p.parameter_names));
p.ub        = 1000 * ones(1, length(p.parameter_names)); % uS/mm^2

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

filename    = ['data-comp2-passive-' corelib.getComputerName '.mat'];

if exist(filename)
  load(filename)
  start_idx = find(isnan(cost),1,'first')
else
  start_idx = 1;
end

for ii = start_idx:nSims

  try

    % set seed
    p.seed = p.ub .* rand(size(p.ub));

    % run xfit
    for qq = 1:nEpochs
      p.fit;
    end

    % save
    params(ii, :)  = p.seed;
    [cost(ii), costParts(ii, :), response(ii, :)] = p.sim_func(x);
    save(filename, 'cost', 'params', 'costParts', 'responses');
    disp(['saved simulation ' num2str(ii)])

  catch

    disp('Something went wrong.')

  end

end
