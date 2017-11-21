function varargout = Sync_Force_video_2017_quoll(varargin)
% SYNC_FORCE_VIDEO_2017_QUOLL MATLAB code for Sync_Force_video_2017_quoll.fig
%      SYNC_FORCE_VIDEO_2017_QUOLL, by itself, creates a new SYNC_FORCE_VIDEO_2017_QUOLL or raises the existing
%      singleton*.
%
%      H = SYNC_FORCE_VIDEO_2017_QUOLL returns the handle to a new SYNC_FORCE_VIDEO_2017_QUOLL or the handle to
%      the existing singleton*.
%
%      SYNC_FORCE_VIDEO_2017_QUOLL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNC_FORCE_VIDEO_2017_QUOLL.M with the given input arguments.
%
%      SYNC_FORCE_VIDEO_2017_QUOLL('Property','Value',...) creates a new SYNC_FORCE_VIDEO_2017_QUOLL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sync_Force_video_2017_quoll_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sync_Force_video_2017_quoll_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sync_Force_video_2017_quoll

% Last Modified by GUIDE v2.5 12-Feb-2017 17:57:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sync_Force_video_2017_quoll_OpeningFcn, ...
                   'gui_OutputFcn',  @Sync_Force_video_2017_quoll_OutputFcn, ...
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

function pathname_Callback(hObject, eventdata, handles)
% hObject    handle to pathname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    handles.str = get(handles.figure1,'UserData');
    
    [selection,selected] = listdlg('PromptString','Select a path:','SelectionMode','single','ListSize',[300 300],...
                    'ListString',handles.str);
    switch selection
        case 1  %add new path
            [~, handles.pathname]=uigetfile('*.*','select folder'); 
            handles.str{end+1}=handles.pathname;
            cd(handles.pathname);
            set(handles.figure1,'UserData',handles.str);
        case 3  %delete path
            [selection,selected] = listdlg('PromptString','Select path to be deleted','SelectionMode','single','ListSize',[300 300],...
                    'ListString',handles.str);
            handles.str(selection)=[];
            set(handles.figure1,'UserData',handles.str);
        otherwise
            handles.pathname=handles.str{selection};
            cd(handles.pathname);
    end
    guidata(hObject, handles);
catch
    if ~isfield(handles,'pathname')
        h = errordlg('You have not selected any path!','Error');        
    end
end

% --- Executes just before Sync_Force_video_2017_quoll is made visible.
function Sync_Force_video_2017_quoll_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sync_Force_video_2017_quoll (see VARARGIN)

% Choose default command line output for Sync_Force_video_2017_quoll
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Sync_Force_video_2017_quoll_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
handles.frame=round(get(handles.slider1,'Value'));

if handles.frame>handles.totalframes
    handles.frame=handles.totalframes;
elseif handles.frame<1
    handles.frame=1;
end

set(handles.slider1,'Value',handles.frame);
set(handles.edit5_frame,'String',num2str(handles.frame));


guidata(hObject,handles);
mydisplay(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton1_video.
function pushbutton1_video_Callback(hObject, eventdata, handles)

cd ('F:\quoll videos\quoll forces\side');
%%cd ('H:\research backup\quoll beam study');
% cd ('E:\Quoll gait paper');

[handles.videofilename, handles.pathname]=uigetfile({'*.MOV;*.avi;*.mpg;*.seq','Video files';'*.tif;*.jpg;*.bmp', 'Image files'},'pick file');
handles.videofile = fullfile(handles.pathname,handles.videofilename);
[~,handles.name,handles.ext] = fileparts(handles.videofile);



% avi files, initialise
    if strcmp(handles.ext,'.avi') || strcmp(handles.ext,'.AVI')|| strcmp(handles.ext,'.mpg') || strcmp(handles.ext,'.MPG')
        video = VideoReader(handles.videofile);
        handles.video=video;
        handles.totalframes = video.NumberOfFrames;
        handles.height = video.Height;
        handles.width = video.Width;
        handles.white= 2^(video.BitsPerPixel/3)-1; %maximum greyscale value, normally 255
%         set(handles.threshold,'max',handles.white);
%         set(handles.threshold,'Value',str2double(get(handles.edit_threshold,'String')));
        handles.framerate = video.FrameRate;
        
          elseif strcmp(handles.ext,'.MOV')
        video = VideoReader(handles.videofile);
        handles.video=video;
        handles.totalframes = video.NumberOfFrames;
        handles.height = video.Height;
        handles.width = video.Width;
        handles.white= 2^(video.BitsPerPixel/3)-1; 
        handles.framerate = video.FrameRate;
    end
    
set(handles.slider1,'max',handles.totalframes, 'min',1,'Value',1);
set(handles.edit2_filename,'String',handles.videofilename);
set(handles.edit3_totalframes,'String',num2str(handles.totalframes));
handles.frame=1;
handles.rect=[];

if get(handles.radiobutton3_side,'value')==0

    fname=fullfile(handles.pathname,'export.exp');
    fid=fopen(fname);
    mymat2=textscan(fid,'%s',26,'delimiter','\n');
    [a b]=strread(mymat2{1,1}{25}, '%s %s', 'delimiter', '=');
    set(handles.edit12_TFN,'String',b);
    [c d]=strread(mymat2{1,1}{12}, '%s %s', 'delimiter', '=');
    set(handles.edit10_FR,'String',d);
end    

arrayfun(@cla,findall(0,'type','axes'))

guidata(hObject, handles);
mydisplay(hObject, eventdata, handles)

function mydisplay(hObject, eventdata, handles)

if get(handles.radiobutton19,'value')==0
% open and show video frame
    axes(handles.axes1);
    if ~isempty(handles.videofile) 
        if strcmp(handles.ext,'.avi') || strcmp(handles.ext,'.AVI')|| strcmp(handles.ext,'.mpg') || strcmp(handles.ext,'.MPG') || strcmp(handles.ext,'.MOV')
                mov = read(handles.video, handles.frame);
            elseif strcmp(handles.ext,'.seq')
                [mov, ~, handles.totalframes] = readsinglestreampix(handles.videofile,handles.frame);
            elseif  strcmp(handles.ext,'.tif')|| strcmp(handles.ext,'.jpg') || strcmp(handles.ext,'.bmp')
                mov =imread(handles.videofile);
        end
        imshow(mov);
    end


else
    
    axes(handles.axes1);
    hold on
    if ~isempty(handles.videofile) 
        if strcmp(handles.ext,'.avi') || strcmp(handles.ext,'.AVI')|| strcmp(handles.ext,'.mpg') || strcmp(handles.ext,'.MPG') || strcmp(handles.ext,'.MOV')
                mov = read(handles.video, handles.frame);
            elseif strcmp(handles.ext,'.seq')
                [mov, ~, handles.totalframes] = readsinglestreampix(handles.videofile,handles.frame);
            elseif  strcmp(handles.ext,'.tif')|| strcmp(handles.ext,'.jpg') || strcmp(handles.ext,'.bmp')
                mov =imread(handles.videofile);
        end
        imshow(mov);
    end
    
%     maxx=handles.originX-(handles.Fx(handles.frame*handles.Cfact)*10);
    maxx=handles.originX-(handles.Fx(handles.frame*handles.Cfact)*10);%23/5/2014 angled videos
    maxz=handles.originY-(handles.Fz(handles.frame*handles.Cfact)*10);
    
    x=[handles.originX maxx];
    y=[handles.originY maxz];
    plot(x,y, '-r', 'LineWidth',2)
    hold off
    
end


        
guidata(hObject, handles);

% --- Executes on button press in pushbutton2_force.
function pushbutton2_force_Callback(hObject, eventdata, handles)

cd ('F:\quoll videos\quoll forces\forces');
%cd ('H:\research backup\quoll beam study');
% cd ('E:\Quoll gait paper');

[handles.datafilename, handles.pathname]=uigetfile({'*.*'},'pick data file');

if handles.datafilename==0
    return
end

handles.datafile = fullfile(handles.pathname,handles.datafilename);
[blub1,name,handles.extd] = fileparts(handles.datafile);

% set(handles.edit1,'String', handles.datafilename);
% set(handles.edit3_file,'String', handles.datafilename);

% addpath(handles.pathname)
% cd(handles.pathname)

fid = fopen(handles.datafile);

handles.M=dlmread(handles.datafile,'\t');

% fclose(handles.datafile);
% handles.trim=str2double(get(handles.edit13_trim, 'String'));

guidata(hObject, handles);
mycalc(hObject, eventdata, handles)

function mycalc(hObject, eventdata, handles)

totf=str2double(get(handles.edit3_totalframes, 'String'));

trigger=round(str2double(get(handles.edit11_trig, 'String')));
tno=str2double(get(handles.edit12_TFN, 'String'));
% trigger=9254;

framerate=str2double(get(handles.edit10_FR, 'String'));
samplingF=str2double(get(handles.edit9_Freq, 'String'));
handles.Cfact=samplingF/framerate;


handles.Fx=handles.M((trigger-(totf*handles.Cfact)):trigger,1);
handles.Fy=handles.M((trigger-(totf*handles.Cfact)):trigger,2);
handles.Fz=handles.M((trigger-(totf*handles.Cfact)):trigger,3);
handles.Tx=handles.M((trigger-(totf*handles.Cfact)):trigger,4);
handles.Ty=handles.M((trigger-(totf*handles.Cfact)):trigger,5);
handles.Tz=handles.M((trigger-(totf*handles.Cfact)):trigger,6);
handles.time=1:length(handles.Fx);
%handles.triggervect=handles.M(7,:);
%handles.trigtime=1:length(handles.triggervect);


guidata(hObject, handles);
mydisp(hObject, eventdata, handles)

function mydisp(hObject, eventdata, handles)

axes(handles.axes2);
        plot(handles.time,handles.Fx,'-r','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);
        hold on
        plot(handles.time,handles.Fy,'-b','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',1);
        plot(handles.time,handles.Fz,'-g','LineWidth',1,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',1);
        hold off
        legend('X','Y','Z','Location','northwest');
        vline(handles.frame*handles.Cfact) 
        
 axes(handles.axes3); 
 plot(handles.time,handles.Tx,'-r','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);
%  hold on
%  plot(handles.time,handles.Tx_old,'-b','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',1);
%  hold off
 legend('TorqueX','Location','northwest');   
 vline(handles.frame*handles.Cfact)   
 
 %export_fig('E:/Quoll gait paper/figures/myfig', '-jpg');
 %imwrite('myfig.jpg')
    
guidata(hObject, handles);

% --- Executes on button press in pushbutton3_forward.
function pushbutton3_forward_Callback(hObject, eventdata, handles)
step=str2double(get(handles.edit1_step, 'String'));

for i=handles.frame+1:step:handles.totalframes
    handles.frame=i;
    guidata(hObject,handles);
    set(handles.slider1,'Value',handles.frame);
    set(handles.edit5_frame,'String',num2str(handles.frame));
    mydisplay(hObject, eventdata, handles);
    mydisp(hObject, eventdata, handles);
    if get(handles.Stop,'Value')
        set(handles.Stop,'Value',0)
        break
    end
end

% --- Executes on button press in pushbutton4_back.
function pushbutton4_back_Callback(hObject, eventdata, handles)
step=str2double(get(handles.edit1_step, 'String'));

for i=handles.frame:-step:1
    handles.frame=i;
    guidata(hObject,handles);
    set(handles.slider1,'Value',handles.frame);
    set(handles.edit5_frame,'String',num2str(handles.frame));
    mydisplay(hObject, eventdata, handles);
    mydisp(hObject, eventdata, handles);
    if get(handles.Stop,'Value')
        set(handles.Stop,'Value',0)
        break
    end
end

function edit1_step_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit1_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit2_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit2_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_totalframes_Callback(hObject, eventdata, handles)
% hObject    handle to edit3_totalframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit3_totalframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3_totalframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_frame_Callback(hObject, eventdata, handles)
% hObject    handle to edit5_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit5_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton6_minus.
function pushbutton6_minus_Callback(hObject, eventdata, handles)
step=str2double(get(handles.edit1_step, 'String'));

handles.frame = handles.frame-step;
if handles.frame>handles.totalframes
    handles.frame=handles.totalframes;
end
set(handles.slider1,'Value',handles.frame);
set(handles.edit5_frame,'String',num2str(handles.frame));

guidata(hObject,handles);
mydisplay(hObject, eventdata, handles);
mydisp(hObject, eventdata, handles);

% --- Executes on button press in pushbutton7_plus.
function pushbutton7_plus_Callback(hObject, eventdata, handles)
step=str2double(get(handles.edit1_step, 'String'));

handles.frame = handles.frame+step;
if handles.frame>handles.totalframes
    handles.frame=handles.totalframes;
end
set(handles.slider1,'Value',handles.frame);
set(handles.edit5_frame,'String',num2str(handles.frame));

guidata(hObject,handles);
mydisplay(hObject, eventdata, handles);
mydisp(hObject, eventdata, handles);

% --- Executes on button press in pushbutton8_calvid.
function pushbutton8_calvid_Callback(hObject, eventdata, handles)
%analyze force button

if get(handles.radiobutton1,'value')==0
% pick force area (not using FF and ES)
xmin=[];
xmax=[];
xmin1=[];
xmax1=[];
[x,y]=ginput(2);
xmin=round(x(1));
xmin1=xmin(1);
xmax=round(x(2));
xmax1=xmax(1);
                if xmin1<0
                    xmin1=1;
                end
                if xmin1>xmax1
                    xmax1=xmin1;
                    xmin1=xmax1;
                else
                    xmin1=xmin1;
                    xmax1=xmax1;
                end
else
   %use FF and ES
    xmin1=round(str2double(get(handles.edit6_FF, 'String'))*handles.Cfact);
    xmax1=round(str2double(get(handles.edit7_ES, 'String'))*handles.Cfact);
end

    if get(handles.radiobutton17,'value')==1
     %nano17
        zaxis=handles.Z(xmin1:xmax1);
        [maxZ,I]=min(zaxis);
        maxZ
        Q = trapz(zaxis);
        firsthalf=zaxis(1:I);
        Q1=trapz(firsthalf);
        
        for i=2:length(zaxis)
            segments=zaxis(1:i);
            Q3=trapz(segments);
            perint2(i)=Q3/Q;
        end
        indperint=find(perint2>0.5);
        axes(handles.axes4);
        plot(perint2)
        x = indperint(1);
        y = 0.5;
        line('XData', [x x 0], 'YData', [0 y y], 'LineWidth', 2, ...
            'LineStyle', '-.', 'Color', [0.2 0.4 1.0]);
        
    else
        %custom built force plate condition
        xx=csvread('forceplatepos.csv');
        handles.xaxis=xx(:,3);
        handles.yaxis=xx(:,2);
        mmfsel=handles.mmfront(xmin1:xmax1);
        mmlsel=handles.mmleft(xmin1:xmax1);
        zaxis=handles.sumz(xmin1:xmax1);
        [maxZ,I]=max(zaxis);

        %flip axis to match video
        if get(handles.radiobutton14_rc,'value')==1       
        % mmlsel=110-mmlsel;
        % mmfsel=110-mmfsel;
        end
        
        percentmax=I/length(zaxis);
        firsthalf=zaxis(1:I);
        Q1=trapz(firsthalf);
        secondhalf=zaxis(I:end);
        Q2=trapz(secondhalf);
        Q = trapz(zaxis);
        perint=Q1/Q;

        for i=2:length(zaxis)
            segments=zaxis(1:i);
            Q3=trapz(segments);
            perint2(i)=Q3/Q;
        end
        indperint=find(perint2>0.5);
        perint3=indperint(1)/length(perint2);
        midstance=round(length(perint2)/2);
        permid=perint2(midstance);
        axes(handles.axes4);
        plot(perint2)
        x = indperint(1);
        y = 0.5;
        line('XData', [x x 0], 'YData', [0 y y], 'LineWidth', 2, ...
            'LineStyle', '-.', 'Color', [0.2 0.4 1.0]);
        handles.xvect=[];%lateral
        handles.yvect=[];%fore-aft
        handles.Zvect=[];
        handles.mmlsel=[];
        handles.mmfsel=[];

% make vectors to show on video 
    for i=1:length(handles.sumz_N)    
    if i<xmin1
        handles.Zvect(i)=NaN;
        handles.Yvect(i)=NaN;
        handles.Xvect(i)=NaN;
        handles.mmlsel(i)=NaN;
        handles.mmfsel(i)=NaN;
    elseif i>=xmin1 && i<=xmax1
        handles.Zvect(i)=handles.sumz_N(i);
        handles.Yvect(i)=handles.Y_N(i);%fore-aft
        handles.Xvect(i)=handles.X_N(i);
        handles.mmfsel(i)=handles.mmfront(i);
        handles.mmlsel(i)=handles.mmleft(i);
    elseif i>xmax1
        handles.Zvect(i)=NaN;
        handles.Yvect(i)=NaN;
        handles.Xvect(i)=NaN;
        handles.mmlsel(i)=NaN;
        handles.mmfsel(i)=NaN;
    end
    end

    %plot COP graph, with the first point as a cross
    axes(handles.axes3);
        plot(handles.xaxis,handles.yaxis,'+r','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',10);
        hold on
        plot(handles.mmfsel,handles.mmlsel,'ob','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',5);
        plot(mmfsel(1),mmlsel(1),'xb','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
        hold off
        axis([0,110,0,110])

             if get(handles.radiobutton10, 'value') ==1
                 %top - to save the data

                FF=str2double(get(handles.edit6_FF, 'String'));
                ES=str2double(get(handles.edit7_ES, 'String'));
                trigger=str2double(get(handles.edit11_trig, 'String'));
                smoothfact=str2double(get(handles.edit8_filt, 'String'));
                peakforce=max(handles.sumz_N(xmin1:xmax1));

            %    fid = fopen('C:\Users\DrChris\Desktop\force_sym.txt','a+');
            %    fid = fopen('C:\Users\DrClemente\Desktop\force_sym.txt','a+');
             fid = fopen('C:\Users\ccleme\Desktop\force_sym.txt','a+');
             fprintf(fid, '%s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,FF,ES,trigger,smoothfact,perint3,permid,peakforce);
             fclose(fid);
             end
 
    end
    %endscase for nano 17

 guidata(hObject,handles);

% --- Executes on button press in pushbutton9_loadFF.
function pushbutton9_loadFF_Callback(hObject, eventdata, handles)


[datafilename3, pathname3]=uigetfile({'*.*'},'pick data file');

if datafilename3==0
    return
end

datafile3 = fullfile(pathname3,datafilename3);
[blub1,name,handles.extd] = fileparts(datafile3);

fid = fopen(datafile3);
handles.COP=dlmread(datafile3,',',1,0);
fclose(fid);

data2=handles.COP(1:4,1:3);

C2=700-data2(:,2);%y axis inverted on plot for some reason ~ 700 = pixel height
axes(handles.axes1);
hold on
plot(data2(:,1),C2,'o','MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
hold off

fileID = fopen('Step_distance_data_quolls_mod.csv');
C = textscan(fileID,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'});
fclose(fileID);

IndexC =  strcmp(C{1,1}(1:end),datafilename3);
C4 = horzcat(C{1,12}, C{1,13}, C{1,14}, C{1,15}, C{1,16}, C{1,17}, C{1,18}, C{1,19});
COP = C4(IndexC,:);

Grid = [0.05 0.05; 0.05 -0.05; -0.05 0.05; -0.05 -0.05];


HLx=[COP(1),COP(3)];
HLy=[COP(2),COP(4)];

FLx=[COP(5),COP(7)];
FLy=[COP(6),COP(8)];

axes(handles.axes3);
plot(Grid(:,1),Grid(:,2),'+r','MarkerSize',30)
hold on
plot(HLx,HLy,'.g','MarkerSize',30)
plot(mean(HLx),mean(HLy),'og','MarkerSize',10)
plot(FLx,FLy,'.b','MarkerSize',30)
plot(mean(FLx),mean(FLy),'ob','MarkerSize',10)
legend('G','HL','FL')
hold off
axis equal
grid on


set(handles.radiobutton18,'value',1)

% set(handles.edit6_FF,'String',num2str(handles.frame));

guidata(hObject,handles);

function edit6_FF_Callback(hObject, eventdata, handles)
% hObject    handle to edit6_FF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit6_FF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6_FF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_ES_Callback(hObject, eventdata, handles)
% hObject    handle to edit7_ES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit7_ES_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7_ES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton10_FF.
function pushbutton10_FF_Callback(hObject, eventdata, handles)
[x,y]=ginput(2);
handles.originx=x(1);
handles.originx2=x(2);

Fxtrim=handles.Fx(x(1):x(2));
Fytrim=handles.Fy(x(1):x(2));
Fztrim=handles.Fz(x(1):x(2));
Txtrim=handles.Tx(x(1):x(2));

minFx=min(Fxtrim);
maxFx=max(Fxtrim);
minFy=min(Fytrim);
maxFy=max(Fytrim);
minFz=min(Fztrim);
maxFz=max(Fztrim);
Qx = trapz(Fxtrim);
Qy = trapz(Fytrim);
Qz = trapz(Fztrim);

minTx=min(Txtrim);
maxTx=max(Txtrim);
Qtx = trapz(Txtrim);


if get(handles.radiobutton9_or, 'value')==1
    surf='angle';
end

if get(handles.radiobutton15_left, 'value')==1
    surf='flat';
end

if get(handles.radiobutton13, 'value')==1
    surf='pole';
end

set(handles.edit24,'string',num2str(minFx));
name=get(handles.edit17_cop,'string');

if get(handles.radiobutton19, 'value')==1
    order='lead';
else
    order='trail';
end

fid = fopen('C:\Users\Skynet\Desktop\Trialdata.txt','a+');
% fid = fopen('I:\Quoll gait paper\Trialdata_corrected.txt','a+');

  %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
  fprintf(fid, '%s\t %s\t  %s\t  %s\t %s\t  %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,name,surf,'FL',order, minFx,maxFx,minFy,maxFy,minFz,maxFz,Qx,Qy,Qz,x(1),x(2),minTx,maxTx,Qtx);
  fclose(fid);

% --- Executes on button press in pushbutton11_ES.
function pushbutton11_ES_Callback(hObject, eventdata, handles)
[x,y]=ginput(2);
handles.originx=x(1);
handles.originx2=x(2);

Fxtrim=handles.Fx(x(1):x(2));
Fytrim=handles.Fy(x(1):x(2));
Fztrim=handles.Fz(x(1):x(2));
Txtrim=handles.Tx(x(1):x(2));

minFx=min(Fxtrim);
maxFx=max(Fxtrim);
minFy=min(Fytrim);
maxFy=max(Fytrim);
minFz=min(Fztrim);
maxFz=max(Fztrim);
Qx = trapz(Fxtrim);
Qy = trapz(Fytrim);
Qz = trapz(Fztrim);

minTx=min(Txtrim);
maxTx=max(Txtrim);
Qtx = trapz(Txtrim);


if get(handles.radiobutton9_or, 'value')==1
    surf='angle';
end

if get(handles.radiobutton15_left, 'value')==1
    surf='flat';
end

if get(handles.radiobutton13, 'value')==1
    surf='pole';
end

set(handles.edit23,'string',num2str(minFx));
name=get(handles.edit17_cop,'string');

if get(handles.radiobutton19, 'value')==1
    order='lead';
else
    order='trail';
end

fid = fopen('C:\Users\Skynet\Desktop\Trialdata.txt','a+');
  %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
  fprintf(fid, '%s\t %s\t  %s\t  %s\t %s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,name,surf,'FR',order,minFx,maxFx,minFy,maxFy,minFz,maxFz,Qx,Qy,Qz,x(1),x(2),minTx,maxTx,Qtx);
  fclose(fid);

function edit8_filt_Callback(hObject, eventdata, handles)
% hObject    handle to edit8_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit8_filt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8_filt (see GCBO)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)

function edit9_Freq_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit9_Freq_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit10_FR_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit10_FR_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton3_side.
function radiobutton3_side_Callback(hObject, eventdata, handles)
set(handles.radiobutton4_2d,'value',0)

% --- Executes on button press in radiobutton4_2d.
function radiobutton4_2d_Callback(hObject, eventdata, handles)
set(handles.radiobutton3_side,'value',0)

function edit11_trig_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit11_trig_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton15_fr.
function pushbutton15_fr_Callback(hObject, eventdata, handles)

trignum=str2double(get(handles.edit11_trig,'string'));
newtrig=trignum+handles.Cfact;
set(handles.edit11_trig,'string',num2str(newtrig));



mycalc(hObject, eventdata, handles)

function edit12_TFN_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit12_TFN_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton5_bi.
function radiobutton5_bi_Callback(hObject, eventdata, handles)
set(handles.radiobutton6_Q,'value',0)

% --- Executes on button press in radiobutton6_Q.
function radiobutton6_Q_Callback(hObject, eventdata, handles)
set(handles.radiobutton5_bi,'value',0)

% --- Executes on button press in radiobutton7_f.
function radiobutton7_f_Callback(hObject, eventdata, handles)
set(handles.radiobutton8_h,'value',0)

% --- Executes on button press in radiobutton8_h.
function radiobutton8_h_Callback(hObject, eventdata, handles)
set(handles.radiobutton7_f,'value',0)

% --- Executes on button press in pushbutton16_trim.
function pushbutton16_trim_Callback(hObject, eventdata, handles)
handles.trim=str2double(get(handles.edit13_trim, 'String'));
mycalc(hObject, eventdata, handles)

function edit13_trim_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit13_trim_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton17_trigger.
function pushbutton17_trigger_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton18_checkforce.
function pushbutton18_checkforce_Callback(hObject, eventdata, handles)

%Retrieve .txt file with original calibration matrix coefficients%
OriginalMatrix=dlmread('Nano17_Calib34_Original.txt','\t');

Fxtrim=handles.Fx;
Fytrim=handles.Fy;
Fztrim=handles.Fz;
Txtrim=handles.Tx;
Tytrim=handles.Ty;
Tztrim=handles.Tz;
trimtime=1:length(Tztrim);

%Convert original forces and torques back to volts%
OriginalForcesTorques=horzcat(Fxtrim,Fytrim,Fztrim,Txtrim,Tytrim,Tztrim);

Volts=(inv(OriginalMatrix)*OriginalForcesTorques')';

V1=Volts(:,1);
V2=Volts(:,2);
V3=Volts(:,3);
V4=Volts(:,4);
V5=Volts(:,5);
V6=Volts(:,6);

axes(handles.axes4); 
    plot(trimtime,V1,'-r','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);     
    hold on     
    plot(trimtime,V2,'-b','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);     
    hold on    
    plot(trimtime,V3,'-g','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);     
    hold on    
    plot(trimtime,V4,'-k','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);
    hold on    
    plot(trimtime,V5,'-m','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);
    hold on    
    plot(trimtime,V6,'-y','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);
    hold off
    legend('V1','V2','V3','V4','V5','V6','Location','northwest');

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%EDIT FORCES HERE TO CORRECT FOR 45 DEG ANGLE    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%angle case 
if get(handles.radiobutton9_or,'value')==1  
    angle=-38;
    Fx_corrected=Fxtrim*cosd(angle)-Fztrim*sind(angle);
    Fz_corrected=Fxtrim*sind(angle)+Fztrim*cosd(angle);
    handles.Fx=Fx_corrected;
    handles.Fz=Fz_corrected;
end

%pole case
if get(handles.radiobutton13,'value')==1  
    angle=-38;
    Fxtrim=Fxtrim*-1;
    Fytrim=Fytrim*-1;
    Fx_corrected=Fxtrim*cosd(angle)-Fztrim*sind(angle);
    Fz_corrected=Fxtrim*sind(angle)+Fztrim*cosd(angle);
    handles.Fx=Fx_corrected;
    handles.Fz=Fz_corrected;
    handles.Fy=Fytrim;

    handles.Tx=handles.Tx*-1;
    tx_corrected=handles.Tx-handles.Fy*23.4;
    handles.Tx_old=handles.Tx;
    handles.Tx=tx_corrected;

end



guidata(hObject,handles);
mydisp(hObject, eventdata, handles)

% --- Executes on button press in radiobutton9_or.
function radiobutton9_or_Callback(hObject, eventdata, handles)
set(handles.radiobutton15_left,'value',0)
set(handles.radiobutton13,'value',0)


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton19_estGRF.
function pushbutton19_estGRF_Callback(hObject, eventdata, handles)
[x,y]=ginput(2);
handles.originx=x(1);
handles.originx2=x(2);
handles.originy=y(1);
handles.califactor=(x(2)-x(1))/110;%pix / mm
set(handles.radiobutton9_or, 'value', 1)
guidata(hObject,handles);
mydisplay(hObject, eventdata, handles)

% --- Executes on button press in pushbutton20_dots.
function pushbutton20_dots_Callback(hObject, eventdata, handles)


4

[datafilename, pathname]=uigetfile({'*.*'},'pick data file');

if datafilename==0
    return
end

datafile = fullfile(pathname,datafilename);
[blub1,name,extd] = fileparts(datafile);

% set(handles.edit1,'String', handles.datafilename);
% set(handles.edit3_file,'String', handles.datafilename);

% addpath(pathname)
% cd(pathname)

fid = fopen(datafile);
handles.N=dlmread(datafile,',',1,0);
fclose(fid);
set(handles.radiobutton11,'value',1);
guidata(hObject,handles);

% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
set(handles.radiobutton9_or,'value',0)
set(handles.radiobutton15_left,'value',0)

% --- Executes on button press in pushbutton21_loadgrf.
function pushbutton21_loadgrf_Callback(hObject, eventdata, handles)



[datafilename, pathname]=uigetfile({'*.*'},'pick data file');

if datafilename==0
    return
end

datafile = fullfile(pathname,datafilename);
[blub1,name,extd] = fileparts(datafile);

fid = fopen(datafile);
handles.G=dlmread(datafile,',',1,0);
fclose(fid);

if get(handles.radiobutton14_rc,'value')==1
handles.califactor=(handles.G(16,1)-handles.G(13,1))/90;%90mm distance between points on FP
handles.califactory=(handles.G(1,2)-handles.G(13,2))/90;
handles.originx=mean([handles.G(13,1),handles.G(9,1),handles.G(5,1),handles.G(1,1)]);
handles.originy=mean([handles.G(13,2),handles.G(14,2),handles.G(15,2),handles.G(16,2)]);
% handles.originx=handles.G(13,1);
% handles.originy=handles.G(13,2);
else
handles.califactor=(handles.G(13,1)-handles.G(16,1))/90;
handles.califactory=(handles.G(13,2)-handles.G(1,2))/90;
handles.originx=mean([handles.G(4,1),handles.G(8,1),handles.G(12,1),handles.G(16,1)]);
handles.originy=mean([handles.G(4,2),handles.G(3,2),handles.G(2,2),handles.G(1,2)]);
end

% y=handles.califactory
% x=handles.califactor
set(handles.radiobutton13, 'value', 1)
guidata(hObject,handles);

% --- Executes on button press in pushbutton22_savecop.
function pushbutton22_savecop_Callback(hObject, eventdata, handles)

     
%computation of rotation matrix. rotation is about X axis
%rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];
%hip=handles.N(FF+offset:ES+offset,3:4);
%hip=hip';
%Hiprot=rot*hip;%-poly(2)*cos(theta0);   % <- change here

  fid = fopen('C:\Users\ccleme\Desktop\Trialdata.txt','a+');
  %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
  fprintf(fid, '%s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %s\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,FF,ES,xmm_cop,ymm_cop,zsf,xsf,ysf,offset,handles.califactor, handles.ctx, handles.cty);
  fclose(fid);
 
function edit14_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit14_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit14_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
%plus trigger??
trignum=str2double(get(handles.edit11_trig,'string'));
newtrig=trignum-handles.Cfact;
set(handles.edit11_trig,'string',num2str(newtrig));
mycalc(hObject, eventdata, handles)% hObject    handle to pushbutton23 (see GCBO)

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in radiobutton14_rc.
function radiobutton14_rc_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14_rc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton24_mod.
function pushbutton24_mod_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit15_mod_Callback(hObject, eventdata, handles)
% hObject    handle to edit15_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit15_mod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton15_left.
function radiobutton15_left_Callback(hObject, eventdata, handles)
set(handles.radiobutton9_or,'value',0)
set(handles.radiobutton13,'value',0)

% --- Executes on button press in pushbutton25_accel.
function pushbutton25_accel_Callback(hObject, eventdata, handles)

FF=str2double(get(handles.edit6_FF, 'String'));
ES=str2double(get(handles.edit7_ES, 'String'));
fps=str2double(get(handles.edit10_FR, 'String'));
smoothfact=str2double(get(handles.edit8_filt, 'String'));

datafilename=get(handles.edit2_filename,'String');


fid = fopen('C:\Users\ccleme\Desktop\Speed_accel.txt','a+');
          %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
 fprintf(fid, '%s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',datafilename,FF,ES,fps,smoothfact,handles.mspeed,handles.maccel);
 fclose(fid); 

% --- Executes on button press in pushbutton26_pts.
function pushbutton26_pts_Callback(hObject, eventdata, handles)

[x,y]=ginput(1);

handles.originX=x;
handles.originY=y;

set(handles.radiobutton19,'Value',1);

% [datafilename2, pathname]=uigetfile({'*.*'},'pick data file');
% 
% if datafilename2==0
%     return
% end
% 
% datafile = fullfile(pathname,datafilename2);
% [blub1,name,extd] = fileparts(datafile);
% 
% % set(handles.edit1,'String', handles.datafilename);
% set(handles.edit2_filename,'String',datafilename2);
% 
% % addpath(pathname)
% % cd(pathname)
% 
% fid = fopen(datafile);
% handles.S=dlmread(datafile,',',1,0);
% fclose(fid);
% 
% FF=str2double(get(handles.edit6_FF, 'String'));
% ES=str2double(get(handles.edit7_ES, 'String'));
% fps=str2double(get(handles.edit10_FR, 'String'));
% 
% distMM_or=sqrt(diff(handles.S(FF:ES,28)).^2+diff(handles.S(FF:ES,29)).^2+diff(handles.S(FF:ES,30)).^2);
% distM_or=distMM_or./1000;
% speedM_or=distM_or*fps;
% handles.speedM_or=speedM_or;
% 
% time2_or=1:length(handles.speedM_or);
% axes(handles.axes2);
% plot(time2_or,handles.speedM_or,'or')

guidata(hObject,handles);

% --- Executes on button press in pushbutton27_smpts.
function pushbutton27_smpts_Callback(hObject, eventdata, handles)

smoothfact=str2double(get(handles.edit8_filt, 'String'));
fps=str2double(get(handles.edit10_FR, 'String'));

% FF=str2double(get(handles.edit6_FF, 'String'));
% ES=str2double(get(handles.edit7_ES, 'String'));
% 
% x=handles.S(FF:ES,28);
% y=handles.S(FF:ES,29);
% z=handles.S(FF:ES,30);
% 
% time=1:length(x);
% 
% [spX,valuesX] = spaps(time,x,smoothfact);
% valuesX=valuesX';
% 
% [spX,valuesY] = spaps(time,y,smoothfact);
% valuesY=valuesY';
% 
% [spX,valuesZ] = spaps(time,z,smoothfact);
% valuesZ=valuesZ';
% 
% distMM=sqrt(diff(valuesX).^2+diff(valuesY).^2+diff(valuesZ).^2);
% distM=distMM./1000;
% speedM=distM*fps;
% handles.speedM=speedM;

% distMM_or=sqrt(diff(handles.S(FF:ES,28)).^2+diff(handles.S(FF:ES,29)).^2+diff(handles.S(FF:ES,30)).^2);
% distM_or=distMM_or./1000;
% speedM_or=distM_or*fps;
% handles.speedM_or=speedM_or;

time2_or=1:length(handles.speedM_or);
[spX,valuesZ] = spaps(time2_or,handles.speedM_or,smoothfact);
speedM=valuesZ';

time1=1:length(speedM);


accel=diff(speedM).*fps;
time3=1:length(accel);

axes(handles.axes2);
plot(time2_or,handles.speedM_or,'or')
hold on
plot(time1,speedM,'-b')
hold off

axes(handles.axes4);
plot(time3,accel,'-g')

handles.maccel=mean(accel);
handles.mspeed=mean(speedM);

guidata(hObject,handles);

% --- Executes on button press in pushbutton28_del.
function pushbutton28_del_Callback(hObject, eventdata, handles)
[x,y]=ginput(1);
x1=round(x(1));

handles.speedM_or=[handles.speedM_or(1:x1-1);handles.speedM_or(x1+1:end)];
time2_or=1:length(handles.speedM_or);
axes(handles.axes2);
plot(time2_or,handles.speedM_or,'or')

guidata(hObject,handles);

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit17_cop_Callback(hObject, eventdata, handles)
% hObject    handle to edit17_cop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit17_cop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17_cop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton16_COP.
function radiobutton16_COP_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16_COP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton29_crossT.
function pushbutton29_crossT_Callback(hObject, eventdata, handles)

xmm=str2double(get(handles.edit17_cop, 'String'));
ymm=str2double(get(handles.edit18_ymm, 'String'));

cross_talk_yaxis=crossTY(xmm,ymm);
cross_talk_xaxis=crossTX(xmm,ymm);

handles.X_N_old=handles.X_N;
handles.Y_N_old=handles.Y_N;

newX=handles.X2-handles.sumz.*cross_talk_xaxis;
newY=handles.Y2-handles.sumz.*cross_talk_yaxis;

handles.ctx=cross_talk_xaxis;
handles.cty=cross_talk_xaxis;

% test=handles.X2(2500)
% test2=handles.sumz(2500)
% test3=newX(2500)

%convert to Newtons
% handles.sumz_N=handles.sumz./0.2573;
handles.X_N=newX./0.063286;%lateral
handles.Y_N=newY./0.09606;%fore-aft


%%%%CORRECTING FOR CHANGES IN FP ORIGIN
handles.Y_N=handles.Y_N*-1;%Agil1-4 only?? 23/01/2015
handles.X_N=handles.X_N*-1;%Agil1-4 only

axes(handles.axes2);
    plot(handles.time',handles.sumz_N,'-r','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',1);
    hold on
    plot(handles.time',handles.X_N,'-b','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',1);
    plot(handles.time',handles.X_N_old,'--b','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',1);
    plot(handles.time',handles.Y_N,'-g','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',1);
    plot(handles.time',handles.Y_N_old,'--g','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',1);
    hold off
    
guidata(hObject,handles);
    
function edit18_ymm_Callback(hObject, eventdata, handles)
% hObject    handle to edit18_ymm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit18_ymm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18_ymm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton30_FF.
function pushbutton30_FF_Callback(hObject, eventdata, handles)
[x,y]=ginput(2);
handles.originx=x(1);
handles.originx2=x(2);

Fxtrim=handles.Fx(x(1):x(2));
Fytrim=handles.Fy(x(1):x(2));
Fztrim=handles.Fz(x(1):x(2));
Txtrim=handles.Tx(x(1):x(2));

minFx=min(Fxtrim);
maxFx=max(Fxtrim);
minFy=min(Fytrim);
maxFy=max(Fytrim);
minFz=min(Fztrim);
maxFz=max(Fztrim);
Qx = trapz(Fxtrim);
Qy = trapz(Fytrim);
Qz = trapz(Fztrim);

minTx=min(Txtrim);
maxTx=max(Txtrim);
Qtx = trapz(Txtrim);

if get(handles.radiobutton9_or, 'value')==1
    surf='angle';
end

if get(handles.radiobutton15_left, 'value')==1
    surf='flat';
end

if get(handles.radiobutton13, 'value')==1
    surf='pole';
end

set(handles.edit19,'string',num2str(minFx));
name=get(handles.edit17_cop,'string');

order='both';

fid = fopen('C:\Users\Skynet\Desktop\Trialdata.txt','a+');
  %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
  fprintf(fid, '%s\t %s\t  %s\t  %s\t %s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,name,surf,'FF',order,minFx,maxFx,minFy,maxFy,minFz,maxFz,Qx,Qy,Qz,x(1),x(2),minTx,maxTx,Qtx);
  fclose(fid);


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
[x,y]=ginput(2);
handles.originx=x(1);
handles.originx2=x(2);

Fxtrim=handles.Fx(x(1):x(2));
Fytrim=handles.Fy(x(1):x(2));
Fztrim=handles.Fz(x(1):x(2));
Txtrim=handles.Tx(x(1):x(2));

minFx=min(Fxtrim);
maxFx=max(Fxtrim);
minFy=min(Fytrim);
maxFy=max(Fytrim);
minFz=min(Fztrim);
maxFz=max(Fztrim);
Qx = trapz(Fxtrim);
Qy = trapz(Fytrim);
Qz = trapz(Fztrim);

minTx=min(Txtrim);
maxTx=max(Txtrim);
Qtx = trapz(Txtrim);

if get(handles.radiobutton9_or, 'value')==1
    surf='angle';
end

if get(handles.radiobutton15_left, 'value')==1
    surf='flat';
end

if get(handles.radiobutton13, 'value')==1
    surf='pole';
end

set(handles.edit21,'string',num2str(minFx));
name=get(handles.edit17_cop,'string');

if get(handles.radiobutton19, 'value')==1
    order='lead';
else
    order='trail';
end

fid = fopen('C:\Users\Skynet\Desktop\Trialdata.txt','a+');
  %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
  fprintf(fid, '%s\t %s\t  %s\t %s\t  %s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,name,surf,'HL',order,minFx,maxFx,minFy,maxFy,minFz,maxFz,Qx,Qy,Qz,x(1),x(2),minTx,maxTx,Qtx);
  fclose(fid);

% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
[x,y]=ginput(2);
handles.originx=x(1);
handles.originx2=x(2);

Fxtrim=handles.Fx(x(1):x(2));
Fytrim=handles.Fy(x(1):x(2));
Fztrim=handles.Fz(x(1):x(2));
Txtrim=handles.Tx(x(1):x(2));

minFx=min(Fxtrim);
maxFx=max(Fxtrim);
minFy=min(Fytrim);
maxFy=max(Fytrim);
minFz=min(Fztrim);
maxFz=max(Fztrim);
Qx = trapz(Fxtrim);
Qy = trapz(Fytrim);
Qz = trapz(Fztrim);

minTx=min(Txtrim);
maxTx=max(Txtrim);
Qtx = trapz(Txtrim);


if get(handles.radiobutton9_or, 'value')==1
    surf='angle';
end

if get(handles.radiobutton15_left, 'value')==1
    surf='flat';
end

if get(handles.radiobutton13, 'value')==1
    surf='pole';
end

set(handles.edit22,'string',num2str(minFx));
name=get(handles.edit17_cop,'string');

if get(handles.radiobutton19, 'value')==1
    order='lead';
else
    order='trail';
end


fid = fopen('C:\Users\Skynet\Desktop\Trialdata.txt','a+');
  %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
  fprintf(fid, '%s\t %s\t  %s\t  %s\t %s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,name,surf,'HR',order,minFx,maxFx,minFy,maxFy,minFz,maxFz,Qx,Qy,Qz,x(1),x(2),minTx,maxTx,Qtx);
  fclose(fid);

% --- Executes on button press in pushbutton33_HF.
function pushbutton33_HF_Callback(hObject, eventdata, handles)
[x,y]=ginput(2);
handles.originx=x(1);
handles.originx2=x(2);

Fxtrim=handles.Fx(x(1):x(2));
Fytrim=handles.Fy(x(1):x(2));
Fztrim=handles.Fz(x(1):x(2));
Txtrim=handles.Tx(x(1):x(2));

minFx=min(Fxtrim);
maxFx=max(Fxtrim);
minFy=min(Fytrim);
maxFy=max(Fytrim);
minFz=min(Fztrim);
maxFz=max(Fztrim);
Qx = trapz(Fxtrim);
Qy = trapz(Fytrim);
Qz = trapz(Fztrim);

minTx=min(Txtrim);
maxTx=max(Txtrim);
Qtx = trapz(Txtrim);


if get(handles.radiobutton9_or, 'value')==1
    surf='angle';
end

if get(handles.radiobutton15_left, 'value')==1
    surf='flat';
end

if get(handles.radiobutton13, 'value')==1
    surf='pole';
end

set(handles.edit20,'string',num2str(maxFx));
name=get(handles.edit17_cop,'string');

order='both';

fid = fopen('C:\Users\Skynet\Desktop\Trialdata.txt','a+');
  %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
  fprintf(fid, '%s\t %s\t  %s\t  %s\t %s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',handles.datafilename,name,surf,'HH',order,minFx,maxFx,minFy,maxFy,minFz,maxFz,Qx,Qy,Qz,x(1),x(2),minTx,maxTx,Qtx);
  fclose(fid);

function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
set(handles.radiobutton20,'value',0)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
set(handles.radiobutton19,'value',0)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20
