function [dataTable, param_names] = processData(filepaths)
  % gathers data from .mat files produced by simulations
  % that match the pattern in `filepaths`
  % and performs some filtering
  %
  % Ex: processData('data-comp1-passive*')
  %
  % the data are expected to have cost, costParts, params, and responses as fields

  %% Gather the data into a table

  dirs = dir(filepaths);
  assert(numel(dirs) > 0, ['could not find any data files for filepath: ' filepaths])

  % load the first dataset
  data = load(dirs(1).name);
  % save the parameter names separately, since it is sized differently
  param_names = data.param_names;
  data = rmfield(data, 'param_names');
  % create a table from the struct directly
  dataTable = struct2table(data);

  % for each other dataset, append
  if length(dirs) > 1
    for ii = 2:length(dirs)
      data = load(dirs(ii).name);
      data = rmfield(data, 'param_names');
      dataTable2 = struct2table(data);
      dataTable = [dataTable; dataTable2];
    end
  end

  %% Eliminate "failing" parameter sets

  % failing is defined as having a cost >= 1e4
  dataTable = dataTable(dataTable.cost < 1e4, :);

end % function
