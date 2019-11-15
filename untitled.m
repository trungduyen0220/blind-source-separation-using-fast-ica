%
%
%
function varargout = untitled(varargin)
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

%
%
%
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

%
%
%
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%
%
%
function btnFSpeech_Callback(hObject, eventdata, handles)
global fileWaveFemale;
global fullpathnameF;
global pathname; 
axes(handles.axeOriginFSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');
fullpathnameF = strcat(pathname, filename);
set(handles.txtPathNameF,'String',fullpathnameF);
[fileWaveFemale] = audioread(fullpathnameF);
plot(fileWaveFemale);
sound(fileWaveFemale);

%
%
%
function btnMSpeech_Callback(hObject, eventdata, handles)
global fileWaveMale;
global fullpathnameM;
axes(handles.axeOriginMSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');
fullpathnameM = strcat(pathname, filename);
set(handles.txtPathNameM,'String',fullpathnameM);
[fileWaveMale] = audioread(fullpathnameM);
normalizeAudio(fileWaveMale);
plot(fileWaveMale);
sound(fileWaveMale);

%
%
%
function btnPSpeech_Callback(hObject, eventdata, handles)
global fileWavePiano;
global fullpathnameP;
axes(handles.axeOriginPSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');
fullpathnameP = strcat(pathname, filename);
set(handles.txtPathNameP,'String',fullpathnameP);
[fileWavePiano] = audioread(fullpathnameP);
normalizeAudio(fileWavePiano);
plot(fileWavePiano);
sound(fileWavePiano);

%
%
%
function btnMix_Callback(hObject, eventdata, handles)
rng(42);
global fullpathnameF;
global fullpathnameM;
global fullpathnameP;
global mixMSpeech_Hard;
global mixFSpeech_Hard;
global mixPSpeech_Hard;
global Zmixed;
paths = {fullpathnameM,fullpathnameF,fullpathnameP};
[p, d, r] = deal(numel(paths));
A = 0.25 + rand(d,p);
A = bsxfun(@rdivide,A,sum(A,2));

Ztrue = loadAudio(paths);
Zmixed = normalizeAudio(A * Ztrue);
audio = [];
for i = 1:3
    audio{i} = Zmixed(i,:);
end
mixMSpeech_Hard = audio{1};
mixFSpeech_Hard = audio{2};
mixPSpeech_Hard = audio{3};

set(handles.txtMix,'String','Mix sucessfully!');

%
%
%
function btnGroup_SelectionChangedFcn(hObject, eventdata, handles)
global typeICA;
switch(get(eventdata.NewValue,'Tag'));
    case 'btnNegentropy'
        typeICA = 'negentropy';
    case 'btnKurtosis'
        typeICA = 'kurtosis';
end

%
%
%
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
	audio{i} = Zica1(i,:);
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

%
%
%
function popSound_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%
%
%
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
 
%
%
%
function btnPlaySound_Callback(hObject, eventdata, handles)
global nowPlaying;
clear sound;
axes(handles.axePlayer);
plot(nowPlaying);
sound(nowPlaying);

%
%
%
function lisPlayer_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end