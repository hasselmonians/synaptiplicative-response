%% Load the data

% we expect all_data, all_params, gmax, param_names, and x to be contained within
load('responses.mat')

% if not, load some defaults

if ~exist('param_names', 'var')
  param_names = x.find('Dendrite*NMDAergic*gmax');
end

if ~exist('x', 'var')
  x = model();
else
  x.rebase();
end

%% Gather the responses
% either loaded from a file, or generated by xgrid

% sort the responses to create a tensor of responses
responses = zeros(length(gmax), length(gmax), 3);
responses_unsorted = all_data{1};
for ii = 1:length(all_params)
  xx = find(all_params(1, ii) == gmax);
  yy = find(all_params(2, ii) == gmax);
  responses(xx, yy, :) = responses_unsorted(:, ii);
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

figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
imagesc(gmax, gmax, responses(:, :, 3) ./ (responses(:, : ,1) + responses(:, : ,2)));
xlabel('g_{max} (\mu S)')
ylabel('g_{max} (\mu S)')
title('nonlinearity factor')
c = colorbar;
c.Label.String = 'Response height (mV)';

%% Plot selected time series

params = [28 5; 28 15; 28 28; 40 40; 50 50; 60 60];

for ii = 1:size(params, 1)
  x.set(param_names, params(ii, :))
  plotResponses(x);
  % add a title based on the model parameters
  title([mat2str(params(ii, :))])
end
