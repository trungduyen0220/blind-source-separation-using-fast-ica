function [Zc, mu] = centerRows(Z)
mu = mean(Z,2);
Zc = bsxfun(@minus,Z,mu);
