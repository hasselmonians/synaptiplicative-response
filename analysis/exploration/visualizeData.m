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
