function plotIV(sinf, u)
  % make a plot of steady-state NMDAergic synaptic current vs. presynaptic membrane potential
  % parametrized by postsynaptic membrane potential

  % get the voltage and gating functions
  Vpre    = linspace(-20, 100, 21);
  Vpost   = linspace(-100, 100, 1e3+1);

  if nargin < 1
    [sinf, ~, u] = getGatingFunctions();
  end

  if nargin < 2
    [~, ~, u] = getGatingFunctions();
  end

  % compute the current as a matrix
  I       = zeros(length(Vpost), length(Vpre));
  for ii = 1:length(Vpost)
    for qq = 1:length(Vpre)
      I(ii, qq) = sinf(Vpre(qq)) * u(Vpost(ii)) * Vpost(ii);
    end
  end

  %% Plot the figure
  % 1x1 with many overlaid plots

  figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on

  C = colormaps.linspecer(length(Vpre));

  for ii = 1:size(I, 2)
    plot(Vpost, I(:, ii), 'Color', C(ii, :));
  end

  xlabel('postsynaptic membrane potential (mV)')
  ylabel('norm. current density (nA/mm^2)')
  yoffset = max([abs(min(I(:))), abs(max(I(:)))]);
  ymin = min(I(:)) - 0.1 * yoffset;
  ymax = max(I(:)) + 0.1 * yoffset;
  ylim([ymin ymax])

  c = colorbar('Location', 'EastOutside');
  c.Label.String = 'presynaptic membrane potential (mV)';
  c.Ticks = Vpre;
  caxis([min(Vpre) max(Vpre)]);
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
