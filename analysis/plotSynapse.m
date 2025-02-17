function [t, I, V_hold, ax] = plotSynapse(ax)

%% Plot Synapse
% Visualize the synaptic current of an NMDAergic synapse model given varying
% presynaptic pulses and a constant post-synaptic membrane potential


%% Create model
% include two compartments with one NMDAergic synapse
% Leak currents are required (to prevent voltage integration errors)

x = xolotl;
x.add('compartment', 'Dendrite', 'Cm', 30, 'radius', 4e-3, 'len', 110e-3);
x.add('compartment', 'Presynaptic', 'Cm', 30, 'radius', 4e-3, 'len', 110e-3);
x.Dendrite.add('Leak', 'gbar', 0.1, 'E', -60);
x.Presynaptic.add('Leak', 'gbar', 0.1, 'E', -60);
x.connect('Presynaptic', 'Dendrite', 'borgers/NMDAergic', 'gmax', 1, 'Mg', 2, 'tau_d', 30, 'tau_r', 2, 'E', 0);

%% Set up simulation

% time parameters
x.t_end = 100;
x.dt = 1e-3;
x.sim_dt = 1e-3;

% set up pulse
pulseStart  = 30 / x.dt;
pulseWidth  = 2 / x.dt;
pulseStop   = pulseStart + pulseWidth;
pulseHeight = 60;

% set up voltage clamp
V_clamp = -60 * ones(x.t_end / x.dt, 2); % presynaptic compartment
V_clamp(pulseStart:pulseStop, 2) = pulseHeight;

% set up increasing holding potential for post-synaptic compartment
V_hold = linspace(-70, 0, 8);

%% Perform simulation

% output variables
I = NaN(x.t_end / x.dt, 8);

% pre-simulation parameters
x.closed_loop = false;

% perform loop
for ii = 1:8
  % set up voltage clamp
  V_clamp(:, 1) = V_hold(ii); % postsynaptic compartment
  x.V_clamp = V_clamp;
  % perform integration
  [~, ~, ~, ~, Isyn] = x.integrate;
  I(:, ii) = Isyn(:, 3);
end

%% Plot the results

t = x.dt * ((1:length(I)) - pulseStart); % pulse starts at t = 0
C = colormaps.linspecer(size(I, 2));

if nargin < 1 || isempty(ax)
  figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
  ax = gca;
end

hold(ax, 'on');
for ii = 1:size(I, 2)
  plot(ax, t, I(:, ii), 'Color', C(ii, :));
end
xlabel(ax, 'time (ms)')
ylabel(ax, 'current density')
c = colorbar(ax, 'Location', 'EastOutside');
c.Label.String = 'V_{post} (mV)';
c.Ticks = V_hold;
caxis(ax, [min(V_hold) max(V_hold)]);
colormap(ax, colormaps.linspecer);
figlib.pretty();
