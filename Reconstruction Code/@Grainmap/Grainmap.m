
classdef Grainmap < handle
    
    properties %(SetAccess = private)
        
        scandata
        grains
        
        gIDmat@int32
        phaseIDmat@int32
        IQmat
        CImat
        phasekey@table
        
        grainIPFmap
        polefigure
    end
    
    properties (Access = private)
        minx
        miny
        maxx
        maxy
        stepsize
        datalocked@logical = false;
        finalIPF@logical = false;
    end
    
    methods
        %Constructor
        function obj = Grainmap(scandata)
            
            if nargin == 0
                
                phaseID = [];
                phasename = {};
                
                obj.phasekey = table(phaseID,phasename);
                
            else
                
                if ~isa(scandata,'Scandata');
                    error('Grainmap constructor input must be a Scandata object');
                end
                
                obj.scandata = scandata;
                obj.import_scandata(scandata);
                
                obj.gen_IDmats;
                obj.genIPFmap;
                
            end
            
        end
        
        %Gen grain IPF map
        genIPFmap(obj)
        
        %Run each grain's find neighbors function 
        find_neighbors(obj)
        
    end
    
    methods (Access = private)
        
        %Import scandata
        import_scandata(obj,scandata)
          
        %Generate gIDmat and phasemat, lock data
        gen_IDmats(obj)
        
    end
    
    methods (Static)
        
        %Get pixel location from scan location
        function [pixelx,pixely] = pixel_loc(x,y,minx,miny,stepsize)
            
            pixelx = int32(x./stepsize)-int32(minx/stepsize)+1;
            pixely = int32(y./stepsize)-int32(miny/stepsize)+1;
            
        end
        
    end
    
end