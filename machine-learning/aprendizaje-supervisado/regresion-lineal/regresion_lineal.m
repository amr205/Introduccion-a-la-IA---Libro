clc
clear 

function [historial, valor] = predecirRL(RL,entrada)
    historial.entrada = [ones(size(entrada,1),1),entrada];
    valor = historial.entrada*RL.params;
endfunction

function RL = entrenarRL_formaCerrada(X, Y)
    X = [ones(size(X,1),1),X];
    RL.params = inv(X'*X)*X'*Y;
endfunction

function [historial,RL] = entrenarRL_descensoGradiente(X, Y, max_iter, min_error,alpha)
    X_t = [ones(size(X,1),1),X];
    RL.params = rand(size(X_t,2),1);
    n = size(X,1);
    
    for k=1:max_iter
        [~, preds] = predecirRL(RL,X);
        historial.error_f = sum((preds-Y).^2)/2;
        
        if historial.error_f <= min_error
          break;
        endif
        
        RL.params = RL.params - alpha * (X_t'*(preds-Y))/n;
    endfor
endfunction


entrada = [0.54;1.14;2.08;3.5;8.64;9.38;10];
salida = [ 2.06;2.68;2.66;3.6;5.26;6.04;6];
nueva_instancia = [5.92;7];


RL = entrenarRL_formaCerrada(entrada, salida);
[~,valor] = predecirRL(RL,nueva_instancia);
valor

[hist,RL] = entrenarRL_descensoGradiente(entrada, salida,100,0.01,0.01);
[~,valor] = predecirRL(RL,nueva_instancia);
valor

