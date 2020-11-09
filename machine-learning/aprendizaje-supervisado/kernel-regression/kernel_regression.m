clc
clear

function coeff = kernelUniforme(distances,lambda)
  coeff = (distances <= lambda)*(1/2);
endfunction

function coeff = kernelEpanechnikov(distances,lambda)
  coeff = (distances <= lambda)*(3/4).*(lambda^2-distances.^2);
endfunction

function coeff = kernelTriangular(distances,lambda)
  coeff = (distances <= lambda).*(lambda-abs(distances));
endfunction

function [historial, pred_valor] = predecirKernelRegression(entrada,salida,nueva_instancia,lambda,kernel)
    num_inst = size(entrada,1);
    
    %Calcular distancia euclidea
    historial.distancias = sum((repelem(nueva_instancia,num_inst,1)-entrada).^2,2).^(1/2);
    
    %Calcular coeficientes
    historial.coeff = kernel(historial.distancias,lambda);
    historial.sum_coeff = sum(historial.coeff);
    
    %Predecir valor
    pred_valor = (historial.coeff' * salida ) / historial.sum_coeff;
    
end

entrada = [4,1,2; 2,2,1; 2,1,4; 3,2,5; 1,1,3; 5,1,5; 5,2,4; 3,4,2; 3,2,6; 2,2,8; 3,4,2];
salida = [224000;113000;144000;212000;92000;260000;300000;175000;224000;194000;178000];
lambda = 2;
nueva_instancia = [4,2,5];

[hist,valor]=predecirKernelRegression(entrada,salida,nueva_instancia,lambda,@kernelEpanechnikov);
hist
valor


