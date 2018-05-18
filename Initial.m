function varargout = Initial(varargin)
% INITIAL MATLAB code for Initial.fig
%      INITIAL, by itself, creates a new INITIAL or raises the existing
%      singleton*.
%
%      H = INITIAL returns the handle to a new INITIAL or the handle to
%      the existing singleton*.
%
%      INITIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INITIAL.M with the given input arguments.
%
%      INITIAL('Property','Value',...) creates a new INITIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Initial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Initial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Initial

% Last Modified by GUIDE v2.5 13-Sep-2016 12:51:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Initial_OpeningFcn, ...
                   'gui_OutputFcn',  @Initial_OutputFcn, ...
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


% --- Executes just before Initial is made visible.
function Initial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Initial (see VARARGIN)

% Choose default command line output for Initial
handles.output = hObject;

%Load in logo
logo = imread('Logo.png');
axes(handles.logo)
imshow(logo)

handles.folder = pwd; % Open most recently used folder, default to current working directory

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Initial wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Initial_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function GrainFile1Path_Callback(hObject, eventdata, handles)
% hObject    handle to GrainFile1Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GrainFile1Path as text
%        str2double(get(hObject,'String')) returns contents of GrainFile1Path as a double


% --- Executes during object creation, after setting all properties.
function GrainFile1Path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GrainFile1Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GrainFile2Path_Callback(hObject, eventdata, handles)
% hObject    handle to GrainFile2Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GrainFile2Path as text
%        str2double(get(hObject,'String')) returns contents of GrainFile2Path as a double


% --- Executes during object creation, after setting all properties.
function GrainFile2Path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GrainFile2Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GrainFile1Browse.
function GrainFile1Browse_Callback(hObject, eventdata, handles)
% hObject    handle to GrainFile1Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name,path] = uigetfile({'*.txt','Grain File Type I'},'Select Grain File Type I',handles.folder);
handles.folder = path;
handles.GF1_Path = fullfile(path,name);
handles.GrainFile1Path.String = handles.GF1_Path;
guidata(hObject,handles);


% --- Executes on button press in GrainFile2Browse.
function GrainFile2Browse_Callback(hObject, eventdata, handles)
% hObject    handle to GrainFile2Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % [name,path] = uigetfile({'*.txt','Grain File Type II'},'Select Grain File Type II');
[name,path] = uigetfile({'*.txt','Grain File Type II'},'Select Grain File Type II',handles.folder);
handles.folder = path;
handles.GF2_Path = fullfile(path,name);
handles.GrainFile2Path.String = handles.GF2_Path;
guidata(hObject,handles);


% --- Executes on button press in ReadData.
function ReadData_Callback(hObject, eventdata, handles)
% hObject    handle to ReadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist(handles.GF1_Path,'file')
    if exist(handles.GF2_Path,'file')
        % Read in data 
        scandata = Scandata(handles.GF1_Path,handles.GF2_Path);
        grainmap = Grainmap(scandata);
        Reconstruction(grainmap);
        HandReconstruction(grainmap);
    else
        w = warndlg('Grain File Type II doesn''t exist');
        uiwait(w,5)
    end
else
    w = warndlg('Grain File Type I doesn''t exist');
    uiwait(w,5)
end
