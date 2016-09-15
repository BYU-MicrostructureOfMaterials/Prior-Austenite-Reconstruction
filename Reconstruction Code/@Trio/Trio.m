classdef Trio < handle
    
    properties
        
        PAorientations@Orientation
        avgOrientation@Orientation
        tripletID
        tripletGrainIDs
        
        misoSum
        maxMiso
        
    end
    
    
    methods
        
        %Constructor
        function obj = Trio(PAorientations,tripletGrainIDs,tripletID,maxMiso)
            if nargin > 0
                
                if length(PAorientations)~= 3 || ~isa(PAorientations,'Orientation')
                    error('Error creating instance of Triplet class. Check input length and type');
                end
                
                obj.tripletID = tripletID;
                obj.tripletGrainIDs = tripletGrainIDs(:);
                obj.PAorientations = PAorientations;
                obj.maxMiso = maxMiso;
                obj.trio_average();
                
            end
        end
        
    end
    
    methods (Access = private)
       
        %Average orientations into one 
        function trio_average(obj)
            O = obj.PAorientations;
            quats = [O.quat];
            
            load quat_cubic_symops;
            
            [rotated_quats, avgQ] = q_average_orientations_in_window(quats,quats(:,1),obj.maxMiso,quat_cubic_symops);
            
            avgO = Orientation(avgQ,'quat');
            obj.avgOrientation = avgO;
            
            %Calc sum of trio misorientations from average
            misos = q_min_distfun(avgQ',quats','cubic');
            
            obj.misoSum = sum(misos);
            
        end
        
    end
    
end