function find_neighbors(obj)

    disp('Populating grain neighbor lists');

    grainshold = obj.grains;

    parfor i=1:length(grainshold)
        currgrain = grainshold(i);
        currgrain.set_neighbors(obj);
        grainshold(i) = currgrain;
    end

    obj.grains = grainshold;
    
    disp('Done finding neighbors');
    
%     %Reallocate grains with neighbors into array where index=OIMgid
%     for i=1:length(grainshold)
%         currgrain = grainshold(i);
%         obj.grains(currgrain.OIMgid) = currgrain;
%     end

end