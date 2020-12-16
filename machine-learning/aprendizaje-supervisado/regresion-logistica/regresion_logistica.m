clc
clear 

function [historial, valor,clase] = predecirRL(RL,entrada)
    historial.entrada = [ones(size(entrada,1),1),entrada];
    valor = 1./(1+e.^-(historial.entrada*RL.params));
    clase = valor>0.5;
endfunction


function [historial,RL] = entrenarRL_descensoGradiente(X, Y, max_iter, min_error,alpha)
    X_t = [ones(size(X,1),1),X];
    RL.params = rand(size(X_t,2),1)*0.01;
    n = size(X,1);
    
    for k=1:max_iter
        [~, preds,~] = predecirRL(RL,X);
        historial.error_f = -sum(Y.*log(preds)+(1-Y).*log(1-preds))/n;

        if historial.error_f <= min_error
          break;
        endif
   
        RL.params = RL.params - alpha * (X_t'*(preds-Y))/n;
    endfor
endfunction



entrada = [ 0.7,2.1 ; 3.4,4.3 ;1,1 ; 2.1,1.7 ;5,5 ; 6,3.2 ; 3.2,0.6; 8.2,1.9 ];
salida = [ 1;0;1;1;0;0;1;0];
nueva_instancia = [6.4,1.4;1,1];


[hist,RL] = entrenarRL_descensoGradiente(entrada, salida,200,0.001,0.3);
[~,valor,clase] = predecirRL(RL,nueva_instancia);
valor
clase

