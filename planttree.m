function [table, nodes, ChannelName] = planttree(y)
% clc; clear; close all;
% load iris;
table = struct('fathernode', [], 'dataset', [], 'class', [],...
    'attribute', [], 'boundary', [], 'sonnode', []);
n = 100;
j = 1;
[divind, dipoint] = choose(y);
table(j).fathernode = 0;
nodes(j) = table(j).fathernode;
table(j).attribute = divind;
table(j).boundary = dipoint;
ChannelName(j, 1:16) = ['x', num2str(table(j).attribute), '<',...
    num2str(table(j).boundary,'%4.2f'), '  ', 'x',...
    num2str(table(j).attribute), '>',...
    num2str(table(j).boundary,'%4.2f')];
table(j).dataset = y;
j = j + 1;
i = 1;

while i < j && j <= n
    if table(i).boundary == 0
        table(i).class = mode(table(i).dataset(:, size(y, 2))); % give node class
        ChannelName(i, 1:16) = ['The ', num2str(i,'%02d'), 'th class:', num2str(table(i).class)];
        table(i).sonnode = zeros(1, 2);
    else
        table(i).sonnode = [j, j + 1];
        table(i).class = 0;
        littleson = find(table(i).dataset(:, table(i).attribute) < table(i).boundary);
        elderson = find(table(i).dataset(:, table(i).attribute) >= table(i).boundary);
        
        table(j).dataset = table(i).dataset(littleson, :);
        table(j).fathernode = i;
        nodes(j) = table(j).fathernode;
        [in1, de1] = choose(table(j).dataset);
        table(j).attribute = in1;
        table(j).boundary = de1;
        ChannelName(j, 1:16) = ['x', num2str(table(j).attribute), '<',...
            num2str(table(j).boundary,'%4.2f'), '  ', 'x',...
            num2str(table(j).attribute), '>',...
            num2str(table(j).boundary,'%4.2f')];
        j = j + 1;
                
        table(j).dataset = table(i).dataset(elderson, :);
        table(j).fathernode = i;
        nodes(j) = table(j).fathernode;
        [in2, de2] = choose(table(j).dataset);
        table(j).attribute = in2;
        table(j).boundary = de2;
        ChannelName(j, 1:16) = ['x', num2str(table(j).attribute), '<',...
            num2str(table(j).boundary,'%4.2f'), '  ', 'x',...
            num2str(table(j).attribute), '>',...
            num2str(table(j).boundary,'%4.2f')];
        j = j + 1;
    end
    i = i + 1;
end
% drawt(nodes, ChannelName);
return;
end