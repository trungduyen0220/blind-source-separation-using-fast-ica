% Normalize rows to [-1, 1]
function Zn = normalizeAudio(Z)
Zn = bsxfun(@rdivide,Z,max(abs(Z),[],2));
