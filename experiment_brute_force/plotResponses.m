function plotResponses(x)

  % plots the responses to the three pulse conditions
  % as response traces vs. time

  % Arguments:
  %   x: xolotl object that is already set up
  %     expects one ready to go into the simulate function

  % perform the computation and save the three responses and the pulse waveform
  [~, V, pulse] = simulate(x);

  %% Generate the figure to plot on

  % don't bother generating multiple plots on one figure
  f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on

  for ii = 4:-1:1
    ax(ii) = subplot(4, 1, ii);
  end

  time = x.dt * (1:length(pulse));

  % plot the three responses
  VV = corelib.vectorise(V);
  a = min(VV) - 0.1 * abs(max(VV) - min(VV));
  b = max(VV) + 0.1 * abs(max(VV) - min(VV));
  for ii = 1:3
    plot(ax(ii), time, V(:, ii), 'k')
    ylabel(ax(ii), ['R_' num2str(ii) ' (mV)'])
    ylim(ax(ii), [a b]);
  end

  % plot the waveform pulse
  plot(ax(4), time, pulse, 'k');
  ylabel(ax(4), 'pulse (mV)')

  % add the axis labels
  xlabel(ax(4), 'time (ms)')

  % make the figure pretty
  figlib.pretty()

  % link the axes for the first three plots
  linkaxes(ax(1:3), 'xy')
