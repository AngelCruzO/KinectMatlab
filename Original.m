clc
clear all;
imaqreset; %Resetea el objeto de imagenes

depthVid = videoinput('kinect',2);

%obtiene las propiedades del video de entrada
%depthSource = getselectedsource(depthVid);
%depthSource.EnableBodyTracking = 'on'; %Enciende el seguimiendo del puntos

%confuguracion del disparador
triggerconfig(depthVid,'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
set(getselectedsource(depthVid),'EnableBodyTracking','on');

%Inicio del video de profundidad
start(depthVid);
himg = figure; %crea un objeto figure

%ciclo para vizualizar los puntos en la figura
while ishandle(himg)
    trigger(depthVid);
    [depthMap,~,depthMetaData] = getdata(depthVid);
    imshow(depthMap,[0 4096]);
    
    %verifica si la suma del seguimiento del cuerpo es mayor a cero
    if sum(depthMetaData.IsBodyTracked)>0
        skeletonJoints = depthMetaData.DepthJointIndices(:,:,depthMetaData.IsBodyTracked);
        hold on;
        plot(abs(skeletonJoints(:,1)), skeletonJoints(:,2),'*');
        hold off;
    else
        imshow(depthMap, [0 4096]);
    end
end

stop(depthVid);
        