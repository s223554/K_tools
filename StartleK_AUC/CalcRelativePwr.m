RelativePower = zeros(5,size(p,2));
    for h = 1: size(p,2)                %size(p,2) time points
    for m = 1: size(p,1)                %frequence interval list
        %Extracts the data from the power array, binning it into whichever
        %frequencies you prefer
        if f(m) <= 32
            if f(m) > 13                %f() is the frequence list
                RelativePower(5,h) = RelativePower(5,h) + p(m,h);
            elseif f(m) > 8
                RelativePower(4,h) = RelativePower(4,h) + p(m,h);
            elseif f(m) > 4
                RelativePower(3,h) = RelativePower(3,h) + p(m,h);
            elseif f(m) > 3
                RelativePower(2,h) = RelativePower(2,h) + p(m,h);
            elseif f(m) > 0.5
                RelativePower(1,h) = RelativePower(1,h) + p(m,h);
            end
        end
    end
    end
    %%
    for normalizer = 1:size(RelativePower,2)
        total = sum(RelativePower(:,normalizer));
        for j = 1:size(RelativePower,1) 
            RelativePower(j,normalizer) = RelativePower(j,normalizer)/total;
        end
    end
    RelativePower = transpose(RelativePower);