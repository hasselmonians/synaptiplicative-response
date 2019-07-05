%% Plot some responses as functions of the delay term
% delay is introduced during the third trial
% when both presynaptic cells are stimulated
% the first cell is stimulated at t = pulseStart
% and the second at t = pulseStart + pulseDelay

% Arguments:
%   x: a xolotl object with three compartments that satisfies simulate()
% Outputs:
%   produces a ton of plots, but no actual outputs

function plotDelay(x)

  % create a vector of delays to test (in ms)
  delay = logspace(0, log10(300), 11);

  %% Perform the main loop
  % plot the responses vs. time traces
  % and the pulses

  % output vectors
  responses = zeros(length(delay), 1);

  for ii = 1:length(delay)
    % compute the response and pulse
    [rr, V, pulse] = simulate(x, delay(ii));
    responses(ii) = rr(3);
    % plot the response vs. time traces
    plotResponses(x, delay(ii), V, pulse);
  end

  %% Plot the response height as a function of delay
  f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on

  for ii = 2:-1:1
    ax(ii) = subplot(1, 2, ii);
  end

  semilogy(ax(1), delay, responses, 'ok');
  loglog(ax(2), delay, responses, 'ok');

  xlabel(ax(1), 'delay (ms)')
  xlabel(ax(2), 'log delay')
  ylabel(ax(1), 'response height (mV)')
  title('response height as function of delay')

  figlib.pretty('PlotBuffer', 0.2);

end % function
