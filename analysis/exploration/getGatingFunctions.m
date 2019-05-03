function [s_inf, tau_s, u] = getGatingFunctions(varargin)

  % get the gating functions for Borgers/Jahr-Stevens NMDA model

  options = struct;
  options.Mg = 1;
  options.tau_r = 2;
  options.tau_d = 10;

  corelib.parseNameValueArguments(options, varargin{:});

  s_inf = @(v) ((1 + tanh(v/10))/2) / ( ((1 + tanh(v/10))/2) + options.tau_r/options.tau_d );
  tau_s = @(v) tau_r / ( ((1 + tanh(v/10))/2) + options.tau_r/options.tau_d );
  u     = @(v) 1 / ( 1 + options.Mg/3.57 * exp(-0.062 * v) );

end % function
