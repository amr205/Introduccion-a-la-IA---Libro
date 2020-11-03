clc
clear

function [historial, clase_pred] = predecirKNN(entrada,salida,nueva_instancia,k)
    num_inst = size(entrada,1);
    
    %Calcular distancia euclidea
    historial.distancias = sum((repelem(nueva_instancia,num_inst,1)-entrada).^2,2).^(1/2);
    %Obtener vecinos
    [~,idx] = sort(historial.distancias,'ascend');
    historial.vecinos = idx(1:k);
    
    clases_vecinos = salida(historial.vecinos,:);

    [valoresUnicos,~,idxClases] = unique(clases_vecinos,'rows');
    historial.clases_freq = accumarray(idxClases(:),1);
    
    [~,idx_freq] = sort(historial.clases_freq,'descend');
    clase_pred = valoresUnicos(idx_freq(1),:);
end

entrada = [ 0.4, 0.8, 0.2 ; 0.2, 0.7, 0.9; 0.9, 0.8, 0.9; 0.8, 0.1, 0.0];
salida = [ 'positiva'; 'positiva'; 'negativa'; 'negativa'];
k = 3;
nueva_instancia = [0.7,0.2,0.1];

[hist,clase]=predecirKNN(entrada,salida,nueva_instancia,k);
hist
clase


