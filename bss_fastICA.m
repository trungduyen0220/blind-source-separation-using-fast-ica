function varargout = bss_fastICA(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bss_fastICA_OpeningFcn, ...
                   'gui_OutputFcn',  @bss_fastICA_OutputFcn, ...
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

function bss_fastICA_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
handles.output = hObject;
guidata(hObject, handles);

function varargout = bss_fastICA_OutputFcn(hObject, eventdata, handles) %#ok
varargout{1} = handles.output;

%
% method: btnFSpeech_Callback
%
function btnFSpeech_Callback(hObject, eventdata, handles) %#ok
global fileWaveFemale;
global fullpathnameF;
global pathname; 

axes(handles.axeOriginFSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');

% Showing FullPathName
fullpathnameF = strcat(pathname, filename);
set(handles.txtPathNameF,'String',fullpathnameF);
[fileWaveFemale] = audioread(fullpathnameF);
plot(fileWaveFemale);
sound(fileWaveFemale);

%
% method: btnMSpeech_Callback
%
function btnMSpeech_Callback(hObject, eventdata, handles)  %#ok
global fileWaveMale;
global fullpathnameM;
axes(handles.axeOriginMSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');
fullpathnameM = strcat(pathname, filename);
set(handles.txtPathNameM,'String',fullpathnameM);
[fileWaveMale] = audioread(fullpathnameM);
plot(fileWaveMale);
sound(fileWaveMale);

%
% method: btnPSpeech_Callback
%
function btnPSpeech_Callback(hObject, eventdata, handles) %#ok
global fileWavePiano;
global fullpathnameP;
axes(handles.axeOriginPSpeech);
clear sound;
[filename, pathname] = uigetfile('*.wav', 'Select a wave file','MultiSelect','on');
fullpathnameP = strcat(pathname, filename);
set(handles.txtPathNameP,'String',fullpathnameP);
[fileWavePiano] = audioread(fullpathnameP);
plot(fileWavePiano);
sound(fileWavePiano);

%
% method: btnMix_Callback
%
function btnMix_Callback(hObject, eventdata, handles) %#ok
rng(42);
global fullpathnameF;
global fullpathnameM;
global fullpathnameP;
global mixMSpeech_Hard;
global mixFSpeech_Hard;
global mixPSpeech_Hard;
global Zmixed;

paths = {fullpathnameM,fullpathnameF,fullpathnameP};
[p, d] = deal(numel(paths));
A = 0.25 + rand(d,p);
A = bsxfun(@rdivide,A,sum(A,2));
Ztrue = loadAudio(paths);
Zmixed = normalizeAudio(A * Ztrue);
audio = [];
for i = 1:3
    audio{i} = Zmixed(i,:); %#ok
end
mixMSpeech_Hard = audio{1};
mixFSpeech_Hard = audio{2};
mixPSpeech_Hard = audio{3};
set(handles.txtMix,'String','Mix sucessfully!');

%
% method: btnGroup_SelectionChangedFcn
%
function btnGroup_SelectionChangedFcn(hObject, eventdata, handles) %#ok
global typeICA;
switch(get(eventdata.NewValue,'Tag')); %#ok
    case 'btnNegentropy'
        typeICA = get(btnNegentropy,'String');
    case 'btnKurtosis'
        typeICA = get(btnKurtosis,'String');
end

%
% method: btnSeparate_Callback
%
function btnSeparate_Callback(hObject, eventdata, handles) %#ok
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

%
% method: popSound_CreateFcn
%
function popSound_CreateFcn(hObject, eventdata, handles)  %#ok
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%
% method: lisPlayer_Callback
%
function lisPlayer_Callback(hObject, eventdata, handles)  %#ok
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
% method: btnPlaySound_Callback
%
function btnPlaySound_Callback(hObject, eventdata, handles)  %#ok
global nowPlaying;
clear sound;
axes(handles.axePlayer);
plot(nowPlaying);
sound(nowPlaying);

%
% method: btnPlaySound_Callback
%
function lisPlayer_CreateFcn(hObject, eventdata, handles)  %#ok
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
