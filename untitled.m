

function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 14-Nov-2019 17:32:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btnFSpeech.
function btnFSpeech_Callback(hObject, eventdata, handles)
% hObject    handle to btnFSpeech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileWaveFemale;
global fullpathnameF;
global pathname; 

axes(handles.axeOriginFSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');

% Showing FullPathName
fullpathnameF = strcat(pathname, filename);
set(handles.txtPathNameF,'String',fullpathnameF);

[fileWaveFemale, Fs] = audioread(fullpathnameF);
normalizeAudio(fileWaveFemale);

t = (0:numel(fileWaveFemale)-1)*(1/Fs);
plot(t, fileWaveFemale);
sound(fileWaveFemale);

% --- Executes on button press in btnMSpeech.
function btnMSpeech_Callback(hObject, eventdata, handles)
global fileWaveMale;
global fullpathnameM;

axes(handles.axeOriginMSpeech);
clear sound;

[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');
% Showing FullPathName
fullpathnameM = strcat(pathname, filename);
set(handles.txtPathNameM,'String',fullpathnameM);

[fileWaveMale, Fs] = audioread(fullpathnameM);
normalizeAudio(fileWaveMale);
%linspace = its the function that gonna create the time vector
%0=starting time, length(y)/fs = ending time, length(y) = the number of
%samples in y)
t = (0:numel(fileWaveMale)-1)*(1/Fs);
plot(t,fileWaveMale);
sound(fileWaveMale);

% --- Executes on button press in btnPSpeech.
function btnPSpeech_Callback(hObject, eventdata, handles)
global fileWavePiano;
global fullpathnameP;

axes(handles.axeOriginPSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');

% Showing FullPathName
fullpathnameP = strcat(pathname, filename);
set(handles.txtPathNameP,'String',fullpathnameP);

[fileWavePiano, Fs] = audioread(fullpathnameP);
normalizeAudio(fileWavePiano);
%linspace = its the function that gonna create the time vector
%0=starting time, length(y)/fs = ending time, length(y) = the number of
%samples in y)
t = (0:numel(fileWavePiano)-1)*(1/Fs);
plot(t,fileWavePiano);
sound(fileWavePiano);

% --- Executes on button press in btnMix
function btnMix_Callback(hObject, eventdata, handles)
rng(42);
global fullpathnameF;
global fullpathnameM;
global fullpathnameP;
global mixMSpeech_Hard;
global mixFSpeech_Hard;
global mixPSpeech_Hard;
global Zmixed;

% Knobs
paths = {fullpathnameM,fullpathnameF,fullpathnameP};

[p, d, r] = deal(numel(paths));
A = randomMixingMatrix(d,p);

% Load audio
Ztrue = loadAudio(paths);
% Generate mixed signals
Zmixed = normalizeAudio(A * Ztrue);

audio = [];
% Mixed waveforms
for i = 1:3
    audio{i} = Zmixed(i,:); %#ok
end
mixMSpeech_Hard = audio{1};
mixFSpeech_Hard = audio{2};
mixPSpeech_Hard = audio{3};

set(handles.txtMix,'String','Mix sucessfully!');

% --- Executes when selected object is changed in btnGroup.
function btnGroup_SelectionChangedFcn(hObject, eventdata, handles)
global typeICA;
switch(get(eventdata.NewValue,'Tag'));
    case 'btnNegentropy'
        typeICA = 'negentropy';
    case 'btnKurtosis'
        typeICA = 'kurtosis';
end

% --- Executes on button press in btnSeparate.
function btnSeparate_Callback(hObject, eventdata, handles)
global Zmixed;
global after1;
global after2;
global after3;
global typeICA;

% Fast ICA
Zica1 = normalizeAudio(fastICA(Zmixed,3,typeICA));
audio = [];
for i = 1:3
	audio{i} = Zica1(i,:); %#ok
end
after1 = audio{1};
after2 = audio{2};
after3 = audio{3};
axes(handles.axeFSpeech);
plot(after1);
axes(handles.axeMSpeech);
plot(after2);
axes(handles.axePSpeech);
plot(after3);
set(handles.txtSeparate,'String','Separate sucessfully!');

% --- Executes during object creation, after setting all properties.
function popSound_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in lisPlayer.
function lisPlayer_Callback(hObject, eventdata, handles)
global fileWaveFemale;
global fileWaveMale;
global fileWavePiano;
global mixMSpeech_Hard;
global mixFSpeech_Hard;
global mixPSpeech_Hard;
global nowPlaying;
global after1;
global after2;
global after3;

valueList = get(handles.lisPlayer, 'Value');
if (valueList == 1)
    nowPlaying = fileWaveFemale;
    set(handles.txtPlayerStatus,'String','You are playing source1');
elseif (valueList == 2)
    nowPlaying = fileWaveMale;
    set(handles.txtPlayerStatus,'String','You are playing source2');
elseif (valueList == 3)
    nowPlaying = fileWavePiano;
    set(handles.txtPlayerStatus,'String','You are playing source3');
elseif (valueList == 4)
    nowPlaying = mixMSpeech_Hard;
    set(handles.txtPlayerStatus,'String','You are playing mic1');
elseif (valueList == 5)
    nowPlaying = mixFSpeech_Hard;
    set(handles.txtPlayerStatus,'String','You are playing mic2');
elseif (valueList == 6)
    nowPlaying = mixPSpeech_Hard;
    set(handles.txtPlayerStatus,'String','You are playing mic3');
elseif (valueList == 7)
    nowPlaying = after1;
    set(handles.txtPlayerStatus,'String','You are playing after1');
elseif (valueList == 8)
    nowPlaying = after2;
    set(handles.txtPlayerStatus,'String','You are playing after2');
elseif (valueList == 9)
    nowPlaying = after3;
    set(handles.txtPlayerStatus,'String','You are playing after3');
end
    
% --- Executes on button press in btnPlaySound.
function btnPlaySound_Callback(hObject, eventdata, handles)
global nowPlaying;
clear sound;
axes(handles.axePlayer);
t = (0:numel(nowPlaying)-1)*(1/8000);
plot(t, nowPlaying);
sound(nowPlaying);

% --- Executes during object creation, after setting all properties.
function lisPlayer_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
