function [h, plower, pupper, ci] = TOSTtest(X, delta, m, varargin)
%TOSTTEST TOST (Two One-Sided Tests) for equivalence.
%   H = TOSTTEST(X,DELTA) performs Two One-Sided Tests (TOST) for two
%   hypotheses. The first hypothesis is that the data in vector X come from
%   a distribution with the mean that is not lower bounded by -DELTA, while
%   the second hypothesis is that it is not upper bounded by DELTA. This
%   translates into the mean being outside the equivalence margin [-DELTA,
%   DELTA]. The function returns the result of the test in H. H=0 indicates
%   that one of both null hypotheses ("mean is outside of the equivalence
%   margin") cannot be rejected at the 5% significance level. H=1 indicates
%   that both null hypotheses can be rejected at the 5% level. The data are
%   assumed to come from a normal distribution with unknown variance.
%
%   H = TOSTTEST(X,DELTA,M) performs a t-test of the hypothesis that the
%   data in X come from a distribution with mean M. M must be a scalar.
% 
%   [H,PLOWER,PUPPER] = TOSTTEST(...) returns the p-values. Small values
%   of PLOWER cast doubt on the validity of the fist null hypothesis and
%   small values of PUPPER cast doubt on the validity of the second null
%   hypothesis.
%
%   [...] = TOSTTEST(X,Y,delta,'PARAM',val1) specifies the following
%   name/value pairs:
%
%       Parameter       Value
%       'alpha'         A value ALPHA between 0 and 1 specifying the
%                       significance level as (100*ALPHA)%. Default is
%                       0.05 for 5% significance.
%
%   See also TTEST, TOSTTEST2

if nargin < 3 || isempty(m)
    m = 0;
elseif ~isscalar(m)
    error('M must be a scalar');
end

p = inputParser;
addParameter(p, 'alpha', 0.05, @(x) isnumeric(x) && isscalar(x) && (x >= 0) && (x <= 1));

parse(p, varargin{:});
alpha = p.Results.alpha;

sx = std(X);
xmean = mean(X);
nx = length(X);
xdiff = (xmean - m);

df = nx - 1;
ser = sx ./ sqrt(nx);

t1 = (xdiff + delta) ./ ser;
t2 = (xdiff - delta) ./ ser;
pupper = 1-tcdf(t1, df);
plower = tcdf(t2, df);

h = max(plower, pupper) <= alpha;
end