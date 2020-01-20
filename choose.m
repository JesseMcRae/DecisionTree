function [index, d] = choose(y)
% clc; clear; close all;
% load iris;
attrinum = size(y, 2) - 1; % attribute number of data set
datanum = size(y, 1); % data number of data set
class = unique(y(:, attrinum + 1)); % class number of data set
if length(class) == 1 % no more classification
    index = 0;
    d = 0;
else
    EntDSum = ones(1, length(class)); % information entropy per class
    for i = 1:length(class)
        pS = length(find(y(:, attrinum + 1) == class(i))) / datanum;
        if pS > 0 && pS < 1
            EntDSum(i) = -pS * log2(pS) - (1 - pS) * log2(1 - pS);
        end
    end

    Entropy = zeros(attrinum, length(class));
    deciboun = zeros(attrinum, length(class)); % boundary
    reference = zeros(attrinum, length(class));
    itemLength = zeros(1, 2);
    p = zeros(2, 2);
    for i = 1:attrinum
        itemList = sort(unique(y(:, i))); % sort data by attribute
        pNum = length(itemList);
        if pNum > 1
            % average of two close data, choose boundry from it
            average = zeros(pNum - 1, 1);
            difference = zeros(pNum - 1, 1); % difference of two close data
            EntD = zeros(pNum - 1, 2);
            for j = 1:length(class)
                a = find(y(:, attrinum + 1) == class(j));
                for k = 1:pNum - 1
                    average(k) = (itemList(k) + itemList(k + 1)) / 2;
                    difference(k) = itemList(k + 1) - itemList(k);
                    Dbig = find(y(:, i) >= average(k));
                    Dlittle = setdiff(1:datanum, Dbig);
                    itemLength(1) = length(Dbig);
                    itemLength(2) = datanum - itemLength(1);
                    p(1, 1) = length(intersect(a, Dbig)) / itemLength(1);
                    p(1, 2) = length(intersect(a, Dlittle)) / itemLength(2);
                    p(2, :) = ones(1, 2) - p(1, :);
                    for l = 1:2
                        if isempty(find(p(:, l) == 0, 1))
                            EntD(k, l) = -p(:, l)' * log2(p(:, l));
                        end
                    end
                end
                EnSum = EntD * itemLength' / datanum;
                Entropy(i, j) = min(EnSum);
                pos = find(EnSum == min(EnSum));
                if length(pos) == 1
                    deciboun(i, j) = average(pos);
                    reference(i, j) = difference(pos);
                else
                    Entropy(i, j) = 1;
                    deciboun(i, j) = 0;
                end
            end
        else
            Entropy(i, :) = ones(1, length(class));
            deciboun(i, :) = y(1, i) * zeros(1, length(class));
        end
    end

    Gain = ones(attrinum, 1) * EntDSum - Entropy;
    reference = reference ./ deciboun;
    [i, j] = find(Gain == max(max(Gain)));
    if length(i) == 1
        index = i;
        d = deciboun(i, j);
    else
        [IndexM, IndexB] = find(reference == max(unique(reference(i, j))));
        index = intersect(IndexM, i);
        d = deciboun(index, intersect(IndexB, j));
        d = unique(d);
    end
end
return;
end