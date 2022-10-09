function emb = EmbRead(embfile)
emb = textread(embfile, '', 'emptyvalue', NaN, 'headerlines', 1);
if length(find(isnan(emb))) > 0
    disp('ERROR! Emb file ERROR');
    quit;
end
emb = sortrows(emb, 1);
emb = emb(:, 2:end);
