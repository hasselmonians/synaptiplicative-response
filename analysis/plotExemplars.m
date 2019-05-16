function plotExemplars(filekey, pkgkey, indices)
  
  % plots the results of a double-pulse experiment
  % as response traces vs. time
  % can overlay an arbitrary number of responses
  
  %% Generate the figure to plot on
  
  % check to see if a figure exists
  allfigs = get(0, 'Children');
  f = [];
  for ii = 1:length(allfigs)
    if ~isempty(allfigs(ii).Tag) && strcmp(allfigs(ii).Tag, 'plot-exemplars')
      f = allfigs(ii);
      ax = findall(f, 'type', 'axes');
    end
  end
  
  % if a figure isn't found, make one
  if isempty(f)
    
    f = figure('outerposition',[100 100 1000 800],'PaperUnits','points','PaperSize',[1000 800]); hold on
    for ii = 1:3
      ax(ii) = subplot(3, 1, ii); hold on;
    end
    
    ax(1).Tag = 'response 1';
    ax(2).Tag = 'response 2';
    ax(3).Tag = 'response 1 and 2';
    
    xlabel(ax(1), 'time (ms)')
    ylabel(ax(1), 'R_{1} (mV)')
    
    xlabel(ax(2), 'time (ms)')
    ylabel(ax(2), 'R_{2} (mV)')
    
    xlabel(ax(3), 'time (ms)')
    ylabel(ax(3), 'R_{1,2} (mV)')
    
    f.Tag = 'plot-exemplar';
    
  end
  
  %% Create the data table and xolotl object
  
  [dataTable, param_names, x] = processData(filekey, pkgkey);
  
  % determine the correct indices
  if nargin < 3
    % pick the top ten
    [~, indices] = sort(dataTable.cost);
    indices = indices(1:10);
  else
    index = indices;
    [~, indices] = sort(dataTable.cost);
    indices = indices(1:index);
  end
  
  % create the legend array
  for ii = 1:length(indices)
    leg(ii) = {num2str(indices(ii))};
  end
  
  % for each index, perform the computation
  % and save the voltage response
  
  for ii = 1:length(indices)
    x.set(param_names, dataTable.params(indices(ii), :));
    [~, ~, ~, V] = eval([pkgkey{1} '.simulate(x)']);
  
    % plot the results
    t = x.dt * (1:length(V));
    plot(ax(find(strcmp({ax.Tag}, 'response 1'))), t, V(:,1))
    plot(ax(find(strcmp({ax.Tag}, 'response 2'))), t, V(:,2))
    plot(ax(find(strcmp({ax.Tag}, 'response 1 and 2'))), t, V(:,3))
  end
  
  try
    figlib.pretty();
  catch
  end
  
  % instantiate the legend and link the axes
  axes(ax(1));
  legend(ax(1), leg, 'Location', 'EastOutside');
  linkaxes(ax, 'xy')
  
end % function
  
