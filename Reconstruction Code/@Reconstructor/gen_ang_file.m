function gen_ang_file(obj)

    clusterIDmat = obj.clusterIDmat;
    IQmat = obj.grainmap.IQmat;
    CImat = obj.grainmap.CImat;
    [r,c] = size(clusterIDmat);
    stepsize = obj.grainmap.scandata.stepsize;
    
    %Open file containing header information
    headerFID = fopen('austenite_header.txt','rt');
    
    %User inputs filename/location via uiputfile
    [FileName,PathName] = uiputfile('*.ang');
    fullpath = [PathName,FileName];
    angFID = fopen(fullpath,'wt+');
    
    %Copy header information into ANG file
    while ~feof(headerFID)
        
        line = fgetl(headerFID);
        fprintf(angFID,'%s\n',line);
        
    end
    
    fclose(headerFID);
    
    %Write data to ANG file
    DI = 1;
    fit = .2;
    phase = 0;
    for i=1:r
        for j=1:c
            
            clustID = clusterIDmat(i,j);
            currClust = obj.clusters([obj.clusters.ID]==clustID);
        
        if ~isempty(currClust)
            currEuler = currClust.clusterOCenter.euler;
            phi1 = currEuler(1);
            PHI = currEuler(2);
            phi2 = currEuler(3);
%         else
%             phi1 = 0;
%             PHI = 0;
%             phi2 = 0;
%         end
        
        xpos = (j-1)*stepsize;
        ypos = (i-1)*stepsize;
        
        
        fprintf(angFID,'  %7.5f   %7.5f   %7.5f      %7.5f      %7.5f %6.1f  %5.3f  %i      %i  %5.3f\n',phi1,PHI,phi2,xpos,ypos,IQmat(i,j),CImat(i,j),phase,DI,fit); 
        end
        
        
        end
    end
    
    fclose(angFID);

end