classdef IPFmap < handle
    
    properties
        IPFimage
        IDmat
    end
    
    methods
        
        %Constructor
        function obj = IPFmap(IDmat,Omap) %IDmat is a matrix of IDs, and objects must be containers.Map of orientations with keys matching IDs
            
            if ~isa(Omap,'containers.Map')     
                error('Input to IPFmap constructor must be matrix of IDs and containers.Map object, where IDs in matrix correspond with map keys');
            end
            
            obj.IDmat = IDmat;
            [r,c] = size(IDmat);
            image = zeros(r,c,3);
            obj.IPFimage = image;
            
            obj.add_data(Omap);
              
        end
        
        %Add data to IPFmap
        add_data(obj,Omap)
        
    end
    
    methods (Static)
        
        %Generate IPF colors from orientations
        rgb = IPF_rgbcalc(mat)
        
    end
    
    
end