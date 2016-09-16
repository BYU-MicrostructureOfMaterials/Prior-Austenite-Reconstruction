
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
                
                steps = 4;
                w = waitbar(0,['Creating Grainmap Object (Step 1/' num2str(steps) ') ...']);
                obj.import_scandata(scandata);
                
                waitbar(1/steps,w,['Generating grain ID matrices (Step 2/' num2str(steps) ') ...']);
                obj.gen_IDmats;
                
                waitbar(2/steps,w,['Generaging grain IPF map (Step 3/' num2str(steps) ') ...']);
                obj.genIPFmap;
                
                waitbar(3/steps,w,['Finding grain neighbors (Step 4/' num2str(steps) ') ...']);
                obj.find_neighbors;
                
                waitbar(1,w,'Finished Reconstruction')
                close(w)

                
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