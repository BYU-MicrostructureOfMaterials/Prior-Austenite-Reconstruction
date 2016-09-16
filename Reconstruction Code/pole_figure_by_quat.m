function [] = pole_figure_by_quat(quats,phase_vect,phasenum,markerstring,mark_size,plotfig)

if isempty(quats)
    warning('Input quaternion array is empty');
    return
end

%create pole figure data
count = 1; %not all phases are plotted, and so some lines in the .ang file are skipped
for i=1:length(quats(:,1))
    if isempty(phase_vect) || phase_vect(i)==phasenum%Choose which phase is being plotted
        
        %get Q from sample to crystal
        normtol = 1e-8;
        StoC = quats(i,:);
        if abs(norm(StoC))>1+normtol
            error('Qaternion is not a unit quaternion');
        end
        CtoS = [-StoC(1) -StoC(2) -StoC(3) StoC(4)];%must be unit quat!

        %define crystal basis in global csys by using inverse of StoC  
        cx_step = quatLmult(CtoS,[1 0 0 0]);
        cy_step = quatLmult(CtoS,[0 1 0 0]);
        cz_step = quatLmult(CtoS,[0 0 1 0]);
        
        cx_step2 = quatLmult(cx_step,StoC);
        cy_step2 = quatLmult(cy_step,StoC);
        cz_step2 = quatLmult(cz_step,StoC);
        
        cx = cx_step2(1:3);
        cy = cy_step2(1:3);
        cz = cz_step2(1:3);

        %generate data for 3d pole figure
        cxu(count) = cx(1); cxv(count) = cx(2); cxw(count) = cx(3); %crystal x axis' global (u,v,w) components
        cyu(count) = cy(1); cyv(count) = cy(2); cyw(count) = cy(3); %crystal y axis' global (u,v,w) components
        czu(count) = cz(1); czv(count) = cz(2); czw(count) = cz(3); %crystal z axis' global (u,v,w) components


        % generate data for 2d pole figure
        tol = 1e-10; %math creates very small numbers, some introducing false negatives
        if abs(cx(3))<tol, cx(3)=0; end
        if abs(cy(3))<tol, cy(3)=0; end
        if abs(cz(3))<tol, cz(3)=0; end

        %if z component of any vector is negative, plot the negative of
        %that axis instead so it intersects with the upper hemisphere in
        %the pole figure
        if cx(3)<0, cx=-1*cx; end
        if cy(3)<0, cy=-1*cy; end
        if cz(3)<0, cz=-1*cz; end

        %find stereographic projection of each axis and plot
        [cxX(count), cxY(count)] = stereographic_projection(cx); %crystal x axis' (X,Y) components for pole figure plot
        [cyX(count), cyY(count)] = stereographic_projection(cy); %crystal y axis' (X,Y) components for pole figure plot
        [czX(count), czY(count)] = stereographic_projection(cz); %crystal z axis' (X,Y) components for pole figure plot
        
        count = count + 1;
    end
%     disp(['Processing line ', num2str(i), ' of .ang file']);
end

%create pole figure plot
fig1 = figure(plotfig);
hold on;
axis equal;
whitebg(fig1,'white');
theta = 0:.001:2*pi;
x = cos(theta);
y = sin(theta);
plot(x,y,'k');
x = -1:.001:1;
y = zeros(1,length(x));
plot(x,y,'k');
y = -1:.001:1;
x = zeros(1,length(y));
plot(x,y,'k');

try
plot(-cxY,cxX,markerstring,'MarkerSize',mark_size); %Rotate so that X is up and Y is left to match OIM analysis
plot(-cyY,cyX,markerstring,'MarkerSize',mark_size);
plot(-czY,czX,markerstring,'MarkerSize',mark_size);
% plot(-cxY,cxX,'bd','MarkerSize',mark_size); 
% plot(-cyY,cyX,'r*','MarkerSize',mark_size);
% plot(-czY,czX,'g+','MarkerSize',mark_size);
catch
    error('error');
end

% %create 3d pole figure plot
% fig2 = figure(2);
% hold on;
% whitebg(fig2,[.5 .5 .5]);
% [X, Y, Z] = sphere(30);
% rad = .99;  %set to be slightly less than 1 so as to show the points plotted on the sphere.
% h =surf(rad*X,rad*Y,rad*Z);
% axis equal;
% set(h,'EdgeColor','white');
% set(h,'FaceColor','white');
% 
% x = .75:.001:1.5;
% y = zeros(length(x));
% z = zeros(length(x));
% plot3(x,y,z,'b');
% 
% y = .75:.001:1.5;
% x = zeros(length(y));
% z = zeros(length(y));
% plot3(x,y,z,'r');
% 
% z = .75:.001:1.5;
% x = zeros(length(z));
% y = zeros(length(z));
% plot3(x,y,z,'g');
% 
% plot3(cxu,cxv,cxw,markerstring,'MarkerSize',mark_size);
% plot3(cyu,cyv,cyw,markerstring,'MarkerSize',mark_size);
% plot3(czu,czv,czw,markerstring,'MarkerSize',mark_size);
% % plot3(cxu,cxv,cxw,'bd','MarkerSize',mark_size);
% % plot3(cyu,cyv,cyw,'r*','MarkerSize',mark_size);
% % plot3(czu,czv,czw,'g+','MarkerSize',mark_size);
% xlabel('X');
% ylabel('Y');
% zlabel('Z');



end
