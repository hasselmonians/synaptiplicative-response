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

x           = models.comp2.passive.model();
p           = xfit('particleswarm');

p.sim_func  = @models.comp2.passive.simulation;

% parameters
p.parameter_names = [x.find('*gbar'); x.find('*NMDAergic*gmax')];
p.lb        = [0, 0, 0, 0];
p.ub        = [1, 1, 1, 1];

% set procrustes options
p.options.MaxTime   = 900;
p.options.SwarmSize = 24;

%% Compute the steady-state

x.t_end     = 5e3;
x.integrate;
x.snapshot('steady-state');

%% Initialize outputs

nSims       = 100;
nEpochs     = 3;
nParams     = length(p.parameter_names);
params      = NaN(nParams, nSims);
cost        = NaN(1, nSims);

%% Fit parameters

filename    = ['data-comp2-passive-' corelib.getComputerName '.mat']

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
    params(:,ii)  = p.seed;
    cost(ii)      = p.sim_func(x);
    save(filename, 'cost', 'params');
    disp(['saved simulation ' num2str(ii)])

  catch

    disp('Something went wrong.')

  end

end
