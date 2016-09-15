classdef Trio < handle
    
    properties
        
        PAorientations@Orientation
        avgOrientation@Orientation
        parentTripletIDs %this var name needs to change
        
        misoSum
        
    end
    
    
    methods
        
        %Constructor
        function obj = Trio(PAorientations,tripletIDs)
            if nargin > 0
                
                if length(PAorientations)~= 3 || ~isa(PAorientations,'Orientation')
                    error('Error creating instance of Triplet class. Check input length and type');
                end
                
                obj.parentTripletIDs = tripletIDs(:);
                obj.PAorientations = PAorientations;
                obj.trio_average();
                
            end
        end
        
        %Plot parent triplet
        
    end
    
    methods (Access = private)
       
        %Average orientations into one 
        function trio_average(obj)
            O = obj.PAorientations;
            quats = [O.quat];
            
            load quat_cubic_symops;
            
            [cluster_miso_sum, rotated_quats,avgQ] = q_average_orientation(quats,quat_cubic_symops); %THIS ASSUMES CUBIC SYMMETRY, NEEDS TO BE GENERALIZED
            
            avgO = Orientation(avgQ,'quat');
            obj.avgOrientation = avgO;
            
            %Calc sum of trio misorientations from average
            misos = q_min_distfun(avgQ',quats','cubic');
            
            obj.misoSum = sum(misos);
            
        end
        
    end
    
end