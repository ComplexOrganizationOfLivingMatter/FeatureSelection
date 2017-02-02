function [cell,rect] = selectCell(fileName)
%Developed by Daniel Sanchez-Gutierrez
%Function known as recorte
%
% Modified by Pablo Vicente-Muneura

load (fileName)

cell=input('Introduzca el numero de la celula a capturar: ');
cell=num2str(cell);

im=imagesOfSerieByChannel;
pl=planos;
[H,W,~]=size(im{1,1});
Long=length(im);

%% Proyeccion de todos los planos
proyeccion=pl{1,1};
for k=1:Long-1
    maximo = max(proyeccion,pl{1,1+k});
    proyeccion=maximo;
end

figure, imshow(proyeccion),title('Proyeccion de todo los planos')
proy=proyeccion;

% Escogemos ROI

limite=2;
% figure, imshow(proy);
h = impositionrect(gca, [2 2 350 350]); % for older version of IP toolbox
api = iptgetapi(h);
fcn = makeConstrainToRectFcn('imrect',[limite W-limite],[limite H-limite]);
api.setPositionConstraintFcn(fcn);
%setResizable(h,0)
pause
[~, rect] = imcrop(proy,floor(api.getPosition())-1);
close;