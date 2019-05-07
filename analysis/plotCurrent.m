function plotCurrent(fig)
  % computes the steady-state current as a function of presynaptic and postsynaptic membrane potential
  % uses equations for the Borgers/Jahr-Stevens NMDA synapse

  [s_inf, tau_s, u] = getGatingFunctions();

  % evaluate these functions
  V = linspace(-100,100,1e3);
  sinf = NaN*V;
  taus = NaN*V;
  uval = NaN*V;

  % compute the gating functions/time constants
  for ii = 1:length(V)
    sinf(ii) = s_inf(V(ii));
    taus(ii) = tau_s(V(ii));
    uval(ii) = u(V(ii));
  end

  %% Plot the figure
  % 2x2 grid

  if nargin < 1
    fig = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
  else
    set(0, 'CurrentFigure', fig);
  end

  for ii = 4:-1:1
    ax(ii) = subplot(2,2,ii); hold on
  end

  ax(1).Tag = 's_inf';
  ax(2).Tag = 'tau_s';
  ax(3).Tag = 's_inf*u';
  ax(4).Tag = 's_inf*u*(V-E)';

  % plot the gating function and time constant

  plot(ax(1), V, sinf, 'k');
  ylabel(ax(1),'s_{\infty}')
  xlabel(ax(1),'V (mV)')
  set(ax(1),'YLim',[0 1])

  plot(ax(2), V, uval, 'k');
  ylabel(ax(2),'u')
  xlabel(ax(2),'V (mV)')
  set(ax(2),'YLim',[0 1])

  plot(ax(3), V, taus, 'k');
  xlabel(ax(3),'V (mV)')
  ylabel(ax(3),'\tau_{s} (ms)')
  % set(ax(3),'YScale','log')

  % plot the normalized current as a function of both V_pre and V_post
  Vmesh = meshgrid(V);
  I = zeros(size(Vmesh));
  for ii = 1:length(V)
    for qq = 1:length(V)
      I(ii, qq) = sinf(ii) * uval(qq) * V(qq); % s * u * (V - E), where E = 0
    end
  end

  imagesc(ax(4), V, V, I');
  ylabel(ax(4),'V_{post} (mV)')
  xlabel(ax(4),'V_{pre} (mV)')
  % set(ax(4),'YScale','log')
  c = colorbar(ax(4));
  c.Label.String = 'norm. current density (nA/mm^2)';

  try
  	figlib.pretty();
  catch
  end

  % turn all YLim modes to auto
  for i = 1:length(ax)
  	ax(i).YLimMode = 'auto';
  end
