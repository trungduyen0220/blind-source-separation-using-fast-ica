%Returns the centered (zero mean) version of the input data
function [Zc, mu] = centerRows(Z)
mu = mean(Z,2);
Zc = bsxfun(@minus,Z,mu);
