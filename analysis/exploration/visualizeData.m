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
% Magnesium block kinetics are assumed to be instantaneous (e.g. $\tau_u \rightarrow 0$),
% so that only one gating variable is needed.
%
% $$ I_{syn}(V_{pre}, V_{post}, t) = \bar{g} s(V_{pre}, t) u(V_{post}) (V_{post} - E_{syn}) $$
%

%%
% The gating variable steady-state $s_\infty$, the time constant $\tau_s$,
% the magnesium-block kinetics $u$, and the normalized steady-state current
% $\bar{I}_{\infty} = s_\infty (V_{pre}) u(V_{post}) (V_{post} - E_{syn})$ are plotted.

fig = figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
plotCurrent(fig);

figlib.pretty();
pdflib.snap();
delete(gcf)

%%
% The IV curve of the NMDAergic postsynaptic current vs. presynaptic membrane potential,
% parametrized by postsynaptic membrane potential.

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
ax = axes;
title(ax, 'NMDA synapse IV curve')
plotIV(ax);

figlib.pretty();
pdflib.snap();
delete(gcf)

%%
% The following figure depicts the postsynaptic current response parametrized
% by fixed postsynaptic membrane potential.
% The presynaptic compartment is subjected to a 2-ms pulse at 60 mV at $t = 0$ ms.

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
ax = axes;
title(ax, 'NMDA current w.r.t. postsynaptic potential')
[~, I, V] = plotSynapse(ax);

figlib.pretty();
pdflib.snap();
delete(gcf)

%%
% From the previous simulation, the peak current versus the postsynaptic holding current.

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
ax = axes;
title(ax, 'Peak current w.r.t. postsynaptic potential')
plot(ax, V, max(I), 'ok');
xlabel(ax, 'postsynaptic holding potential (mV)')
ylabel(ax, 'peak current response (nA/mm^2)')

figlib.pretty();
pdflib.snap();
delete(gcf)

%% 1-compartment passive case
% In the 1-compartment case, a single compartment representing a cylindrical patch of membrane
% is postsynaptic to two disconnected presynaptic compartments by NMDAergic synapses.
% In the first experiment, only passive leak channels were included, aside from the synapses.
% 100 simulations were performed.

displayDataSummary('comp1-passive', false);

%% 1-compartment spiking case

displayDataSummary('comp1-spiking', false);

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
