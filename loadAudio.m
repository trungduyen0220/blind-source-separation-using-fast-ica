function Z = loadAudio(paths)
p = numel(paths);
audio = cell(1,p);
for i = 1:p
    path = paths{i};
    audio{i} = audioread(path);
end
nSamples = cellfun(@numel,audio);
n = min(nSamples);
Z = zeros(p,n);
for i = 1:p
    ni     = nSamples(i);
    gapL   = floor(0.5 * (ni - n));
    gapR   = ceil( 0.5 * (ni - n));
    Z(i,:) = audio{i}((gapL + 1):(ni - gapR));
end
Z = normalizeAudio(Z);
