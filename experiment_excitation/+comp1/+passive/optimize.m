%% Set up xolotl and xfit

x = comp1.passive.model();
x.t_end = 100; % ms

p = xfit('particleswarm');
p.x = x;
p.sim_func = @comp1.simulate;

% parameters
param_names = [x.find('Dendrite*gbar'); x.find('Dendrite*gmax')];
p.parameter_names = param_names;
p.lb = zeros(1, length(p.parameter_names));
p.ub = 30 * ones(1, length(p.parameter_names));

% set procrustes options
p.options.MaxTime = 900;
p.options.SwarmSize = 24;

%% Initialize outputs

nSims     = 1000;
nEpochs   = 3;
nParams   = length(p.parameter_names);
params    = NaN(nSims, nParams);
cost      = NaN(nSims, 1);
costParts = NaN(nSims, 4);
responses = NaN(nSims, 3);

%% Fit parameters

filename = ['data-comp1-passive-excitation-' corelib.getComputerName '.mat'];

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
