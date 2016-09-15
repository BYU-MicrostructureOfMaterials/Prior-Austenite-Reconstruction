
classdef Scandata < handle
   
    properties (SetAccess = private)
        
        %Scan data
        pointdata
        graindata
        
        %Scan metadata
        numScanpoints = [];
        numGrains = [];
        stepsize = [];
        phasekey@table
        minx
        miny
        maxx
        maxy
        
    end
    
    properties (Access = private)
        datalocked@logical = false;
    end
    
    methods
        
        %Constructor
        function obj = Scandata(grainfiletype1,grainfiletype2)
                
            if nargin > 0
                
                %Test inputs
                if ~ischar(grainfiletype1) || ~ischar(grainfiletype2)
                    error('Input to Scandata constructor must be 2 filenames of type char');
                end
                
                %Read in file data
                w = waitbar(0,'Reading Grain File Type I (Step 1/3)...');
                obj.read_grain_file_type_1(grainfiletype1);
                waitbar(1/3,w,'Reading Grain File Type II (Step 2/3)...')
                obj.read_grain_file_type_2(grainfiletype2);
                waitbar(2/3,w,'Reading metadata (Step 3/3)...')
                obj.calc_metadata();
                waitbar(3/3,w,'Finished Reading Data')
                close(w)
            end
            
        end
        
        %Set scan metadata
        stepsize = calc_metadata(obj)

        %Add data to pointdata (only available if data is not locked)
            %Check phasekey, add row if new data
        
        %Add data to graindata (only available if data is not locked)
            %Check phasekey, add row if new data
        
    end
    
    methods (Access = protected)
        
        %Read in grainfile type 1 data, set numScanpoints
        read_grain_file_type_1(obj,filename)
        
        %Read in grainfile type 2 data, set phasekey and numGrains
        read_grain_file_type_2(obj,filename)
        
    end
    
end