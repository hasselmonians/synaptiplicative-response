function plotIV()
  % make a plot of steady-state NMDAergic synaptic current vs. presynaptic membrane potential
  % parametrized by postsynaptic membrane potential

  % get the voltage and gating functions
  V       = linspace(-100,100,1e3);
  Vpost   = linspace(-100, -20, 11);
  [s_inf, ~, u] = getGatingFunctions();

  % evaluate these functions
  sinf    = NaN*V;
  uval    = NaN*V;
  I       = zeros(length(V), 11);

  % compute the gating functions/time constants
  for ii = 1:length(V)
    sinf(ii)  = s_inf(V(ii));
    uval(ii)  = u(V(ii));
  end

  % compute the current as a matrix
  for ii = 1:length(V)
    for qq = 1:length(Vpost)
      I(ii, qq) = sinf(ii) * uval(qq) * V(ii);
    end
  end

  %% Plot the figure
  % 1x1 with many overlaid plots

  figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1200 1000]); hold on

  C = colormaps.linspecer(size(I, 2));

  for ii = 1:size(I, 2)
    plot(V, I(:, ii), 'Color', C(ii, :));
  end

  xlabel('presynaptic membrane potential (mV)')
  ylabel('norm. current density (nA/mm^2)')
  yoffset = max([abs(min(I(:))), abs(max(I(:)))]);
  ymin = min(I(:)) - 0.1 * yoffset;
  ymax = max(I(:)) + 0.1 * yoffset;
  ylim([ymin ymax])

  c = colorbar('Location', 'EastOutside');
  c.Label.String = 'V_{post} (mV)';
  c.TickLength = 1/length(Vpost);
  caxis([min(Vpost) max(Vpost)]);
  colormap(colormaps.linspecer)

  try
  	figlib.pretty();
  catch
  end
  %
  % % turn all YLim modes to auto
  % for i = 1:length(ax)
  % 	ax(i).YLimMode = 'auto';
  % end
