pdflib.header;
tic


%% 1-compartment passive case (double-pulse)
% In the 1-compartment case, a single compartment representing a cylindrical patch of membrane
% is postsynaptic to two disconnected presynaptic compartments by NMDAergic synapses.
% In the first experiment, only passive leak channels were included, aside from the synapses.
% 1000 simulations were performed.

try
  displayDataSummary('comp1-passive', 'experiment_double_pulse', [], true);
catch
  disp('no data available')
end

%%
% These are the top ten models by lowest cost.

try
  plotExemplars('comp1-passive', 'experiment_double_pulse', 10);
  pdflib.snap
  delete(gcf)
catch
end

%%
% These are the top ten models by highest response #3.

try
  dataTable = processData('comp1-passive', 'experiment_double_pulse');
  [~, I] = sort(dataTable.responses(:,3));
  plotExemplars('comp1-passive', 'experiment_double_pulse', I(end-9:end));
catch
end

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
