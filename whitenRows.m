%Returns the whitened (identity covariance) version of the input data
function [Zw, T] = whitenRows(Z)

% Compute sample covariance
R = cov(Z');

% Whiten data
[U, S, ~] = svd(R,'econ');
T  = U * diag(1 ./ sqrt(diag(S))) * U';
Zw = T * Z;
