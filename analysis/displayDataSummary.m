function [dataTable, param_names, x, total_models] = displayDataSummary(keywords, cutoff, being_published)
  % loads the data into a data table
  % displays summary statistics
  % plots responses in a line plot
  % finds an exemplar model
  % plots the response
  %
  % [dataTable, param_names, x, total_models] = displayDataSummary('comp1-passive', 1e4, false)
  %
  % Arguments:
  %   keywords: an n x 1 or 1 x n cell array, or a character vector
  %     tells which data should be used, such as {'comp1-passive'}
  %     the '-' is important! Keywords should always have two parts separated by a '-'
  %     runs iteratively and appends, if n > 1
  %     if the keyword is just a character vector, the function is run once
  %   cutoff: a 1x1 positive, real number
  %     models with costs less than the cutoff will be excluded
  %   being_published: a 1x1 logical
  %     if being_published, snap and delete figures
  % Outputs:
  %   dataTable: a table containing the cost, costParts, parameters, and responses
  %   param_names: a cell array of the names of the xolotl parameters optimized over
  %   x: the xolotl object with default parameters
  %   total_models: the original total number of models in the data set
  %     before being pared down by the cutoff

  if nargin < 2
    cutoff = 1e4;
  end

  if nargin < 3
    being_published = false;
  end

  if ischar(keywords)
    keywords = {keywords};
  end

  for ii = 1:length(keywords)
    displayDataSummary_core(keywords{ii}, cutoff, being_published);
  end

end % function

function displayDataSummary_core(keyword, cutoff, being_published)

  % load the data and grab the parameter names
  % data should be in /**/synaptiplicative-response/data/
  % and named 'data-keyword*.mat'

  [dataTable, param_names, ~, total_models] = processData(keyword, cutoff);

  % display summary statistics
  disp([ 'Models passing: ' num2str(height(dataTable)) '/' num2str(total_models) ])
  disp('Parameter Names:')
  disp(param_names)
  summary(dataTable)

  % plot all responses in a line plot
  figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
  plot(dataTable.responses', '-ko', 'MarkerFaceColor', 'k')
  xticks([1 2 3])
  xticklabels({'R_1', 'R_2', 'R_{1,2}'})
  xlabel('response conditions')
  ylabel('response magnitude (mV)')
  xlim([0 4])
  ylim([0, 1.1*max(dataTable.responses(:))])
  title([keyword ' responses'])

  figlib.pretty();
  figlib.tight();

  if being_published
    pdflib.snap
    delete(gcf)
  end

  % find exemplar
  keys = split(keyword, '-');
  [~, idx] = min(dataTable.cost);
  x = eval([keys{1} '.' keys{2} '.model()']);
  comps = x.find('compartment');
  x.set(param_names, dataTable.params(idx, :));

  % compute the membrane potential for the three conditions
  [~, ~, ~, V] = eval([keys{1} '.simulate(x)']);

  % set up presynaptic waveform pulse
  time = (1:length(V))*x.dt;
  pulseWidth  = round(2 / x.dt);
  pulseHeight = 60;
  pulseStart  = round(2 / x.dt);
  pulseStop   = pulseStart + pulseWidth;
  waveform = -70 * ones(length(time), 1);
  waveform(pulseStart:pulseStop, 1) = pulseHeight;

  % plot exemplar responses as a function of time
  figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
  ylabels = {'R_1 (mV)', 'R_2 (mV)', 'R_{1,2} (mV)'};
  % minlim = min(V(:)) - 0.01*abs(min(V(:)));
  % maxlim = max(V(:)) + 0.01*abs(max(V(:)));
  for ii = 4:-1:1
    ax(ii) = subplot(4, 1, ii);
  end
  for ii = 1:3
    plot(ax(ii), time, V(:,ii), 'k');
    ylabel(ax(ii), ylabels{ii})
    % ylim(ax(ii), [minlim maxlim])
  end
  plot(ax(4), time, waveform, 'k');
  xlabel(ax(4), 'time (ms)')
  ylabel(ax(4), 'clamp (mV)')
  linkaxes(ax(1:3), 'y')

  figlib.pretty();
  figlib.tight();

  if being_published
    pdflib.snap
    delete(gcf)
  end

end % function
