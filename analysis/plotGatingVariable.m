function plotGatingVariable(ax)
  % plots the gating variable of NMDA as a function of presynaptic voltage
  % parametrized by the width parameter, sigma

  if nargin < 1 || isempty(ax)
    fig = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
    ax = gca;
  end

  V = linspace(-50, 50, 1e3+1);
  sigs = 1:10;
  C = colormaps.linspecer(length(sigs));

  hold(ax, 'on');

  for ii = 1:length(sigs)
    plot(ax, V, sinf(ss(V, sigs(ii))), 'Color', C(ii, :));
  end

  xlabel(ax, 'membrane potential (mV)')
  ylabel(ax, 's_{\infty}')

  c = colorbar(ax, 'Location', 'EastOutside');
  c.Label.String = '\sigma (mV)';
  c.Ticks = sigs;
  caxis(ax, [min(sigs) max(sigs)]);
  colormap(ax, colormaps.linspecer)

  figlib.pretty();

end % function

function val = ss(V, sig)
  val = (1 + tanh(V/sig))/2;
end

function val = sinf(ss)
  val = ss ./ (ss + 5);
end
