%% collectData
% Here, we will brute force the solution space by simulating the double pulse experiment
% for each synaptic strength in an equidistant grid,
% and compute the responses to the first, second, and double pulses.
% The model is specified in |model| and the simulation procedure in |simulate|

%% Instantiate the model
% The model has 4 parameters, corresponding to the four maximal condutances.
% Two of the conductances, the maximal condutances of the NMDAergic synapses will be varied.

if exist('experiment_brute_force/responses.mat')
  corelib.verb(true, 'INFO', 'loading responses.mat')
else
  corelib.verb(true, 'INFO', 'beginning simulations')
  parpool;

  % set up an xgrid object
  p = xgrid();
  p.x = model();
  p.cleanup;

  % equidistant grid for synaptic maximal conductances
  gmax = 0:0.1:60;

  % parameter names
  param_names = x.find('Dendrite*NMDAergic*gmax');

  % container for parameter values
  all_params = NaN(2, length(gmax) * length(gmax));
  c = 1;

  for ii = 1:length(gmax)
    for qq = 1:length(gmax)
      all_params(1, c) = gmax(ii);
      all_params(2, c) = gmax(qq);
      c = c + 1;
    end
  end

  % set up the xgrid object parameter matrix
  p.batchify(all_params, param_names);

  % set up the function to run
  p.sim_func = @simulate;

  % perform the simulation
  p.simulate;
  wait(p.workers);

  % gather the data into an unsorted matrix
  [all_data, all_params, all_params_idx] = p.gather;
  responses_unsorted = all_data{1};

  save('responses_raw.mat', 'all_data', 'all_params', 'all_params_idx');

end

return

  % sort the responses to create a
  responses = zeros(length(gmax), length(gmax), 3);
  for ii = 1:length(all_params)
    xx = find(all_params(1, ii) == gmax);
    yy = find(all_params(2, ii) == gmax);
    responses(xx, yy) = responses_unsorted(ii);
  end

x.set(param_names, param_values);
responses(ii, qq, :) = simulate(x);
%% Responses as a function of synaptic weights

figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
imagesc(gmax, gmax, responses(:, :, 3));
xlabel('g_{max} (\mu S)')
ylabel('g_{max} (\mu S)')
title('responses')
c = colorbar;
c.Label.String = 'Response height (mV)';

figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
imagesc(gmax, gmax, responses(:, :, 3) - responses(:, :, 1) .* responses(:, :, 2));
xlabel('g_{max} (\mu S)')
ylabel('g_{max} (\mu S)')
title('multiplicative difference')
c = colorbar;
c.Label.String = 'Response height (mV)';

figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
imagesc(gmax, gmax, responses(:, :, 3) - responses(:, :, 1) - responses(:, :, 2));
xlabel('g_{max} (\mu S)')
ylabel('g_{max} (\mu S)')
title('additive difference')
c = colorbar;
c.Label.String = 'Response height (mV)';

save('responses.mat', 'responses', 'param_names', 'param_values', 'x', 'gmax');
