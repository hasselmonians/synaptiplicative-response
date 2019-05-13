function plotIV(ax, u)
  % make a plot of steady-state NMDAergic synaptic current vs. postsynaptic membrane potential
  % parametrized by presynaptic membrane potential

  % get the voltage and gating functions
  Vpost   = linspace(-70, 0, 1e3+1);

  if nargin < 2
    [~, ~, u] = getGatingFunctions();
  end

  % compute the current
  I       = zeros(length(Vpost), 1);
  for ii = 1:length(Vpost)
      I(ii) = u(Vpost(ii)) * Vpost(ii);
  end

  %% Plot the figure
  % 1x1

  if nargin < 1 || isempty(ax)
    figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
    ax = gca;
  end

  hold(ax, 'on');
    plot(ax, Vpost, I, 'k');

  xlabel(ax, 'postsynaptic membrane potential (mV)')
  ylabel(ax, 'norm. current density (nA/mm^2)')
  yoffset = max([abs(min(I(:))), abs(max(I(:)))]);
  ymin = min(I(:)) - 0.1 * yoffset;
  ymax = max(I(:)) + 0.1 * yoffset;
  ylim(ax, [ymin ymax])
  title('NMDAergic peak current IV curve')

  try
  	figlib.pretty();
  catch
  end
