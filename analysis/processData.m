function [dataTable, param_names, x, total_models] = processData(keyword, containing_folder, cutoff)
  % gathers data from .mat files produced by simulations
  % that match the pattern in `filekey`
  % and performs some filtering
  %
  % Ex: processData('comp1-passive', 1e4)
  %
  % the data are expected to have cost, costParts, params, and responses as fields
  %
  % Arguments:
  %   filekey: character vector of one or two keywords separated by a dash '-'
  %     e.g. 'comp1-passive' or 'comp2-transient'
  %   containing_folder: character vector
  %     specifies which folder inside of the /data/ folder we should look in
  %     if nothing is specified, then searches for everything inside of /data/
  %   cutoff: only models with a cost less than the cutoff will be considered
  %     defaults to 10,000
  % Outputs:
  %   dataTable: a table containing the cost, costParts, parameters, and responses
  %   param_names: a cell array of the names of the xolotl parameters optimized over
  %   x: the xolotl object with default parameters
  %   total_models: the original total number of models in the data set
  %     before being pared down by the cutoff

  if nargin < 2
    containing_folder = '**';
  end

  if nargin < 3
    cutoff = 1e4;
  end


  %% Gather the data into a table

  filekey = fullfile(fileparts(mfilename('fullpath')), ['data-', keyword, '*.mat']);
  filekey = strrep(filekey, 'analysis', ['data' filesep containing_folder]);
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

  % total number of models before pruning the dataset
  total_models = height(dataTable);

  % failing is defined as having a cost >= cutoff
  dataTable = dataTable(dataTable.cost < cutoff, :);

  %% Instantiate the xolotl object

  if nargout > 2
    x = eval([pkgkey{1} '.' pkgkey{2} '.model()']);
  end

end % function
