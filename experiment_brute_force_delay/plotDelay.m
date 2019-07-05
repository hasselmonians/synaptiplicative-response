%% Plot some responses as functions of the delay term
% delay is introduced during the third trial
% when both presynaptic cells are stimulated
% the first cell is stimulated at t = pulseStart
% and the second at t = pulseStart + pulseDelay

% Arguments:
%   x: a xolotl object with three compartments that satisfies simulate()
%   skip_missing: a logical flag, defaults to false
%     if skip_missing == true, the response traces will not be plotted
% Outputs:
%   f: a figure of the response height as a function of delay

function f = plotDelay(x, skip_responses)

  if nargin < 2
    skip_responses = false;
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
    if skip_responses == false
      % plot the response vs. time traces
      plotResponses(x, delay(ii), V, pulse);
    end
  end

  %% Plot the response height as a function of delay
  f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on

  plot(delay, responses / responses(1), 'ok')

  xlabel('delay (ms)')
  ylabel('response height (mV)')
  title('response height as function of delay')

  figlib.pretty('PlotBuffer', 0.2);

end % function
