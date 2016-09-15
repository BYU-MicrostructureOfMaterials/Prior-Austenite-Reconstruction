% To note in documentation: passive rotation!

%NOTE: to save on computation time, I should make all access to properties
%private and write get functions that perform the calculation once a
%certain form of orientation is required, and then track when a calculation
%has been done already.

classdef Orientation < handle
    
    properties (SetAccess = protected)
        euler
        g
        RF
        quat
    end
    
    methods
        
        %Constructor method
        function obj = Orientation(rotation,type)
            if nargin > 0 
                switch type
                    case 'euler'
                        %test format of 'rotation' to ensure 3 euler angles
                        obj.euler = rotation;
                        phi1 = rotation(1);
                        PHI = rotation(2);
                        phi2 = rotation(3);
                        obj.g = obj.euler2gmat(phi1,PHI,phi2);
                        obj.quat = obj.gmat2quat(obj.g);
                    case 'gmat'
                        %test format of 'rotation'
                        obj.g = rotation;
                        obj.quat = obj.gmat2quat(rotation);
                        [phi1, PHI, phi2] = obj.gmat2euler(rotation);
                        obj.euler = [phi1 PHI phi2];
                    case 'RF'
                        %test format of 'rotation'
                    case 'quat'
                        %test format of 'rotation'
                        obj.quat = rotation(:);
                        obj.g = obj.quat2gmat(rotation);
                        [phi1,PHI,phi2] = obj.gmat2euler(obj.g);
                        obj.euler = [phi1 PHI phi2];
                end
            end
        end
        
    end
    
    methods (Static)
        
        gmat = euler2gmat(phi1,PHI,phi2)
        
        [phi1,PHI,phi2] = gmat2euler(gmat)
        
        quat = gmat2quat(gmat)
        
        gmat = quat2gmat(quat)
        
    end
    
    
    
end