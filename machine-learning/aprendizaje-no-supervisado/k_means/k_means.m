clc
clear

function dist = distancia_euclidea(X, Y)
  dist = sqrt(sum((X-Y).^2));
endfunction

function [centroides, asignados, iter] = entrenar_k_means(X, k, max_iters=200)
   num_instancias = size(X)(1);
   num_caracteristicas = size(X)(2);

   # Inicializar centroides con valores al azar
   min_c = min(X);
   max_c = max(X);
   centroides = min_c + rand(k, num_caracteristicas) .* (max_c-min_c);

   for iter = 1:max_iters
     # Calcular la distancia a cada custer y asignar el más cercano
     asignados = zeros(num_instancias,1);

     for idx_inst = 1:num_instancias
       min_dist = realmax;
       idx_min_centroide = 0;

       for idx_centroide = 1:k
         dist = distancia_euclidea(X(idx_inst,:),centroides(idx_centroide,:));
         if dist < min_dist
           min_dist = dist;
           idx_min_centroide = idx_centroide;
         endif
       endfor
       asignados(idx_inst) = idx_min_centroide;
     endfor

     # Actualizar el valor de los centroides
     nuevos_centroides = zeros(k, num_caracteristicas)
     for idx_centroide = 1:k
       if sum(asignados==idx_centroide) > 0
         nuevos_centroides(idx_centroide,:) = mean(X(asignados==idx_centroide,:));
       else
         nuevos_centroides(idx_centroide,:) = centroides(idx_centroide,:);
       endif
     endfor

     # Si no se movio ningun centroide terminamos el proceso
     if sum(abs(centroides-nuevos_centroides)) < eps
       break;
     else
       centroides = nuevos_centroides
     endif

     centroides
   endfor
endfunction

dataset = dlmread('iris/iris.data',',',0,0);
# Vamos a remover la ultima columna ya que la idea es no tener las etiquetas
X = dataset(:,1:end-1);
[centroides, asignados, iter] = entrenar_k_means(X, 3, max_iters=2000)
