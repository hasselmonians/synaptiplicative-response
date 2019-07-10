%% Plot some responses as functions of the delay term
% delay is introduced during the third trial
% when both presynaptic cells are stimulated
% the first cell is stimulated at t = pulseStart
% and the second at t = pulseStart + pulseDelay

% Arguments:
%   x: a xolotl object with three compartments that satisfies simulate()
%   threshold: a numerical scalar
%   delays: the vector of delays to be tested, defaults to an 11x1 log-spaced vector on [0, 300] ms
%   do_not_plot: a logical flag, defaults to false
%     if do_not_plot == true, no figures will be plotted
% Outputs:
%   responses: maxima of the 3rd EPSP (the combined condition) as a function of delay
%   delays: the vector of delays tested
%   crossings: time when EPSP waveform crosses threshold (in ms)
%   pulseDelays: n x 2 matrix where n is the length of delays
%     first column is the delay caused by presynaptic pulse #1
%     second column is the delay caused by presynaptic pulse #2

function [responses, delays, crossings, pulseDelays] = plotDelay(x, threshold, delays, do_not_plot)

  if nargin < 2
    do_not_plot = false;
  end

  % create a vector of delays to test (in ms)
  if ~exist('delays', 'var')
    delays = logspace(0, log10(300), 11);
  end

  %% Perform the main loop
  % plot the responses vs. time traces
  % and the pulses

  % output vectors
  responses   = zeros(length(delays), 1);
  crossings   = zeros(length(delays), 1);
  pulseDelays = zeros(length(delays), 2);

  for ii = 1:length(delays)
    % compute the response and pulse
    [rr, V, pulse] = simulate(x, delays(ii));

    % extract the maximum of the EPSP
    responses(ii) = rr(3); % mV

    % extract the crossing without accounting for delays from the presynaptic pulses
    crossings(ii) = veclib.thresholdCrossings(V(:, 3), threshold, 1); % time-steps

    % extract the delays from the pulse waveform
    pulseDelays(ii, 1) = find(diff(pulse(:, 1)) ~= 0, 1, 'last') + 1;
    pulseDelays(ii, 2) = find(diff(pulse(:, 2)) ~= 0, 1, 'last') + 1;

    if do_not_plot == false
      % plot the response vs. time traces
      plotResponses(x, delays(ii), V, pulse);
    end % do_not_plot
  end % ii

  if do_not_plot == false

    % plot the response height as a function of delays
    f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on

    plot(delays, responses / responses(1), 'ok')

    xlabel('delays (ms)')
    ylabel('response height (mV)')
    title('response height as function of delay')

    figlib.pretty('PlotBuffer', 0.2);

  end % do_not_plot

end % function
