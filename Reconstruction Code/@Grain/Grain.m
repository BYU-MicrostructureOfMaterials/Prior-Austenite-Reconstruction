
classdef Grain < handle
    
    properties %(SetAccess = protected)
        orientation@Orientation
        phasename@char
        phaseID@int32
        OIMgid@int32
        neighborIDs
        scanpoints@table
        
        graintype@char = 'none'
        OR@char = 'none'
        newPhaseOrientations
    end
    
    methods
        
        %Constructor    CHECK INPUTS FOR EACH CONDITION!
        function obj = Grain(OIMgid,orientation,phaseID,phasename,scanpoints)
            if nargin > 0
                if nargin == 1
                    
                    obj.OIMgid = OIMgid;
                    
                elseif nargin == 4
                
                    obj.OIMgid = OIMgid;
                    obj.orientation = orientation;
                    obj.phaseID = phaseID;
                    obj.phasename = phasename;
                
                elseif nargin == 5
                    
                    obj.OIMgid = OIMgid;
                    obj.orientation = orientation;
                    obj.phaseID = phaseID;
                    obj.phasename = phasename;
                    obj.scanpoints = scanpoints;
                    
                end
            
            end
        end
        
        %Set neighbors from ID matrix and grainmap object
        function set_neighbors(obj,grainmap)
            
            ID = obj.OIMgid;
            IDmat = grainmap.gIDmat;
            neighborGIDs = obj.get_neighbors(ID,IDmat);
            
            obj.neighborIDs = neighborGIDs;
            
        end
        
        %Calculate parent or daughter orientations from given OR  THIS WILL
        %NEED TO BE GENERALIZED TO ACCEPT ANY OR, FOR MULTIPLE POSSIBLE
        %PHASES
        set_transformationPhase(obj,OR,type)
        
        %Set phasename from phasename/number key
        
        %Set scanpoint data if not set
        
        %Plot individual grain IPFmap
        individual_grain_IPFmap(obj, gIDmat)
  
    end
    
    methods (Static)
        
        neighbor_ids = get_neighbors(choice_id,IDmat);
    
    end
    
end