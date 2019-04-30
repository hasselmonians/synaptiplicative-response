pdflib.header;
tic

%% Introduction
% Anecdotal scientific evidence suggests that the combined action of multiple synapses
% upon a single region of membrane could interact in a strongly nonlinear (multiplicative)
% manner rather than a weakly nonlinear (additive) one.
% Specifically, this means that the EPSP recorded when two (populations of) synapses
% are stimulated simultaneously is much greater than EPSPs generated by independent
% stimulations of each synapse or population of synapses.
% If it is possible to faithfully produce a true multiplicative interaction,
% where the response to both (populations of) synapses is equal to the product
% of the responses individually, this would open up many new avenues for neural computation.
% Formally, for responses $R_1$, $R_2$, and $R_{12}$, the multiplicative interaction is
%
% $$ R_{12} = R_1 * R_2 $$
%
% and the additive interaction is
%
% $$ R_{12} = R_1 + R_2 $$
%

%% Methods
% Consider a single dendritic neuronal compartment comprised of a cylindrical patch of membrane.
% Two disconnected presynaptic compartments synapse onto the dendritic compartment.
% Each synapse is NMDAergic.
%
% The experiment is as follows:
% First, reach steady-state. Then zap the first presynaptic compartment to elicit an EPSP.
% Define the response as the maximum change in membrane potential of the postsynaptic dendritic compartment,
% and record it.
% Reach steady-state again, then zap the second presynaptic compartment, and record the second response.
% Reach steady-state a third time, then simultaneously stimulate both presynaptic compartments,
% and record the response.
% Compare the third response $R_{12}$ to the previous $R_1$ and $R_2$.
%
% In order to determine the parameters of the model which satisfy this condition,
% we used particle swarm optimization over the maximal conductances of the model.
% The model was implemented in |xolotl|.

%% NMDAergic synapses
% The NMDA synapse model used is based on the Jahr-Stevens model
% and can be found in C. Borgers 2017 Ch. 20.
% The conductance depends on both the presynaptic and postsynaptic membrane potentials
% as well as time.
% Magnesium block kinetics are assumed to be instantaneous,
% so that only one gating variable is needed.
%
% $$ I_{syn}(V_{pre}, V_{post}, t) = \bar{g} s(V_{pre}, t) u(V_{post}) (V_{post} - E_{syn}) $$
%
% The following figure depicts the postsynaptc current response parametrized
% by fixed postsynaptic membrane potential.
% The presynaptic compartment is subjected to a 2-ms pulse at 60 mV at $t = 0$ ms.

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
ax = subplot(1,1,1);
title(ax, 'NMDA current w.r.t. postsynaptic potential')
plotSynapse(ax);

pdflib.snap
delete(gcf)

%% 1-compartment case
% In the 1-compartment case, a single compartment representing a cylindrical patch of membrane
% is postsynaptic to two disconnected presynaptic compartments by NMDAergic synapses.
% In the first experiment, only passive leak channels were included, aside from the synapses.
% 100 simulations were performed.

% load the data into a data table
[dataTable, param_names] = processData('data-comp1-passive*.mat');

disp(['Models passing: ' num2str(height(dataTable)) '/100'])
disp('Parameter Names:')
disp(param_names)
summary(dataTable)

% plot responses in a line plot
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
plot(dataTable.responses', '-ko', 'MarkerFaceColor', 'k')
xticks([1 2 3])
xticklabels({'R_1', 'R_2', 'R_{1,2}'})
xlabel('response conditions')
ylabel('response magnitude (mV)')
xlim([0 4])
ylim([0.9*min(dataTable.responses(:)), 1.1*max(dataTable.responses(:))])
title('comp1-passive responses')
figlib.pretty()

pdflib.snap
delete(gcf)

% find exemplar
[~, idx] = min(dataTable.cost);
x = comp1.passive.model();
comps = x.find('compartment');
x.set(param_names, dataTable.params(idx, :));

% compute the membrane potential for the three conditions
[~, ~, ~, V] = comp1.simulate(x);

% set up presynaptic waveform pulse
time = (1:length(V))*x.dt;
pulseWidth  = round(2 / x.dt);
pulseHeight = 60;
pulseStart  = round(2 / x.dt);
pulseStop   = pulseStart + pulseWidth;
waveform = -60 * ones(length(time), 1);
waveform(pulseStart:pulseStop, 1) = pulseHeight;

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
ylabels = {'R_1 (mV)', 'R_2 (mV)', 'R_{1,2} (mV)'};
minlim = min(V(:)) - 10;
maxlim = max(V(:)) + 10;
for ii = 4:-1:1
  ax(ii) = subplot(4, 1, ii);
end
for ii = 1:3
  plot(ax(ii), time, V(:,ii), 'k');
  ylabel(ax(ii), ylabels{ii})
  ylim(ax(ii), [minlim maxlim])
end
plot(ax(4), time, waveform, 'k');
xlabel(ax(4), 'time (ms)')
ylabel(ax(4), 'clamp (mV)')

figlib.pretty()
pdflib.snap
delete(gcf)

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
