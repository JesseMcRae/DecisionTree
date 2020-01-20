function [correct]=compute(test,table)
rinum=0;

for i=1:length(test)
    j=1;
    while(table(j).class==0)
        if(test(i,table(j).attribute)<table(j).boundary)
            j=table(j).sonnode(1);
        else
            j=table(j).sonnode(2);
        end
    end
    if(table(j).class==test(i,size(test,2)))
        rinum=rinum+1;
    end
end

correct=rinum/length(test);
return;
end