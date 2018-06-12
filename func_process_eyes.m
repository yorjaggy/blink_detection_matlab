function [ new_imagen ] = func_process_eyes( H )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%figure,imshow(Original);title('Imagen original');

%%
%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,H);


eyes_img = imcrop(H,BB(1,:));
%figure;imshow(eyes_img), title('Extracción de la zona de interes')
H=eyes_img;

%%
%Imagen a escala de grises
H= rgb2gray(H);
H = histeq(H);
%figure,imshow(H);title('Imagen en escala de grises');

%%
[~, threshold] = edge(H, 'sobel');
fudgeFactor = .7;
BWs = edge(H,'sobel', threshold * fudgeFactor);
%figure, imshow(BWs), title('Filtro Sobel para los bordes');

%%
%Rellenando
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

BWsdil = imdilate(BWs, [se90 se0]);
%figure, imshow(BWsdil), title('Dilatación con SE lineas H y  V');


%%
BWdfill = imfill(BWsdil,'holes');
%figure, imshow(BWdfill);
%title('Imagen binaria con relleno de bordes');

%% Cerradura a los bordes
se90 = strel('line', 10,90);
se0 = strel('line', 10,0);

BWs_90=imclose(BWs,se90);
BWdfill=imclose(BWs_90,se0);

%figure;imshow(BWdfill);title('Cerradura de bordes')

%%
BWnobord = imclearborder(BWdfill,1);
%figure, imshow(BWnobord), title('Limpieza de bordes de imagen');

%%
%Extracción de las zonas de la imagen que corresponden a los ojos
new_imagen = H;
new_imagen(~BWnobord) = 1;
%figure;imshow(new_imagen)

end

