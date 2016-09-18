function recalc_PA_orientation(obj,nRuns)

grains = [[obj.memberGrains] [obj.includedNonMemberGrains]];
startAvgO = obj.clusterOCenter;
startAvgQ = startAvgO.quat;

if length(obj.parentPhaseOrientations)~=length(obj.memberGrains)
    error('Cluster member grains and respective possible parent orietntaions do not match');
end

for i=1:nRuns
    
    %This method will group all the member grains into their respective
    %variant groups, then calculate an average for that variant. The new PA
    %orientation is found using the inverse OR to produce another set of
    %possible parents, from which are chosen the ones closest to the
    %starting PA orientation, then averaged. The process repeats the set
    %number of times.
    
    
    
    
end

end