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
  x = model();

  % equidistant grid for synaptic maximal conductances
  gmax = 0:0.1:30;

  % responses stored in a gmax x gmax x 3 array
  responses = zeros(length(gmax), length(gmax), 3);

  % parameter names
  param_names = x.find('Dendrite*NMDAergic*gmax');

  % container for parameter values
  param_values = zeros(2, 1);

  for ii = 1:length(gmax)
    corelib.textbar(ii, length(gmax))
    for qq = 1:length(gmax)
      param_values = [gmax(ii); gmax(qq)];
      x.set(param_names, param_values);
      responses(ii, qq, :) = simulate(x);
    end
  end
end

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
