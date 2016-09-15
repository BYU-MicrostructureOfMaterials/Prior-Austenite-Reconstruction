classdef DaughterCluster < handle
   
    properties
        
        startTrio
        
        memberGrains@Grain = Grain.empty;
        includedNonMemberGrains@Grain = Grain.empty;
        inactiveGrains@Grain = Grain.empty;
        
        parentPhaseOrientations  %This variable name is misleading and needs to be changed
        clusterOCenter
        misoTolerance = 5.2*pi/180; %5.2*pi/180; %6.8*(pi/180); %Max tolerance should not exceed half the minimum misorientation between theoretical variant orientations for the OR used in the reconstruction
        
        clusterIPFmap
        scanLocations
        
    end
        
    properties %(SetAccess = private)
        
        OR
        theoreticalVariants@Orientation
        existingVariants
        variantGIDs %Cell array, one for each variant, with list of member grain GIDs
        ID@int32
        
    end
    
    methods
        
        %Constructor
        function obj = DaughterCluster(trio,OR,misoTol)
            if nargin > 0
                
                obj.startTrio = trio;
                obj.clusterOCenter = trio.avgOrientation;
                obj.OR = OR;
                
                if nargin==3
                    obj.misoTolerance = misoTol;
                end
                
            end
        end
        
        %Grow cluster
        grow_cluster(obj,reconstructor)
        
        expand_cluster_by_CPP(obj,reconstructor,miso,includedPoolIDs)
        
        expand_cluster_by_NN(obj,reconstructor,includedPoolIDs)
        
        expand_cluster_by_widen_tol(obj,reconstructor,newTol,includedPoolIDS)
        
        %Calc cluster meta data
        calc_metadata(obj,gIDmat,filledtype,updateLocationsOnly)
        
        %Plot cluster IPF map, either for collection of grains or for cluster average
        genClusterIPFmap(obj, IDmat, type, filledtype,fignum)
        
        %Local cluster cleanup methods-------------------------------------
        
        fill_cluster(obj,gIDmat)
        
        function setClusterID(obj,idval)
            obj.ID = idval;
        end
        
    end
    
end