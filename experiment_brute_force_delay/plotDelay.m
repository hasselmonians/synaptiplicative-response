%% Plot some responses as functions of the delay term
% delay is introduced during the third trial
% when both presynaptic cells are stimulated
% the first cell is stimulated at t = pulseStart
% and the second at t = pulseStart + pulseDelay

% Arguments:
%   x: a xolotl object with three compartments that satisfies simulate()
%   do_not_plot: a logical flag, defaults to false
%     if do_not_plot == true, no figures will be plotted
% Outputs:
%   f: a figure of the response height as a function of delay

function f = plotDelay(x, do_not_plot)

  if nargin < 2
    do_not_plot = false;
  end

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
    % extract the maximum of the EPSP
    responses(ii) = rr(3);
    if do_not_plot == false
      % plot the response vs. time traces
      plotResponses(x, delay(ii), V, pulse);
    end
  end

  if do_not_plot = true
    return
  end

  %% Plot the response height as a function of delay
  f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on

  plot(delay, responses / responses(1), 'ok')

  xlabel('delay (ms)')
  ylabel('response height (mV)')
  title('response height as function of delay')

  figlib.pretty('PlotBuffer', 0.2);

end % function
