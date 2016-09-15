function gen_reconstructed_confidence_mat(obj)

    gIDmat = obj.grainmap.gIDmat;
    clusterIDmat = obj.clusterIDmat;
    
    [nrows,ncols] = size(gIDmat);
    
    reconstructedConfidenceMat = zeros(nrows,ncols);
    clusterIDs = setdiff(unique(clusterIDmat),0);
    
    for i=1:length(clusterIDs)
        
       currClust = obj.clusters([obj.clusters.ID]==clusterIDs(i));
       memberGrains = currClust.memberGrains;
       includedNonMemberGrains = currClust.includedNonMemberGrains;
       
       grains = [memberGrains(:)' includedNonMemberGrains(:)'];

       
       for j=1:length(grains)
           
           currGrain = grains(j);
           
           if ~isempty(currGrain.phaseID) && ismember(currGrain.phaseID,obj.reconstructionPhases) && ~isempty(currGrain.newPhaseOrientations)
               
               grainPAO = [currGrain.newPhaseOrientations];
               grainPAQ = [grainPAO.quat];
               misos = q_min_distfun(currClust.clusterOCenter.quat',grainPAQ','cubic');
               
               if min(misos)<currClust.misoTolerance
               
                   reconstructedConfidenceMat(gIDmat==currGrain.OIMgid) = 1;
                    
               else
                   
                   shiftedMiso = min(misos)-currClust.misoTolerance;
                   val = (-1/(10*pi/180))*shiftedMiso + 1;
                   reconstructedConfidenceMat(gIDmat==currGrain.OIMgid) = val;
                   
               end
               
           end
           
       end
       
    end
    
    obj.reconstructedConfidenceMat = reconstructedConfidenceMat;

end