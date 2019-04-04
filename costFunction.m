function cost = costFunction(R, epsilon, lambda, bounds)
    % Arguments:
    %   R: 3x1 vector of responses (first, second, both)
    %   epsilon: minimal value a response needs to be
    %   lambda: 3x1 vector of parameters scaling the relative cost of the following
    %       1: cost due to distance from multiplicative response
    %       2: cost due to closeness to additive response
    %       3: cost due to failure for response to be in a supralinear range [bounds(1), bounds(2)]
    %   bounds: 2x1 vector giving the lower and upper bounds as coefficients such that
    %       lower bound: bounds(1) * (R(1) + R(2))
    %       upper bound: bounds(2) * (R(1) + R(2))

    if nargin < 4
        bounds = [];
        lambda(3) = 0;
    end

    if isempty(epsilon)
        epsilon = 100; % microvolts
    end

    if isempty(lambda)
        lambda = [1, 1, 1];
    end

    % initialize the cost
    costParts = zeros(4, 1); % this will be summed at the end for the total cost
    cost      = 0;

    % useful variables
    multiplicative  = R(3) - R(1)*R(2);
    additive        = R(3) - R(1) - R(2);

    % cost due to insignificance of response
    costParts(1) = 1e9 * sum(R < epsilon);

    % cost due to distance from multiplicative response
    costParts(2) = lambda(1) * multiplicative^2;

    % cost due to closeness to additive response
    if additive < 1e-9;
        costParts(3) = 1e9;
    else
        costParts(3) = lambda(2) * (1/additive)^2;
    end

    % cost due to failure for response to live in a supralinear range
    if lambda(3) == 0 || isempty(bounds)
        % do nothing
    else
        lb = bounds(1) * (R(1) + R(2));
        ub = bounds(2) * (R(1) + R(2));
        if R(3) < lb
            costParts(4) = lambda(3) * (R(3) - lb)^2;
        elseif R(3) > ub
            costParts(4) = lambda(3) * (R(3) - ub)^2;
        end
    end

    cost = sum(costParts);

end % function
