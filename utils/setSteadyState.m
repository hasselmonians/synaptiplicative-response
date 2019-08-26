function x = setSteadyState(x, V_clamp)
  % compute the steady-state and save as a snapshot

  if ~exist('V_clamp', 'var')
    V_clamp = [NaN, -90, -90];
  elseif isscalar(V_clamp)
    V_clamp = [NaN, V_clamp, V_clamp];
  else
    % assume V_clamp has the correct dimensions
  end

  x.set('t_end', 5e3);
  x.set('V_clamp', V_clamp);
  x.set('t_end', 500);
  x.set('*V', min(V_clamp));
  x.set('V_clamp', NaN(1,3));
  x.snapshot('steady-state');
end % function
