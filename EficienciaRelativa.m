function RE = EficienciaRelativa (E0,z,filmType)

if filmType ==1 
%Parametros EBT3: 
r = 2.08;
p = 1.75;
s = 0.265; 
q = -0.73; 
%Parametros EBT3: 
a = 4.1*10^5; 
b = 2.88;
c = 22.5; 
d = 0.142; 
%Parametros EBT3: 
A = 0.0124;
B = 1; 
%elseif
% Parametros para EBT-XD:

end

Es = ((E0-s*E0^q)^p-(z/r))^(1/p);
LETal = a*exp(-b*Es) + c*exp(-d*Es); 
RE = 1 - A*LETal^B; 

 
end
