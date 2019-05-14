function x = setSteadyState(x)
  % compute the steady-state and save as a snapshot
  x.t_end = 5e3;
  V = x.integrate;
  x.t_end = 30;
  x.snapshot('steady-state');
end % function
