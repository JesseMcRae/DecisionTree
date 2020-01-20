clc; clear; close all;
load iris;
% t = fitctree(iris(:, 1:4), iris(:, 5));
% view(t, 'mode', 'graph');
TrainTag = randperm(150, 90);
train = iris(TrainTag, :);
OtherTag = setdiff(1:150, TrainTag);
TestTag = OtherTag(randperm(60, 30));
test = iris(TestTag, :);
ValTag = setdiff(OtherTag, TestTag);
valdate = iris(ValTag, :);

[table, nodes, channels] = planttree(train);
correct = compute(test, table);
disp(['accuracy of test before pruning: ', num2str(correct)])
correct = compute(valdate, table);
pruneindex = sort(unique(nodes), 'descend');

for i = 1:length(pruneindex) - 1
    tatem = table;
    tatem(tatem(pruneindex(i)).sonnode) = struct('fathernode', [], 'dataset',...
        [], 'class', [], 'attribute', [], 'boundary', [], 'sonnode', []);
    tatem(pruneindex(i)).class = mode(tatem(pruneindex(i)).dataset(:, size(iris, 2)));
    notem = nodes;
    notem(tatem(pruneindex(i)).sonnode) = [];
    cortem = compute(valdate, tatem);
    chantem = channels;
    chantem(pruneindex(i), 1:16) = ['The ', num2str(pruneindex(i),...
        '%02d'), 'th class:', num2str(tatem(pruneindex(i)).class)];
    chantem(tatem(pruneindex(i)).sonnode, :) = [];
    if(cortem >= correct)
        nodes = notem;
        table = tatem;
        correct = cortem;
        channels = chantem;
    end
end

correct = compute(test, table);
disp(['accuracy of test after pruning: ', num2str(correct)])
drawt(nodes, channels);