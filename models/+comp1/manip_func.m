function manip_func(x)

	% let's figure out if we need to make the plot or not
	if ~isfield(x.handles,'manip_plot') || ~isvalid(x.handles.manip_plot.main_fig')

		% make the figure
		manip_plot.main_fig = figure('outerposition',[300 300 1200 700],'PaperUnits','points','PaperSize',[1200 700]); hold on

		% make the subplots
		manip_plot.case1 = subplot(4,1,1); hold on
		manip_plot.case2 = subplot(4,1,2); hold on
		manip_plot.case3 = subplot(4,1,3); hold on;
		manip_plot.Vclamp = subplot(4,1,4); hold on;

		% make the plots
		manip_plot.plots.V1 = plot(manip_plot.case1, NaN, NaN, 'k');
		manip_plot.plots.V2 = plot(manip_plot.case2, NaN, NaN, 'k');
		manip_plot.plots.V3 = plot(manip_plot.case3, NaN, NaN, 'k');
		manip_plot.plots.Vclamp = plot(manip_plot.Vclamp, NaN, NaN, 'k');

		% attach to puppeteer so that it can be closed automatically
		x.handles.puppeteer_object.attachFigure(manip_plot.main_fig)

		% labels
		ylabel(manip_plot.case1, 'R_1 (mV)')
		ylabel(manip_plot.case2, 'R_2 (mV)')
		ylabel(manip_plot.case3, 'R_{1,2} (mV)')
		xlabel(manip_plot.Vclamp, 'time (ms)')
		ylabel(manip_plot.Vclamp, 'clamped voltage (mV)')

		% add the master plot handle to xolotl for safekeeping
		x.handles.manip_plot = manip_plot;

	end

	% assert that the master plot handle and the working handle are the same
	manip_plot = x.handles.manip_plot;

	% make the plots
	x.output_type = 0;

	% compute the steady-state
	% this has to be done here because the parameters change
	x = setSteadyState(x);

	% set up presynaptic waveform pulse
	pulseWidth  = round(2 / x.dt);
	pulseHeight = 50;
	pulseStart  = round(2 / x.dt);
	pulseStop   = pulseStart + pulseWidth;

	% useful variables
	comps = x.find('compartment');

	% output variable
	V = NaN(x.t_end / x.dt, 3);
	time = (1:length(V))*x.dt;
	waveform = -60 * ones(x.t_end / x.dt, 1);
	waveform(pulseStart:pulseStop, 1) = pulseHeight;

	% set the voltage clamp in the correct presynaptic compartments
	for ii = [1 2 3]
		x.reset('steady-state');
		V_clamp = NaN(x.t_end / x.dt, length(comps));

		if ii == 1
			% zap the first compartment
			V_clamp(:, strcmp(comps, 'Presynaptic1')) = waveform;
		elseif ii == 2
			% zap the second compartment
			V_clamp(:, strcmp(comps, 'Presynaptic2')) = waveform;
		else
			% zap both compartments
			V_clamp(:, strcmp(comps, 'Presynaptic1')) = waveform;
			V_clamp(:, strcmp(comps, 'Presynaptic2')) = waveform;
		end

		% clamp the specified compartments
		x.V_clamp = V_clamp;
		% perform the simulation
		Vtemp = x.integrate;
		% store the correct voltage
		V(:, ii) = Vtemp(:, strcmp(comps, 'Dendrite'));

	end

	% set up the y-limits

	minlim = min(V(:)) - 10;
	maxlim = max(V(:)) + 10;

	ylim(manip_plot.case1, [minlim maxlim]);
	ylim(manip_plot.case2, [minlim maxlim]);
	ylim(manip_plot.case3, [minlim maxlim]);

	% add the data to the plots
	manip_plot.plots.V1.XData = time;
	manip_plot.plots.V1.YData = V(:,1);
	manip_plot.plots.V2.XData = time;
	manip_plot.plots.V2.YData = V(:,2);
	manip_plot.plots.V3.XData = time;
	manip_plot.plots.V3.YData = V(:,3);
	manip_plot.plots.Vclamp.XData = time;
	manip_plot.plots.Vclamp.YData = waveform;

end
