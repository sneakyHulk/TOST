function [h, plower, pupper, ci] = TOSTtest2(X, Y, delta, varargin)
%TOSTTEST2 TOST (Two One-Sided Tests) for equivalence.
%   H = TOSTTEST2(X,Y,DELTA) performs Two One-Sided Tests (TOST) for two
%   hypotheses. The first hypothesis is that two independent samples, in
%   the vectors X and Y, come from distributions with means whose
%   difference is not lower bounded by -DELTA, while the second hypothesis
%   is that it is not upper bounded by DELTA. This translates into the
%   difference of the means being outside the equivalence margin [-DELTA,
%   DELTA]. The function returns the result of the test in H. H=0 indicates
%   that one of both null hypotheses ("differnce of means are outside of
%   the equivalence margin") cannot be rejected at the 5% significance
%   level. H=1 indicates that both null hypotheses can be rejected at the
%   5% level. The data are assumed to come from normal distributions with
%   unknown, but equal, variances.
% 
%   This function performs an unpaired two-sample TOST-test. For a paired
%   test, use the TOSTTEST function.
% 
%   [H,PLOWER,PUPPER] = TOSTTEST2(...) returns the p-values. Small values
%   of PLOWER cast doubt on the validity of the fist null hypothesis and
%   small values of PUPPER cast doubt on the validity of the second null
%   hypothesis.
%
%   [...] = TOSTTEST2(X,Y,delta,'PARAM',val1) specifies the following
%   name/value pairs:
%
%       Parameter       Value
%       'alpha'         A value ALPHA between 0 and 1 specifying the
%                       significance level as (100*ALPHA)%. Default is
%                       0.05 for 5% significance.
%
%   See also TTEST2, VARTEST2.

p = inputParser;
addParameter(p, 'alpha', 0.05, @(x) isnumeric(x) && isscalar(x) && (x >= 0) && (x <= 1));

parse(p, varargin{:});
alpha = p.Results.alpha;

s2x = var(X);
s2y = var(Y);
xmean = mean(X);
ymean = mean(Y);
nx = length(X);
ny = length(Y);
difference = xmean - ymean;

dfe = nx + ny - 2;
sPooled = sqrt(((nx-1) .* s2x + (ny-1) .* s2y) ./ dfe);
se = sPooled .* sqrt(1./nx + 1./ny);

t1 = (difference + delta) ./ se;
t2 = (difference - delta) ./ se;
pupper = 1-tcdf(t1, dfe);
plower = tcdf(t2, dfe);

h = max(plower, pupper) <= alpha;
end