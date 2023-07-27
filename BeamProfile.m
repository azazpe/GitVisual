function [FWHM, Penumbra] = BeamProfile (c)

% Exclui 0 y negativos: 
c = c(c>0); 
% Calcular el percentil 98
percentil98 = prctile(c, 98);
% Encontrar los índices de los elementos por encima del percentil 98
indices_por_encima = find(c > percentil98);
% Asignar el valor 0 a los elementos por encima del percentil 98
c(indices_por_encima) = 0;
% Encontrar el máximo de los valores restantes
maximo_excluido = max(c);


% Calcular FWHM: 
% Número objetivo
numero_objetivo = maximo_excluido/2;
% Calcular las diferencias y su valor absoluto
diferencias = abs(c - numero_objetivo);
% Ordenar las diferencias en orden ascendente
diferencias_ordenadas = sort(diferencias);
% Encontrar los dos valores mínimos (más cercanos) en las diferencias originales
posicion_min_1 = find(diferencias == diferencias_ordenadas(1), 1);
posicion_min_2 = find(diferencias == diferencias_ordenadas(2), 1);
% Calculo FWHM: 
FWHM = abs(posicion_min_2-posicion_min_1)*0.01693; 

% Calcular la penumbra: 
% Obtener el índice que marca la mitad del vector
indice_mitad = ceil(length(c) / 2);
% Extraer la segunda mitad del vector
segunda_mitad = c(indice_mitad:end);
% Calcular el 80% y el 20% del valor máximo
ochenta_por_ciento = 0.8 * maximo_excluido;
veinte_por_ciento = 0.2 * maximo_excluido;
% Encontrar las posiciones de los valores que más se acercan al 80% y al 20% del máximo
[~, indice_ochenta] = min(abs(segunda_mitad - ochenta_por_ciento));
[~, indice_veinte] = min(abs(segunda_mitad - veinte_por_ciento));
% Calculo Penumbra: 
Penumbra = abs(indice_veinte-indice_ochenta)*0.01693;

end