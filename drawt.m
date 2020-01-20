function sM = drawt(nodes, ChannelName)
sM = zeros(length(nodes));
for i = 2:length(nodes)
    if nodes(i) ~= 0
        sM(nodes(i),i) = 1;
    end
end
bgl = biograph(sM, ChannelName);
view(bgl);
return;
end