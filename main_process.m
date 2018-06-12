%%
%Read Video
clear all; close all;
[NombreI1,PathName1] = uigetfile('*.*','Seleccione el video');
full_name = strcat(PathName1,NombreI1);
%clear all; close all;
%fullname = '/Users/yorjaggy/Google Drive/Icesi/Maestria/3.1. Vision Artificial/proyecto_vision_artificial/imgdata/vid.mp4';
obj = VideoReader(full_name);

%%
figure;
h = [];
%%
%Analize frame to frame
values_mmse = [0];
values_ssmi = [0];
initial_frame = readFrame(obj);
flag_frames=0;
while hasFrame(obj)
    if flag_frames==5
        vidFrame = readFrame(obj);

        %procesamiento frame n y n+1
        res_frame_n = func_process_eyes(initial_frame);
        h(2) = subplot(4,1,3);
        axis off;
        image(res_frame_n,'Parent',h(2));
        
        res_frame_n_plus_one = func_process_eyes(vidFrame);

        %ajuste de tamaños
        tamanos = min([size(res_frame_n);size(res_frame_n_plus_one)]);
        res_frame_n = res_frame_n(1:tamanos(1),1:tamanos(2));
        res_frame_n_plus_one = res_frame_n_plus_one(1:tamanos(1),1:tamanos(2));

        %comparacion con MMSE (Mean Squared Error)
        mmse_temporal = immse(res_frame_n,res_frame_n_plus_one);
        values_mmse = [values_mmse,mmse_temporal];

        % comparacion con SSIM (Structural Similarity Index)
        % ssmi_temporal = ssim(res_frame_n,res_frame_n_plus_one);
        % values_ssmi = [values_ssmi,ssmi_temporal ];

        %cambio de frame -> n+1 ahora es n
        initial_frame = vidFrame;

        %graficación de video
        h(1) = subplot(4,1,[1,2]);
        image(vidFrame,'Parent',h(1));
        axis off;
        pause(0.1/obj.FrameRate);

        %graficación de señal mmse
        h(4) = subplot(4,1,4);
        hold on;grid on
        
        p1 = plot(values_mmse,'Parent',h(4)); 
        if length(values_mmse)>3
            [~,locs] = findpeaks(values_mmse,'MinPeakHeight',2000);
            %t=1:length(values_mmse);
            p2 = plot(locs,values_mmse(locs),'rv','MarkerFaceColor','r','Parent',h(4));
            resultado = strcat('Pestañeos:',mat2str(length(locs)));
            legend([p1 p2], {'EMS',resultado});
        end
        
        ylim([0 5000]);
        title('Error Cuadrado Medio')
        
        %pause 2/10 second: 
        pause(0.1/obj.FrameRate);
        
        %reinicio de la bandera
        flag_frames = 0;
    else
        initial_frame = readFrame(obj);
        flag_frames=flag_frames+1;
    end
    
end