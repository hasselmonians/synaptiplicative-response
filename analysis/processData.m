function [dataTable, param_names, x] = processData(keyword)
  % gathers data from .mat files produced by simulations
  % that match the pattern in `filekey`
  % and performs some filtering
  %
  % Ex: processData('comp1-passive')
  %
  % the data are expected to have cost, costParts, params, and responses as fields
  % 
  % Arguments:
  %   filekey: character vector of one or two keywords separated by a dash '-'
  %     e.g. 'comp1-passive' or 'comp2-transient'

  %% Gather the data into a table
  
  filekey = fullfile(fileparts(mfilename('fullpath')), ['data-', keyword, '*.mat']);
  filekey = strrep(filekey, 'analysis', 'data');
  pkgkey  = split(keyword, '-');

  dirs = dir(filekey);
  assert(numel(dirs) > 0, ['could not find any data files for filepath: ' filekey])

  % load the first dataset
  data = load(fullfile(dirs(1).folder, dirs(1).name));
  % save the parameter names separately, since it is sized differently
  param_names = data.param_names;
  data = rmfield(data, 'param_names');
  % create a table from the struct directly
  dataTable = struct2table(data);

  % for each other dataset, append
  if length(dirs) > 1
    for ii = 2:length(dirs)
      data = load(fullfile(dirs(ii).folder, dirs(ii).name));
      data = rmfield(data, 'param_names');
      dataTable2 = struct2table(data);
      dataTable = [dataTable; dataTable2];
    end
  end

  %% Eliminate "failing" parameter sets

  % failing is defined as having a cost >= 1e4
  dataTable = dataTable(dataTable.cost < 1e4, :);
  
  %% Instantiate the xolotl object
  
  if nargout > 2
    x = eval([pkgkey{1} '.' pkgkey{2} '.model()']);
  end

end % function
