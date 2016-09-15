function calc_trios(obj,cutoff)

    IDs = [obj.grains.OIMgid];
    AgrainPO = obj.grains(1).newPhaseOrientations;
    BgrainPO = obj.grains(2).newPhaseOrientations;
    CgrainPO = obj.grains(3).newPhaseOrientations;

    AgrainPOq = [AgrainPO.quat];
    BgrainPOq = [BgrainPO.quat];
    CgrainPOq = [CgrainPO.quat];

    trioCount = 1;
    trios = Trio.empty;
    for i=1:length(AgrainPO)

        currAPO = AgrainPO(i);
        AtoBmisos = q_min_distfun(AgrainPOq(:,i)',BgrainPOq','cubic');

        passedInds = AtoBmisos<cutoff;
        passedBPO = BgrainPO(passedInds);
        passedBq = BgrainPOq(:,passedInds);

        for j=1:length(passedBPO)

            currBPO = passedBPO(j);
            BtoCmisos = q_min_distfun(passedBq(:,j)',CgrainPOq','cubic');

            passedInds = BtoCmisos<cutoff;
            passedCPO = CgrainPO(passedInds);
            passedCq = CgrainPOq(:,passedInds);

            for k=1:length(passedCPO)
                if q_min_distfun(passedCq(:,k)',AgrainPOq(:,i)','cubic')<cutoff;
                    %Create trio object
                    currCPO = passedCPO(k);
                    trios(trioCount) = Trio([currAPO currBPO currCPO],IDs,obj.ID,cutoff);
                    trioCount = trioCount + 1;
                end
            end 
        end
    end

    obj.parentPhaseTrios = trios;

end