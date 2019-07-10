% plot the maximal EPSP response as a function of delay between presynaptic pulses
% parametrized by maximal synaptic conductance

% maximal synaptic conductance (μS)
gmaxes = [15, 20, 25, 30, 35, 40, 45, 50, 55, 60];
% container for responses (mV)
responses = cell(length(gmaxes), 1);
% container for legend entries
leg = cell(length(gmaxes), 1);

% generate the model
x = model();

% compute the responses with a delay, do not plot
for ii = 1:length(gmaxes)
  corelib.textbar(ii, length(gmaxes))
  x.set('*gmax', gmaxes(ii));
  [responses{ii}, delay] = plotDelay(x, [], [], true);
end

%% Plot the responses and normalized responses as circles

f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
c = colormaps.linspecer(length(gmaxes));

for ii = 2:-1:1
  ax(ii) = subplot(1, 2, ii); hold on
end

for ii = 1:length(gmaxes)
  plot(ax(1), delay, responses{ii}, 'o', 'Color', c(ii, :));
  plot(ax(2), delay, responses{ii} ./ responses{ii}(1), 'o', 'Color', c(ii, :));
  % leg{ii} = ['\bar{g} = ' num2str(gmaxes(ii)) ' \muS/mm^2'];
end

xlabel(ax(1), 'delay (ms)')
xlabel(ax(2), 'delay (ms)')
ylabel(ax(1), 'response height (mV)')
ylabel(ax(2), 'norm. response height')
% legend(ax(2), leg, 'Location', 'NorthEast')

C = colorbar(ax(2), 'Location', 'EastOutside');
C.Label.String = 'synaptic strength (\muS/mm^2)';
C.Ticks = gmaxes;
caxis(ax(2), [min(gmaxes) max(gmaxes)]);
colormap(ax(2), colormaps.linspecer)

figlib.pretty('PlotBuffer', 0.2)

%% Plot the threshold crossing times as a function of presynaptic strength

% generate model
x = model();
% set the leak current reversal potential to -70 mV
x.set('*Leak.E', -70);
% set the synaptic strength of the second presynaptic compartment to 30 μS
x.Dendrite.NMDAergicPresynaptic2.gmax = 30;

% take measurements at several delays
delays = linspace(0, 300, 11);
% consider a spike an event that happens at -50 mV
threshold   = -50; % mV

% containers for output variables
responses   = zeros(length(gmaxes), 1); % mV, only third (combined) response
crossings   = zeros(length(gmaxes), 1); % will be in ms eventually
pulseDelays = zeros(length(gmaxes), 2); % will be in ms eventually

% plot crossings measuered from end of first pulse as a function of synaptic strength
f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
c = colormaps.linspecer(length(delays));

% perform the simulation to acquire the responses, crossings, and pulse delays for each delay
len_gmaxes = length(gmaxes);
len_delays = length(delays);
for qq = 1:len_delays
  corelib.textbar((qq-1) * len_gmaxes + ii , len_gmaxes*len_delays)
  for ii = 1:len_gmaxes
    % set the synaptic strength of the first presynaptic compartment
    x.Dendrite.NMDAergicPresynaptic1.gmax = gmaxes(ii);
    [responses(ii), ~, crossings(ii), pulseDelays(ii, :)] = plotDelay(x, threshold, delays(qq), true);
  end % ii

  % scale the crossings and pulse delays to milliseconds
  crossings   = x.dt * crossings; % ms
  pulseDelays = x.dt * pulseDelays; % ms

  % plot the crossings vs synaptic strength, color based on delay time
  plot(gmaxes, crossings - pulseDelays(:,1), 'o', 'Color', c(qq, :));
end % qq

xlabel('synaptic strength (\muS/mm^2)')
ylabel('threshold crossing time (ms)')

C = colorbar('Location', 'EastOutside');
C.Label.String = 'delay time (ms)';
C.Ticks = delays;
caxis([min(delays) max(delays)]);
colormap(colormaps.linspecer)

figlib.pretty('PlotBuffer', 0.2)
