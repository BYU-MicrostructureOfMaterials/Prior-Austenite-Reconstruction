function set_transformationPhase(obj,OR,type)

    %Test inputs for type <-----------

    obj.OR = OR;
    obj.graintype = type;

    switch OR
        case 'KS'

            if strcmp(type,'daughter')
                load q_KS_OR_alpha_to_gamma;
                q_trans = q_KS_OR_alpha_to_gamma;
            else
                load q_KS_OR_gamma_to_alpha;
                q_trans = q_KS_OR_gamma_to_alpha;
            end

            for i=1:24

                quat = quatLmult(q_trans(:,i),obj.orientation.quat);

                newPhaseO(i) = Orientation(quat,'quat');
            end

        case 'NW'

            if strcmp(type,'daughter')
                load q_NW_OR_alpha_to_gamma
                q_trans = q_NW_OR_alpha_to_gamma;
            else
                load q_NW_OR_gamma_to_alpha;
                q_trans = q_NW_OR_gamma_to_alpha;
            end

            for i=1:12
                quat = quatLmult(q_trans(:,i),obj.orientation.quat);
                newPhaseO(i) = Orientation(quat,'quat');
            end

        case 'none'

            warning('No OR set for daughter grain. No parents calculated');

    end

    obj.newPhaseOrientations = newPhaseO;

end