function varargout = TrainCNN(varargin)
%                   __  __ ____    ____ _____ ___ ____ 
%                  |  \/  |___ \  / ___|_   _|_ _/ ___|
%                  | |\/| | __) | \___ \ | |  | | |    
%                  | |  | |/ __/   ___) || |  | | |___ 
%                  |_|  |_|_____| |____/ |_| |___\____|

% TRAINCNN MATLAB code for TrainCNN.fig
%      TRAINCNN, by itself, creates a new TRAINCNN or raises the existing
%      singleton*.
%
%      H = TRAINCNN returns the handle to a new TRAINCNN or the handle to
%      the existing singleton*.
%
%      TRAINCNN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINCNN.M with the given input arguments.
%
%      TRAINCNN('Property','Value',...) creates a new TRAINCNN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrainCNN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrainCNN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrainCNN

% Last Modified by GUIDE v2.5 05-Sep-2020 14:47:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrainCNN_OpeningFcn, ...
                   'gui_OutputFcn',  @TrainCNN_OutputFcn, ...
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

% --- Executes just before TrainCNN is made visible.
function TrainCNN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrainCNN (see VARARGIN)
bg = imread('image.png'); imagesc(bg);
% Choose default command line output for TrainCNN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using TrainCNN.
if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
end

% UIWAIT makes TrainCNN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrainCNN_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bg = imread('image.png'); imagesc(bg);
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in CNNSelection.
function CNNSelection_Callback(hObject, eventdata, handles)
% hObject    handle to CNNSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns CNNSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CNNSelection


% --- Executes during object creation, after setting all properties.
function CNNSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CNNSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});

% --- Executes on button press in Entrainer.
function Entrainer_Callback(hObject, eventdata, handles)
% hObject    handle to Entrainer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bg = imread('image.png'); imagesc(bg);
axes(handles.axes1);
cla;
if (~isfield(handles, 'folder_name'))
    errordlg('Veuillez d''abord selectionner un répertoire d''images !');
    return;
end

popup_sel_index = get(handles.CNN, 'Value');
switch popup_sel_index
    case 1
       TrainModelAlexNet;
    case 2
        TrainModelGoogleNet;
    case 3
       TrainModelVgg19;
    case 4
        TrainModelResNet50;
   
end


% --- Executes on button press in chargerRep.
function chargerRep_Callback(hObject, eventdata, handles)
% hObject    handle to chargerRep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%folder_name = uigetdir(pwd, 'Sélectionnez le répertoire d''images');
folder_name = uigetdir(pwd, 'Sélectionnez le répertoire d''images');
if ( folder_name ~= 0 )
    handles.folder_name = folder_name;
    guidata(hObject, handles);
    
else
    return;
end


% --- Executes on selection change in CNN.
function CNN_Callback(hObject, eventdata, handles)
% hObject    handle to CNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.popup_sel_index = get(handles.CNN, 'Value');
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns CNN contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CNN


% --- Executes during object creation, after setting all properties.
function CNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
