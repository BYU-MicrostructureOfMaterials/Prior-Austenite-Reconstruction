function varargout = HandReconstruction(varargin)
% HANDRECONSTRUCTION MATLAB code for HandReconstruction.fig
%      HANDRECONSTRUCTION, by itself, creates a new HANDRECONSTRUCTION or raises the existing
%      singleton*.
%
%      H = HANDRECONSTRUCTION returns the handle to a new HANDRECONSTRUCTION or the handle to
%      the existing singleton*.
%
%      HANDRECONSTRUCTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HANDRECONSTRUCTION.M with the given input arguments.
%
%      HANDRECONSTRUCTION('Property','Value',...) creates a new HANDRECONSTRUCTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HandReconstruction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HandReconstruction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HandReconstruction

% Last Modified by GUIDE v2.5 17-May-2018 16:54:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HandReconstruction_OpeningFcn, ...
                   'gui_OutputFcn',  @HandReconstruction_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HandReconstruction is made visible.
function HandReconstruction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HandReconstruction (see VARARGIN)

% Choose default command line output for HandReconstruction
handles.output = hObject;
handles.grainmap = varargin{1};
handles.output = hObject;
handles.grainmap = varargin{1};
% axes(handles.axes3);
x = length(handles.grainmap.grainIPFmap.IPFimage(:,1,1));
y = length(handles.grainmap.grainIPFmap.IPFimage(1,:,1));
black = zeros(x,y);
imshow(black,'Parent',handles.axes3);
handles.black = black;
% axes(handles.axes2);
imshow(handles.grainmap.grainIPFmap.IPFimage, 'Parent', handles.axes2);
%Indexes Initialization
handles.maxGrownIndex = -1;
handles.grownClusterIndex = 1;
handles.finalClusterIndex = 1;
handles.maxFinalIndex = -1;
handles.finalClusters = [];
handles.grownClusters = [];
handles.trimmedClusters = [];
handles.overlappingIDs = [];
handles.Profile = [];
%Set flags
handles.updateMap = true;
handles.isGrown = false;
handles.isReconstructed = false;
%UPDATE DEFAULT CONSTRUCTOR
handles.reconstructor = Reconstructor(handles.grainmap,'KS',0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HandReconstruction wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HandReconstruction_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes on button press in growClusters.
function growClusters_Callback(hObject, eventdata, handles)
% hObject    handle to growClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[BW,IDs] = SelectedData.poly_select_IPF_data(handles.axes2,handles.reconstructor,'daughterGrains');
w = waitbar(1/4,['Finding triplets (step 1 / 4) . . .']);
handles.reconstructor.find_triplets(IDs);
waitbar(2/4,w,['Finding trios (step 2 / 4) . . .']);
handles.reconstructor.find_trios;
waitbar(3/4,w,['Growing clusters (step 3 / 4) . . .']);
handles.reconstructor.grow_clusters_from_trios;
waitbar(4/4,w,['Generating cluster IPF maps (step 4 / 4) . . .']);
for i=1:length(handles.reconstructor.clusters)
    currClust = handles.reconstructor.clusters(i);
    currClust.genClusterIPFmap(handles.grainmap.gIDmat,'parentAverage','filled');
end

if(handles.mapView2.String{handles.mapView2.Value} == "Cycle Grown Clusters")
%     axes(handles.axes3)
    handles.grownClusterIndex = 1;
    set(handles.indexDisplay, 'String', handles.grownClusterIndex);
    imshow(handles.reconstructor.clusters(1).clusterIPFmap.IPFimage,'Parent',handles.axes3)
end
close(w);
handles.grownClusters = handles.reconstructor.clusters;
handles.maxGrownIndex = length(handles.reconstructor.clusters);
handles.isGrown = true;
handles.numVariantsDisp.String = sum(handles.grownClusters(handles.grownClusterIndex).existingVariants);
guidata(hObject,handles)



% --- Executes on button press in leftClusterCycle.
function leftClusterCycle_Callback(hObject, eventdata, handles)
% hObject    handle to leftClusterCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% axes(handles.axes3)
if(handles.mapView2.String{handles.mapView2.Value} == "Cycle Grown Clusters")
    if ~isempty(handles.grownClusters)
        handles.grownClusterIndex = handles.grownClusterIndex - 1;
        if(handles.maxGrownIndex == - 1)
            handles.grownClusterIndex = 1;
        elseif (handles.grownClusterIndex == 0) 
            handles.grownClusterIndex = handles.maxGrownIndex;
        end
        imshow(handles.grownClusters(handles.grownClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3)
        set(handles.indexDisplay, 'String', handles.grownClusterIndex);
        handles.numVariantsDisp.String = sum(handles.grownClusters(handles.grownClusterIndex).existingVariants); 
    end
elseif(handles.mapView2.String{handles.mapView2.Value} == "Cycle Reconstructed Clusters")
      if ~isempty(handles.finalClusters)
        handles.finalClusterIndex = handles.finalClusterIndex - 1;
        if(handles.maxFinalIndex == - 1)
            handles.finalClusterIndex = 1;
        elseif (handles.finalClusterIndex == 0) 
            handles.finalClusterIndex = handles.maxFinalIndex;
        end
        imshow(handles.finalClusters(handles.finalClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3)
        set(handles.indexDisplay, 'String', handles.finalClusterIndex);
        handles.numVariantsDisp.String = sum(handles.finalClusters(handles.finalClusterIndex).existingVariants);
      end
elseif(handles.mapView2.String{handles.mapView2.Value} == "Reconstructed IPF Map") 
      handles.numVariantsDisp.String = 'N/A';
end 
guidata(hObject,handles)

% --- Executes on button press in rightClusterCycle.
function rightClusterCycle_Callback(hObject, eventdata, handles)
% hObject    handle to rightClusterCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes3)
if(handles.mapView2.String{handles.mapView2.Value} == "Cycle Grown Clusters")
     if ~isempty(handles.grownClusters)
        handles.grownClusterIndex = handles.grownClusterIndex + 1;
        if (handles.grownClusterIndex > handles.maxGrownIndex) 
            handles.grownClusterIndex = 1;
        end
        imshow(handles.grownClusters(handles.grownClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3)
        set(handles.indexDisplay, 'String', handles.grownClusterIndex);
        handles.numVariantsDisp.String = sum(handles.grownClusters(handles.grownClusterIndex).existingVariants); 
     end 
     
elseif(handles.mapView2.String{handles.mapView2.Value} == "Cycle Reconstructed Clusters")
    if ~isempty(handles.finalClusters)
           handles.finalClusterIndex = handles.finalClusterIndex + 1;
        if (handles.finalClusterIndex > handles.maxFinalIndex) 
            handles.finalClusterIndex = 1;
        end
    imshow(handles.finalClusters(handles.finalClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3)
    set(handles.indexDisplay, 'String', handles.finalClusterIndex);
    handles.numVariantsDisp.String = sum(handles.finalClusters(handles.finalClusterIndex).existingVariants);
    end 
elseif(handles.mapView2.String{handles.mapView2.Value} == "Reconstructed IPF Map") 
    handles.numVariantsDisp.String = 'N/A';
end 
guidata(hObject,handles)

% --- Executes on button press in addCluster.
function addCluster_Callback(hObject, eventdata, handles)
% hObject    handle to addCluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.mapView2.String{handles.mapView2.Value} == "Cycle Grown Clusters")
    %NEED TO UPDATE TO HANDLE DUPLICATE CASES
    if ~isempty(handles.reconstructor.clusters)
        repeatClusters = zeros(length(handles.finalClusters));
        for i = 1:length(handles.finalClusters)
            repeatClusters(i) = (handles.finalClusters(i) == handles.grownClusters(handles.grownClusterIndex));
        end
        if (~any(repeatClusters))
        handles.finalClusters = [handles.finalClusters handles.grownClusters(handles.grownClusterIndex)];
        handles.updateMap = true;
        handles.maxFinalIndex = length(handles.finalClusters);
        handles.isReconstructed = true;
        end
    end
else
    %THROW SOME KIND OF ERROR SOMEWHERE SaYING WE CAN ONLY ADD FROM GROWN
    %CLUSTERS
end
guidata(hObject,handles)
% --- Executes on selection change in mapView1.
function mapView1_Callback(hObject, eventdata, handles)
% hObject    handle to mapView1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if (hObject.Value ~= handles.mapView1.Value)
    if hObject.String{hObject.Value} == "IQ Map"
        imshow(handles.grainmap.IQmat,'Parent',handles.axes2);
    elseif hObject.String{hObject.Value} == "IPF Map" 
        imshow(handles.grainmap.grainIPFmap.IPFimage,'Parent',handles.axes2);
    elseif hObject.String{hObject.Value} == "CI Map"
        imshow(handles.grainmap.CImat,'Parent',handles.axes2);
    end 
% end 


guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns mapView1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapView1


% --- Executes during object creation, after setting all properties.
function mapView1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapView1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mapView2.
function mapView2_Callback(hObject, eventdata, handles)
% hObject    handle to mapView2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes3);
if hObject.String{hObject.Value} == "Cycle Grown Clusters" && handles.isGrown 
    set(handles.indexDisplay, 'String', handles.grownClusterIndex);
    handles.map2Selection = hObject.String{hObject.Value};
    imshow(handles.grownClusters(handles.grownClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3)
    handles.numVariantsDisp.String = sum(handles.grownClusters(handles.grownClusterIndex).existingVariants); 
elseif hObject.String{hObject.Value} == "Cycle Reconstructed Clusters"
    set(handles.indexDisplay, 'String', handles.finalClusterIndex);
    handles.map2Selection = hObject.String{hObject.Value};
    if ~isempty(handles.finalClusters)
        imshow(handles.finalClusters(handles.finalClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3);
        handles.numVariantsDisp.String = sum(handles.finalClusters(handles.finalClusterIndex).existingVariants); 
    else 
        imshow(handles.black,'Parent',handles.axes3);
        handles.numVariantsDisp.String = 'N/A';
    end
elseif hObject.String{hObject.Value} == "Reconstructed IPF Map"
    set(handles.indexDisplay, 'String', 1);
    handles.map2Selection = hObject.String{hObject.Value};
    handles.numVariantsDisp.String = 'N/A';
    if (handles.updateMap == true)
        handles.reconstructor.clusters = handles.finalClusters;
        handles.reconstructor.genReconstructedIPFmap('filled');
        handles.updateMap = false;
    end 
    imshow(handles.reconstructor.reconstructedIPFmap.IPFimage,'Parent',handles.axes3);
    if ~isempty(handles.finalClusters)
        handles.isReconstructed = true;
    end
end

guidata(hObject,handles); 


% Hints: contents = cellstr(get(hObject,'String')) returns mapView2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapView2


% --- Executes during object creation, after setting all properties.
function mapView2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapView2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clusterTrim.
function clusterTrim_Callback(hObject, eventdata, handles)
% for the reconstructed cluster selected, move all included non members into the member
% grain list
if ((handles.mapView2.String{handles.mapView2.Value} == "Cycle Reconstructed Clusters") && (~isempty(handles.finalClusters))) 
     currCluster = handles.finalClusters(handles.finalClusterIndex); 
elseif ((handles.mapView2.String{handles.mapView2.Value} == "Cycle Grown Clusters") && (~isempty(handles.grownClusters)))
     currCluster = handles.grownClusters(handles.grownClusterIndex); 
else 
    currCluster = [];
end
if ~isempty(currCluster)
     currCluster.memberGrains = union(currCluster.memberGrains,currCluster.includedNonMemberGrains);
%      currCluster.parentPhaseOrientations = union(currCluster.parentPhaseOrientations,[currCluster.memberGrains.orientation]);
     currCluster.includedNonMemberGrains = Grain.empty;
     currCluster.calc_metadata(handles.grainmap.gIDmat,'filled',true);

    [BW,IDs] = SelectedData.poly_select_IPF_data(handles.axes3,handles.reconstructor,'daughterGrains');
    overlappingIDs = ismember(IDs,[currCluster.memberGrains.OIMgid]);
    overlappingIDs = IDs(overlappingIDs);

    grainstomove = ismember([currCluster.memberGrains.OIMgid],overlappingIDs);
    currCluster.inactiveGrains = union(currCluster.inactiveGrains,currCluster.memberGrains(grainstomove));
    currCluster.memberGrains = currCluster.memberGrains(~grainstomove);
    currCluster.parentPhaseOrientations = currCluster.parentPhaseOrientations(~grainstomove);

    currCluster.genClusterIPFmap(handles.grainmap.gIDmat,'parentAverage','filled');
    imshow(currCluster.clusterIPFmap.IPFimage,'Parent',handles.axes3);
    handles.updateMap = true;
%     handles.trimmedClusters = [handles.trimmedClusters currCluster];
    handles.trimmedClusters = currCluster;
%     handles.overlappingIDs = [handles.overlappingIDs overlappingIDs];
    handles.overlappingIDs = overlappingIDs;    
end
guidata(hObject,handles); 


% --- Executes when uipanel2 is resized.
function uipanel2_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in removeCluster.
function removeCluster_Callback(hObject, eventdata, handles)
% hObject    handle to removeCluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.mapView2.String{handles.mapView2.Value} == "Cycle Grown Clusters" && handles.isGrown
    handles.grownClusters(handles.grownClusterIndex) = [];
    if handles.grownClusterIndex == handles.maxGrownIndex && handles.maxFinalIndex ~= 1
        handles.grownClusterIndex = handles.grownClusterIndex - 1;
    end 
    
    if handles.maxGrownIndex == 1
        imshow(handles.black,'Parent',handles.axes3);
        handles.isGrown = 0;
        handles.numVariantsDisp.String = 'N/A';
        guidata(hObject,handles)
        return;
    end
    handles.maxGrownIndex = handles.maxGrownIndex - 1;
    imshow(handles.grownClusters(handles.grownClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3);
    handles.indexDisplay.String = num2str(handles.grownClusterIndex);
    handles.numVariantsDisp.String = sum(handles.grownClusters(handles.grownClusterIndex).existingVariants); 
elseif handles.mapView2.String{handles.mapView2.Value} == "Cycle Reconstructed Clusters" && handles.isReconstructed;
     handles.finalClusters(handles.finalClusterIndex) = [];
    if handles.finalClusterIndex == handles.maxFinalIndex && handles.maxFinalIndex ~= 1
        handles.finalClusterIndex = handles.finalClusterIndex - 1;
    end 
    
    if handles.maxFinalIndex == 1
        imshow(handles.black,'Parent',handles.axes3);
        handles.isReconstructed = 0;
        handles.updateMap = true;
        handles.numVariantsDisp.String = 'N/A';
        guidata(hObject,handles)
        return;
    end
    handles.maxFinalIndex = handles.maxFinalIndex - 1;
    imshow(handles.finalClusters(handles.finalClusterIndex).clusterIPFmap.IPFimage,'Parent',handles.axes3);
    handles.updateMap = true;
    handles.indexDisplay.String = num2str(handles.finalClusterIndex);
    handles.numVariantsDisp.String = sum(handles.finalClusters(handles.finalClusterIndex).existingVariants); 
elseif handles.mapView2.String{handles.mapView2.Value} == "Reconstructed IPF Map"
end

guidata(hObject,handles)


% --- Executes on button press in PlotPoleFigure.
function PlotPoleFigure_Callback(hObject, eventdata, handles)
% hObject    handle to PlotPoleFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedFigure = str2double(handles.figureNumSelect.String);
% if(handles.LeftAxesSelect.Value && ~isnan(selectedFigure))
%     chosenAxes = handles.axes2;
%     [BW,IDs] = SelectedData.poly_select_IPF_data(chosenAxes,handles.reconstructor,'daughterGrains');
%     indexarray = ismember([handles.reconstructor.daughterGrains.OIMgid],IDs);
%     grainarray = handles.reconstructor.daughterGrains(indexarray);
% 
%     grainO = [grainarray.orientation];
%     graingmats = [grainO.g];
%     graingmats = reshape(graingmats,3,3,length(grainO));
% 
%     pole_figure_by_gmat(graingmats,'rd',3,selectedFigure);
proceed = false; 
    
    if handles.mapView2.String{handles.mapView2.Value} == "Cycle Grown Clusters" && handles.isGrown
       currClust = handles.grownClusters(handles.grownClusterIndex);
       proceed = true;
    elseif handles.mapView2.String{handles.mapView2.Value} == "Cycle Reconstructed Clusters" && handles.isReconstructed
       currClust = handles.finalClusters(handles.finalClusterIndex);
       proceed = true;
    end
    if proceed
        if handles.ClusterOrientationOption.Value
            clustergmat = currClust.clusterOCenter.g;
            clusterColor = strcat(handles.ClusterColor.String{handles.ClusterColor.Value}(1),'*');
            pole_figure_by_gmat(clustergmat,clusterColor,(handles.ClusterSize.Value)*15,selectedFigure);
        end
        if handles.TheoreticalVariantsOption.Value
            theoreticalVars = [currClust.theoreticalVariants.g];
            theoreticalVars = reshape(theoreticalVars,3,3,24);
            variantsColor = strcat(handles.TheoreticalColor.String{handles.TheoreticalColor.Value}(1),'d');
            pole_figure_by_gmat(theoreticalVars,variantsColor,(handles.TheoreticalSize.Value)*7.5,selectedFigure);
        end
        if handles.DaughterGrainsOption.Value
            grainO = [currClust.memberGrains.orientation];
            graingmats = [grainO.g];
            graingmats = reshape(graingmats,3,3,length(grainO));
            daughtersColor = strcat(handles.DaughterColor.String{handles.DaughterColor.Value}(1),'.');
            pole_figure_by_gmat(graingmats,daughtersColor,(handles.DaughterSize.Value)*5,selectedFigure);
        end
    end
guidata(hObject,handles);



% --- Executes on button press in RightAxesSelect.
function RightAxesSelect_Callback(hObject, eventdata, handles)
% hObject    handle to RightAxesSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RightAxesSelect


% --- Executes on button press in clusterPoleFigure.
function DataSelectPoleFigure_Callback(hObject, eventdata, handles)
% hObject    handle to clusterPoleFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedFigure = str2double(handles.figureNumSelect.String);
if(handles.LeftAxesSelect.Value && ~isnan(selectedFigure))
    chosenAxes = handles.axes2;
    [BW,IDs] = SelectedData.poly_select_IPF_data(chosenAxes,handles.reconstructor,'daughterGrains');
    indexarray = ismember([handles.reconstructor.daughterGrains.OIMgid],IDs);
    grainarray = handles.reconstructor.daughterGrains(indexarray);

    grainO = [grainarray.orientation];
    graingmats = [grainO.g];
    graingmats = reshape(graingmats,3,3,length(grainO));

    pole_figure_by_gmat(graingmats,'rd',3,selectedFigure);
end


% --- Executes on button press in UndoClusterTrim.
function UndoClusterTrim_Callback(hObject, eventdata, handles)
% hObject    handle to UndoClusterTrim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.trimmedClusters) 
%     lastClusterIndex = length(handles.trimmedClusters);
%     trimmedClust = handles.trimmedClusters(lastClusterIndex);
    trimmedClust = handles.trimmedClusters;
    overlappingIDs = handles.overlappingIDs;
    grainstomoveback = ismember([trimmedClust.inactiveGrains.OIMgid],overlappingIDs);
    trimmedClust.memberGrains = union(trimmedClust.memberGrains,trimmedClust.inactiveGrains(grainstomoveback));
    trimmedClust.inactiveGrains = trimmedClust.inactiveGrains(~grainstomoveback);
    trimmedClust.genClusterIPFmap(handles.grainmap.gIDmat,'parentAverage','filled');
    imshow(handles.trimmedClusters.clusterIPFmap.IPFimage,'Parent',handles.axes3);
%     handles.trimmedClusters(lastClusterIndex) = [];
    handles.trimmedClusters = [];
%     handles.overlappingIDs(lastClusterIndex) = [];
    handles.overlappingIDs = [];
    handles.updateMap = true;
end

guidata(hObject,handles)


% --- Executes on button press in ClusterOrientationOption.
function ClusterOrientationOption_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterOrientationOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClusterOrientationOption


% --- Executes on button press in TheoreticalVariantsOption.
function TheoreticalVariantsOption_Callback(hObject, eventdata, handles)
% hObject    handle to TheoreticalVariantsOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TheoreticalVariantsOption


% --- Executes on button press in DaughterGrainsOption.
function DaughterGrainsOption_Callback(hObject, eventdata, handles)
% hObject    handle to DaughterGrainsOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DaughterGrainsOption



function figureNumSelect_Callback(hObject, eventdata, handles)
% hObject    handle to figureNumSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figureNumSelect as text
%        str2double(get(hObject,'String')) returns contents of figureNumSelect as a double


% --- Executes during object creation, after setting all properties.
function figureNumSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figureNumSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Zoom.
function Zoom_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageHandle = imshow(handles.grainmap.grainIPFmap.IPFimage,'Parent',handles.axes2);
scrollPanel = imscrollpanel(handles.axes2,imageHandle);
api = iptgetapi(scrollPanel);
overviewHandle = imoverview(imageHandle);
api.setMagnification(string2double(handles.Zoom.String));



function magnification_Callback(hObject, eventdata, handles)
% hObject    handle to magnification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of magnification as text
%        str2double(get(hObject,'String')) returns contents of magnification as a double


% --- Executes during object creation, after setting all properties.
function magnification_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magnification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in WriteAngFile.
function WriteAngFile_Callback(hObject, eventdata, handles)
% hObject    handle to WriteAngFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.reconstructor.clusters = handles.finalClusters;
clusterPropertiesFix(handles.reconstructor);
% handles.reconstructor.ambiguityMethod = 'Simulated Annealing';
handles.reconstructor.ambiguityMethod = 'Best side (fast)';
handles.reconstructor.place_clusters;

handles.reconstructor.gen_ang_file;
guidata(hObject,handles)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in ClusterColor.
function ClusterColor_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ClusterColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ClusterColor


% --- Executes during object creation, after setting all properties.
function ClusterColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DaughterColor.
function DaughterColor_Callback(hObject, eventdata, handles)
% hObject    handle to DaughterColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DaughterColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DaughterColor


% --- Executes during object creation, after setting all properties.
function DaughterColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DaughterColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TheoreticalColor.
function TheoreticalColor_Callback(hObject, eventdata, handles)
% hObject    handle to TheoreticalColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TheoreticalColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TheoreticalColor


% --- Executes during object creation, after setting all properties.
function TheoreticalColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TheoreticalColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ClusterSize_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterSize (see GCBO)
% eventda
% Hints: get(hObject,'Value') returns position of sliderta  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ClusterSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function DaughterSize_Callback(hObject, eventdata, handles)
% hObject    handle to DaughterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function DaughterSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DaughterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function TheoreticalSize_Callback(hObject, eventdata, handles)
% hObject    handle to TheoreticalSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function TheoreticalSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TheoreticalSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ClusterOrientationOption.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterOrientationOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClusterOrientationOption


% --- Executes on button press in TheoreticalVariantsOption.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to TheoreticalVariantsOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TheoreticalVariantsOption


% --- Executes on button press in DaughterGrainsOption.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to DaughterGrainsOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DaughterGrainsOption



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to figureNumSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figureNumSelect as text
%        str2double(get(hObject,'String')) returns contents of figureNumSelect as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figureNumSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SaveProfileSelect.
function SaveProfileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to SaveProfileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function SaveProfileSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveProfileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveProfile.
function SaveProfile_Callback(hObject, eventdata, handles)
% hObject    handle to SaveProfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedProfile = handles.SaveProfileSelect.String{handles.SaveProfileSelect.Value};
clusterColorValue = handles.ClusterColor.Value;
daughterColorValue = handles.DaughterColor.Value;
theoreticalColorValue = handles.TheoreticalColor.Value;
clusterPlotSize = handles.ClusterSize.Value;
daughterPlotSize = handles.DaughterSize.Value;
theoreticalPlotSize = handles.TheoreticalSize.Value;
if selectedProfile == "-- Select Profile --"
    return;
elseif selectedProfile == "Profile 1"
    handles.Profile{1} = {clusterColorValue daughterColorValue theoreticalColorValue
        clusterPlotSize daughterPlotSize theoreticalPlotSize};
elseif selectedProfile == "Profile 2"
    handles.Profile{2} = {clusterColorValue daughterColorValue theoreticalColorValue
        clusterPlotSize daughterPlotSize theoreticalPlotSize};
elseif selectedProfile == "Profile 3"
    handles.Profile{3} = {clusterColorValue daughterColorValue theoreticalColorValue
        clusterPlotSize daughterPlotSize theoreticalPlotSize};
elseif selectedProfile == "Profile 4"
    handles.Profile{4} = {clusterColorValue daughterColorValue theoreticalColorValue
        clusterPlotSize daughterPlotSize theoreticalPlotSize};
end

guidata(hObject,handles)


% --- Executes on selection change in PlotProfileLeft.
function PlotProfileLeft_Callback(hObject, eventdata, handles)
% hObject    handle to PlotProfileLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlotProfileLeft contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlotProfileLeft


% --- Executes during object creation, after setting all properties.
function PlotProfileLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotProfileLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlotProfileRight.
function PlotProfileRight_Callback(hObject, eventdata, handles)
% hObject    handle to PlotProfileRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
selectedProfile = hObject.String{hObject.Value};
index = 0;
if selectedProfile == "-- Select Profile --"
    return;
elseif selectedProfile == "Profile 1"
    index = 1;
elseif selectedProfile == "Profile 2"
    index = 2;
elseif selectedProfile == "Profile 3"
    index = 3;
elseif selectedProfile == "Profile 4"
    index = 4;
end
    handles.ClusterColor.Value = handles.Profile{index}{1};
    handles.DaughterColor.Value = handles.Profile{index}{3};
    handles.TheoreticalColor.Value = handles.Profile{index}{5};
    handles.ClusterSize.Value = handles.Profile{index}{2};
    handles.DaughterSize.Value = handles.Profile{index}{4};
    handles.TheoreticalSize.Value = handles.Profile{index}{6};
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function PlotProfileRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotProfileRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
