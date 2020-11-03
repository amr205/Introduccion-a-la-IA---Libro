clc
clear

function [historial, pred_valor] = predecirKNN(entrada,salida,nueva_instancia,k)
    num_inst = size(entrada,1);
    
    %Calcular distancia euclidea
    historial.distancias = sum((repelem(nueva_instancia,num_inst,1)-entrada).^2,2).^(1/2);
    %Obtener vecinos
    [~,idx] = sort(historial.distancias,'ascend');
    historial.vecinos = idx(1:k);
    
    salida_vecinos = salida(historial.vecinos,:);

    pred_valor = mean(salida_vecinos);
end

entrada = [4,1,2; 2,2,1; 2,1,4; 3,2,5; 1,1,3; 5,1,5; 5,2,4; 3,4,2; 3,2,6; 2,2,8; 3,4,2];
salida = [224000;113000;144000;212000;92000;260000;300000;175000;224000;194000;178000];
k = 2;
nueva_instancia = [4,2,5];

[hist,valor]=predecirKNN(entrada,salida,nueva_instancia,k);
hist
valor


