pdflib.header;
tic

%% 1-compartment passive case (excitation)
% In the 1-compartment case, a single compartment representing a cylindrical patch of membrane
% is postsynaptic to two disconnected presynaptic compartments by AMPAergic and NMDAergic synapses.
% The AMPAergic presynaptic cell is stimulated to raise the baseline membrane potential of the postsynaptic cell.
% Then, the NMDAergic presynaptic cell is stimulated.
% The three conditions are AMPAergic, NMDAergic and both together.

try
  displayDataSummary('comp1-passive', 'experiment_excitation', [], true);
catch
  disp('no data available')
end

%%
% These are the top ten models by lowest cost.

try
  plotExemplars('comp1-passive', 'experiment_excitation', 10);
  pdflib.snap
  delete(gcf)
catch
end

%%
% These are the top ten models by highest response #3.

try
  dataTable = processData('comp1-passive', 'experiment_excitation');
  [~, I] = sort(dataTable.responses(:,3));
  plotExemplars('comp1-passive', 'experiment_excitation', I(end-9:end));
catch
end

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
