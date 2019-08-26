%% collectData
% Here we will brute-force the solution space
% by simulating an excitation experiment
% for each synaptic strength in an equidistant grid
% and compute the responses to the three pulse conditions
% The model is specified in |model|,
% and the simulation in |simulate|.

%% Instantiate the model
% The model has 4 parameters, corresponding to the maximal conductances.
% Two of the conductances, the maximal conductances of the NMDAergic synapses
% will be varied.

x = model();

% equidistant grid for synaptic maximal conductances
gmax = 0:0.2:60;

%% Perform the simulation
% If the simulation has already been performed, load it.
% Otherwise, perform the simulation in parallel.

if exist('experiment_brute_force_excitation/responses.mat')
  corelib.verb(true, 'INFO', 'loading responses.mat')
  load('experiment_brute_force_excitation/responses.mat')
else
  corelib.verb(true, 'INFO', 'beginning simulation')

  % invoke a parallel pool using default, local settings
  gcp('nocreate')

  % fetch the parameter names
  param_names = x.find('Dendrite*NMDAergic*gmax');

  % container for parameter values
  [X, Y] = meshgrid(gmax, gmax);
  all_params = [X(:), Y(:)]';
