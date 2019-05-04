function [s_inf, tau_s, u] = getGatingFunctions()
  % get the gating functions for Borgers/Jahr-Stevens NMDA model

  s_inf = @(v) ((1 + tanh(v/10))/2) / ( ((1 + tanh(v/10))/2) + 2/10 );
  tau_s = @(v) 2 / ( ((1 + tanh(v/10))/2) + 2/10 );
  u     = @(v) 1 / ( 1 + 1/3.57 * exp(-0.062 * v) );

end % function
