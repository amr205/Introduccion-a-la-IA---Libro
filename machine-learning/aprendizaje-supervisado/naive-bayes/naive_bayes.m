clc
clear 

function GNB = entrenarGNB(entrada, salida)
    %Inicializar parametros del modelo
    GNB.clases = unique(salida,'rows');
    GNB.num_clases = length(GNB.clases);
    GNB.num_instancias = size(entrada,1);
    GNB.num_atributos = size(entrada,2);
    GNB.promedios = zeros(GNB.num_clases,GNB.num_atributos);
    GNB.desviaciones_std = zeros(GNB.num_clases,GNB.num_atributos);
    GNB.prob_clases = zeros(GNB.num_clases,1);
    
    %Aprender parametros
    for k = 1:GNB.num_clases
       temp = entrada(logical(prod(salida==GNB.clases(k,:),2)),:);
       GNB.promedios(k,:) = mean(temp);
       GNB.desviaciones_std(k,:) = std(temp,1);
       GNB.prob_clases(k,:) = length(temp)/GNB.num_instancias;
    end
endfunction

function [historial, clase] = predecirGNB(GNB,entrada)
    val_entrada = repelem(entrada,GNB.num_clases,1);

    %Calcular probabilidades de cada atributo respecto a cada clase
    historial.probabilidades = (ones(GNB.num_clases,GNB.num_atributos) ./ (sqrt(2 * 3.1416 * GNB.desviaciones_std.^2))) .* exp(-((val_entrada-GNB.promedios).^2./(2*GNB.desviaciones_std.^2)));
    historial.probabilidades_clases = prod(historial.probabilidades,2);
    historial.probabilidades_finales = historial.probabilidades_clases .*GNB.prob_clases;

    %(1/ (sqrt(2 * 3.1416) * 0.9192)) * exp(-((0.3-1.85^2)./(2*0.4^2)));

    %Predecir clase
    [~,idx] = max(historial.probabilidades_finales);
    clase = GNB.clases(idx,:);
endfunction


%Realizar entrenamiento
entrada = [ 5.2 , 1.2 ; 2.3, 5.4; 1.5, 4.4; 4.5, 2.1];
salida = [ 'B+'; 'A-'; 'A-'; 'B+'];

GNB = entrenarGNB(entrada, salida);

%Hacer prediccion
pred_entrada = [3.2,4.2];

[historial,clase] = predecirGNB(GNB,pred_entrada);
clase

%Hacer prediccion del ejercicio
pred_entrada = [6.5, 4.1];

[~,clase] = predecirGNB(GNB,pred_entrada);
clase


