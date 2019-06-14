function x = setSteadyState(x, V_clamp)
  % compute the steady-state and save as a snapshot

  if nargin < 2
    V_clamp = [NaN, -90, -90];
  end

  x.t_end = 5e3;
  x.V_clamp = V_clamp;
  V = x.integrate;
  x.t_end = 500;
  x.set('*V', -90);
  x.V_clamp = [NaN, NaN, NaN];
  x.snapshot('steady-state');
end % function
