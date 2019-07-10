function plotResponses(x, delay, V, pulse)

  % plots the responses to the three pulse conditions
  % as response traces vs. time

  % Arguments:
  %   x: xolotl object that is already set up
  %     expects one ready to go into the simulate function
  %   delay: the delay between the two pulses in ms
  %   V: the n x 3 membrane potential matrix
  %   pulse: the n x 2 voltage pulse matrix

  % If V and pulse are given, don't perform additional computation
  if nargin > 2
    % assume that V and the pulse are given
    % don't perform any additional computation
  else
    % perform the computation and save the three responses and the pulse waveform
    [~, V, pulse] = simulate(x, delay);
  end

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
    leg{ii} = ['V_' num2str(ii)];
    title(['delay = ' num2str(delay) ' ms'])
  end

  % plot the waveform pulse
  plot(ax(2), time, pulse(:,1), 'k');
  plot(ax(2), time, pulse(:,2), 'r');

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
  lower_bound = min(x.get('*E')) - 5;
  upper_bound = lower_bound + 20;
  ylim(ax(1), [lower_bound, upper_bound])

  % add the legend
  legend(ax(1), leg);

  % make the figure pretty
  figlib.pretty('PlotBuffer', 0.2)
