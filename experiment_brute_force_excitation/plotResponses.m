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

  for ii = 2:-1:1
    ax(ii) = subplot(2, 1, ii); hold on
  end

  time = x.dt * (1:length(pulse));
  C = colormaps.linspecer(3);

  % plot the three responses
  leg = cell(3,1);
  for ii = 1:3
    plot(ax(1), time, V(:, ii), 'Color', C(ii, :))
    leg{ii} = ['R_' num2str(ii)];
  end

  % plot the waveform pulse
  plot(ax(2), time, pulse, 'k');

  % plot the NMDAergic current trace
  % for ii = 1:2
  %   plot(ax(3), time, Isyn(:, ii), 'Color', C(ii+1, :));
  % end

  % add the axis labels
  ylabel(ax(1), 'responses (mV)')
  ylabel(ax(2), 'pulse (mV)')
  % ylabel(ax(3), 'current (nA)')
  xlabel(ax(2), 'time (ms)')

  % fix axis limits
  ylim(ax(1), [-95, -65])

  % add the legend
  legend(ax(1), leg);

  % make the figure pretty
  figlib.pretty('PlotBuffer', 0.2)
