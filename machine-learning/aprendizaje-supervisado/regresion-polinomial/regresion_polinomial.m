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
    RL.params = rand(size(X_t,2),1)*.1;
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

function X_f = crearCaracteristicasPolinomio(X,k)
  X_f = X;
  for i=2:k
      X_f = [X_f X.^k];
  endfor
endfunction


%3.192;2.63
entrada = [-0.9;-0.6;-0.7;-0.4;-0.4;0;0.19;0.6676;0.632;1;0.8;1.29;1.07;1.49;1.16;1.521;1.2];
salida = [ 6.29;5.98;5.38;4.82;4.22;4;4.79;4.93;5.41;4.499;4.05;3.434;1.9;1.7;1.01;0.3;0.156];
nueva_instancia = [0.89;1.15];
k = 2;

entrada = crearCaracteristicasPolinomio(entrada,k);
nueva_instancia = crearCaracteristicasPolinomio(nueva_instancia,k);

RL = entrenarRL_formaCerrada(entrada, salida);
[~,valor] = predecirRL(RL,nueva_instancia);
valor

[hist,RL] = entrenarRL_descensoGradiente(entrada, salida,500,0.01,0.01);
[~,valor] = predecirRL(RL,nueva_instancia);
valor