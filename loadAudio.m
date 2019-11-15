function Z = loadAudio(paths)


p = numel(paths);
% Load audio
audio = cell(1,p);
for i = 1:p
    path = paths{i};
    %[~, ~, ext] = fileparts(path);
    audio{i} = audioread(path);
end

% Determine sample length
nSamples = cellfun(@numel,audio);
n = min(nSamples);

% Construct audio matrix
Z = zeros(p,n);
for i = 1:p
    ni     = nSamples(i);
    gapL   = floor(0.5 * (ni - n));
    gapR   = ceil( 0.5 * (ni - n));
    Z(i,:) = audio{i}((gapL + 1):(ni - gapR));
end

% Normalize audio
Z = normalizeAudio(Z);
