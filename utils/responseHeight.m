function delta = responseHeight(V, Vss)
    % measure the peak change in membrane potential during a stimulus
    % V: the waveform during the pulse represented as a vector
    % Vss: the steady-state prior to the pulse, as a scalar

    % if Vss isn't specified, default to V(1)
    if nargin < 2
        Vss = V(1);
    elseif isempty(Vss)
        Vss = V(1);
    end

    delta = max(V) - Vss;

end % function
