classdef Triplet < handle
    
    properties
    
        grains
        parentPhaseTrios
        grainMisoSum
        
    end
    
    methods
        
        %Constructor
        function obj = Triplet(grainarray)
            if nargin > 0
                
                if length(grainarray)~= 3 || ~isa(grainarray,'Grain')
                    error('Error creating instance of Triplet class. Check input length and type');
                end
                
                obj.grains = grainarray;
                
                %Calculate misorientation sum
                orientations = [grainarray.orientation];
                quats = [orientations.quat];
                totMiso = 0;
                for i=1:3
                    misos = q_min_distfun(quats(:,i)',quats','cubic'); %THIS NEEDS TO BE UPDATAED TO CHOOSE SYMMETRY TYPE FOR DISTANCE CALC FROM THE SYMMETRIES OF THE GRAINS
                    totMiso = totMiso + real(sum(misos));
                end
                
                obj.grainMisoSum = totMiso;
                
            end
        end
        
        %Calc trios
        calc_trios(obj,cutoff)
        
        %Plot IPF map of triplet's member grains
        
    end
    
end