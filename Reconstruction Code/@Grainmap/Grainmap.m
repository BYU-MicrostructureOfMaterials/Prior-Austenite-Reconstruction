
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
        function obj = Grainmap(scandata,findneighbors)
            
            if nargin == 0
                
                phaseID = [];
                phasename = {};
                
                obj.phasekey = table(phaseID,phasename);
                
                
            else
                if nargin == 1
                    findneighbors = 0;
                end
                if findneighbors
                    steps = 4;
                else
                    steps = 3;
                end
                
                if ~isa(scandata,'Scandata');
                    error('Grainmap constructor input must be a Scandata object');
                end
                
                obj.scandata = scandata;
                
                w = waitbar(0,['Creating Grain Objects (Step 1/' num2str(steps) ') ...']);
                obj.import_scandata(scandata);
                waitbar(1/steps,w,['Generating Grain and Phase ID matrices (Step 2/' num2str(steps) ') ...'])
                obj.gen_IDmats;
                waitbar(2/steps,w,['Generating Grain IPF Map (Step 3/' num2str(steps) ') ...'])
                obj.genIPFmap;
                if findneighbors
                    waitbar(3/steps,w,'Finding Neighboring Grains (Step 4/4) ...')
                    obj.find_neighbors;
                end
                waitbar(1,w,'Grain Map Creation Finished')
                close(w)
            end
            
        end
        
        %Add grain to grainmap table
            %Check grain for overlap with existing grains (in map, or IDs)
            %Check against phasekey to check phasename/ID and grain type. 
                %Add if not already part of table
            %Updata min/max x and y position numbers and stepsize in map
        
        %Gen grain IPF map
        genIPFmap(obj)
        
        superimposedIPF(obj,type)
        
        
        %Get polefigure of grain data (gen new unless data is locked)
        
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