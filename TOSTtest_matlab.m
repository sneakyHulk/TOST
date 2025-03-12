function [h, plower, pupper] = TOSTtest_matlab(X, delta, m, varargin)

if nargin < 3 || isempty(m)
    m = 0;
elseif ~isscalar(m)
    error('M must be a scalar');
end

[h1, plower, ~] = ttest(X - delta, m, varargin{:}, 'Tail', 'left');
[h2, pupper, ~] = ttest(X + delta, m, varargin{:}, 'Tail', 'right');

h = h1 && h2;
end