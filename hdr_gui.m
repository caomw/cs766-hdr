function varargout = hdr_gui(varargin)
% HDR_GUI MATLAB code for hdr_gui.fig
%      HDR_GUI, by itself, creates a new HDR_GUI or raises the existing
%      singleton*.
%
%      H = HDR_GUI returns the handle to a new HDR_GUI or the handle to
%      the existing singleton*.
%
%      HDR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HDR_GUI.M with the given input arguments.
%
%      HDR_GUI('Property','Value',...) creates a new HDR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hdr_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hdr_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hdr_gui

% Last Modified by GUIDE v2.5 09-Feb-2015 22:11:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hdr_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @hdr_gui_OutputFcn, ...
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


% --- Executes just before hdr_gui is made visible.
function hdr_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hdr_gui (see VARARGIN)

% Choose default command line output for hdr_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hdr_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hdr_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fNames fPath] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'; ...
    '*.*','All Files' },'Select LDR Images','MultiSelect','on');

set(handles.slider1,'Value',1.0); % reset slider

%return if no values
if ~iscell(fNames)
    return
end

% load exposure times
[eFName eFPath] = uigetfile({'*.txt;','Text Files'; ...
    '*.*','All Files' },'Select Exposure File','MultiSelect','off');

%return if no values
if eFName == 0
    return
end

% setup exposure times
expTimes = 1 ./ load(fullfile(eFPath, eFName));

% get filenames
size = length(fNames);
files = cell([1 size]);
for i = 1:size
    files(i) = fullfile(fPath, fNames(i));
end

% init axes
hAxes = getappdata(handles.figure1,'hAxes');
if ~isempty(hAxes)
    f = find ( ishandle(hAxes) & hAxes);
    delete(hAxes(f));
end
hAxes = zeros(size,1);

axesProp = {'DataAspectRatio' ,'Parent','PlotBoxAspectRatio','XGrid','YGrid'};
axesVal = {[1.0 1.0 1.0], handles.uipanel1, [1.0 1.0 1.0], 'off', 'off'};

% setup panel position for # of images
ht = 0.25 * size;
po = ht - 1.0;
pos = get(handles.uipanel1, 'Position');
pos(4) = ht;
pos(2) = -po;
set(handles.uipanel1, 'Position', pos);

% image position constants
x = 1 - (0.98 / 1); % x position (1 column)
rPitch = 0.98/size;
axWidth = 0.9/1;
axHight = 0.9/size;

% post images into LDR panel
h = waitbar(0, 'Loading images...'); % start progress bar
for i = 1:size
    % create axes
    y = 1 - (i) * rPitch; % y position
    hAxes(i) = axes('Position', [x y axWidth axHight], axesProp, axesVal);
    
    % draw image in axes
    im = imread(char(files(i)));
    imagesc(im,'Parent',hAxes(i))
    axis(hAxes(i),'image');
    axis(hAxes(i),'off');
    images(:,:,:,i) = im;
    
    waitbar(i / size); % progress bar update
end

close(h);
set(handles.solve,'Enable','on');
setappdata(handles.figure1,'hAxes',hAxes);
setappdata(handles.figure1,'images',images);
setappdata(handles.figure1,'exposureTimes',expTimes);

% reset downstream data
if isappdata(handles.figure1,'radMap')
    ax = getappdata(handles.figure1,'radMapGraph');
    cla(ax);
    rmappdata(handles.figure1,'radMap')
end

if isappdata(handles.figure1,'radMapGraph')
    rmappdata(handles.figure1,'radMapGraph')
end

if isappdata(handles.figure1,'ldrDrawing')
    ax = getappdata(handles.figure1,'ldrDrawing');
    cla(ax);
    rmappdata(handles.figure1,'ldrDrawing');
end

set(handles.saveRadMap,'Enable','off');
set(handles.toneMap,'Enable','off');




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

pos = get(handles.uipanel1,'Position');
hight = pos(4);% get the height
if hight > 1
    val = get(hObject,'Value');
    yPos = -(hight-1) + (hight-1)*(1-val);
    pos(2) = yPos;
    set(handles.uipanel1,'Position',pos);
end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function solve_Callback(hObject, eventdata, handles)
% hObject    handle to solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveRadMap_Callback(hObject, eventdata, handles)
% hObject    handle to saveRadMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function toneMap_Callback(hObject, eventdata, handles)
% hObject    handle to toneMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function openHDR_Callback(hObject, eventdata, handles)
% hObject    handle to openHDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load exposure times
[hdrName hdrPath] = uigetfile({'*.hdr;','HDR Files'},'Select HDR File','MultiSelect','off');

%return if no values
if hdrName == 0
    return
end

% reset
set(handles.solve,'Enable','off');

if isappdata(handles.figure1,'radMap')
    ax = getappdata(handles.figure1,'radMapGraph');
    cla(ax);
    rmappdata(handles.figure1,'radMap');
end

if isappdata(handles.figure1,'radMapGraph')
    rmappdata(handles.figure1,'radMapGraph');
end

hAxes = getappdata(handles.figure1,'hAxes');
if ~isempty(hAxes)
    f = find ( ishandle(hAxes) & hAxes);
    delete(hAxes(f));
    rmappdata(handles.figure1,'hAxes');
end

if isappdata(handles.figure1,'ldrDrawing')
    ax = getappdata(handles.figure1,'ldrDrawing');
    cla(ax);
    rmappdata(handles.figure1,'ldrDrawing');
end

% read rad map from file
radMap = hdrread(fullfile(hdrPath, hdrName));

% convert to luminance for heat map (false color image)
delta = 0.00001;
L_w = 0.2126*radMap(:,:,1) + 0.7152*radMap(:,:,2) + 0.0722*radMap(:,:,3);
L_w_bar = exp(mean(log(L_w(:) + delta)));
L = (0.09/L_w_bar)*L_w;

x = 1 - (0.98 / 1); % x position (1 column)
y = 1 - (0.98 / 1); % y position (1 row)
axWidth = 0.9;
axHight = 0.9;
axesProp = {'DataAspectRatio' ,'Parent','PlotBoxAspectRatio','XGrid','YGrid'};
axesVal = {[1.0 1.0 1.0], handles.uipanel4, [1.0 1.0 1.0], 'off', 'off'};
radDrawing = axes('Position', [x y axWidth axHight], axesProp, axesVal);
imshow(L,[],'Colormap',jet(256));

setappdata(handles.figure1,'radMap',radMap);
setappdata(handles.figure1,'radMapGraph',radDrawing);
set(handles.toneMap,'Enable','on');


% --------------------------------------------------------------------
function drago_Callback(hObject, eventdata, handles)
% hObject    handle to drago (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset
if isappdata(handles.figure1,'ldrDrawing')
    ax = getappdata(handles.figure1,'ldrDrawing');
    cla(ax);
    rmappdata(handles.figure1,'ldrDrawing');
end

beta = 0.85;
radMap = getappdata(handles.figure1,'radMap');
h = waitbar(0, 'Performing tone mapping...'); % start progress bar
DragoRGB = toneMapDrago(radMap, beta);
waitbar(1.0); % start progress bar
close(h);

x = 1 - (0.98 / 1); % x position (1 column)
y = 1 - (0.98 / 1); % y position (1 row)
axWidth = 0.9;
axHight = 0.9;
axesProp = {'DataAspectRatio' ,'Parent','PlotBoxAspectRatio','XGrid','YGrid'};
axesVal = {[1.0 1.0 1.0], handles.uipanel2, [1.0 1.0 1.0], 'off', 'off'};
ldrDrawing = axes('Position', [x y axWidth axHight], axesProp, axesVal);
imshow(DragoRGB,[]);

setappdata(handles.figure1,'ldrDrawing',ldrDrawing);


% --------------------------------------------------------------------
function reinhard_Callback(hObject, eventdata, handles)
% hObject    handle to reinhard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset
if isappdata(handles.figure1,'ldrDrawing')
    ax = getappdata(handles.figure1,'ldrDrawing');
    cla(ax);
    rmappdata(handles.figure1,'ldrDrawing');
end

radMap = getappdata(handles.figure1,'radMap');
h = waitbar(0, 'Performing tone mapping...'); % start progress bar
ReinhardRGB = toneMapBasic(radMap);
waitbar(1.0); % start progress bar
close(h);

x = 1 - (0.98 / 1); % x position (1 column)
y = 1 - (0.98 / 1); % y position (1 row)
axWidth = 0.9;
axHight = 0.9;
axesProp = {'DataAspectRatio' ,'Parent','PlotBoxAspectRatio','XGrid','YGrid'};
axesVal = {[1.0 1.0 1.0], handles.uipanel2, [1.0 1.0 1.0], 'off', 'off'};
ldrDrawing = axes('Position', [x y axWidth axHight], axesProp, axesVal);
imshow(ReinhardRGB,[]);

setappdata(handles.figure1,'ldrDrawing',ldrDrawing);

% --------------------------------------------------------------------
function matlabToneMap_Callback(hObject, eventdata, handles)
% hObject    handle to matlabToneMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset
if isappdata(handles.figure1,'ldrDrawing')
    ax = getappdata(handles.figure1,'ldrDrawing');
    cla(ax);
    rmappdata(handles.figure1,'ldrDrawing');
end

radMap = getappdata(handles.figure1,'radMap');
h = waitbar(0, 'Performing tone mapping...'); % start progress bar
builtInRGB = tonemap(radMap);
waitbar(1.0); % start progress bar
close(h);

x = 1 - (0.98 / 1); % x position (1 column)
y = 1 - (0.98 / 1); % y position (1 row)
axWidth = 0.9;
axHight = 0.9;
axesProp = {'DataAspectRatio' ,'Parent','PlotBoxAspectRatio','XGrid','YGrid'};
axesVal = {[1.0 1.0 1.0], handles.uipanel2, [1.0 1.0 1.0], 'off', 'off'};
ldrDrawing = axes('Position', [x y axWidth axHight], axesProp, axesVal);
imshow(builtInRGB,[]);

setappdata(handles.figure1,'ldrDrawing',ldrDrawing);