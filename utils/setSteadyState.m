function x = setSteadyState(x, V_clamp)
  % compute the steady-state and save as a snapshot
  
  if nargin < 2
    V_clamp = [NaN, -70, -70];
  end
  
  x.t_end = 5e3;  
  x.V_clamp = V_clamp;
  V = x.integrate;
  x.t_end = 100;
  x.snapshot('steady-state');
end % function
