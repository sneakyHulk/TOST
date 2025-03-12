function [h, plower, pupper] = TOSTtest2_matlab(X, Y, delta, varargin)

[h1, plower, ~] = ttest2(X - delta, Y, varargin{:}, 'Tail', 'left');
[h2, pupper, ~] = ttest2(X + delta, Y, varargin{:}, 'Tail', 'right');

h = h1 && h2;
end
