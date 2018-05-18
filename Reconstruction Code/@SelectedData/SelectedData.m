classdef SelectedData < handle
    
    
   properties
        
       selectedGrains = Grain.empty;
       selectedClusters = DaughterCluster.empty;
       selectedOrientations = Orientation.empty;
    
   end
    
   methods
       
       function obj = SelectedData(data)
           
           if nargin==1
               
               if isa(data,'Grain')
                   
                   obj.selectedGrains = [obj.selectedGrains data];
                   
               elseif isa(data,'DaughterCluster')
                   
                   obj.selectedClusters = [obj.selectedClusters data];
                   
               else
                   
                   warning('Input selected data is neither Grain nor DaughterCluster type. No data added');
                   
               end
               
           end
           
       end
       
       function add_data(obj,data)
           
           if isa(data,'Grain')
                   
               obj.selectedGrains = [obj.selectedGrains data];
                   
           elseif isa(data,'DaughterCluster')
                   
               obj.selectedClusters = [obj.selectedClusters data];
                   
           else
                   
               warning('Input selected data is neither Grain nor DaughterCluster type. No data added');
                   
           end
           
       end
       
       function clear_grains(obj)
           
           obj.selectedGrains = Grain.empty;
           
       end
       
       function clear_clusters(obj)
           
           obj.selectedClusters = DaughterCluster.empty;
           
       end
       
       
   end
   
   methods (Static)
       
       IDs = point_select_IPF_data(I,reconstructor, type);
       
       [BW,IDs] = poly_select_IPF_data(I, reconstructor, type, show)
       
   end
    
    
end