%% Program for the solution of the Boess equation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Copyright (C) <2016>  <Christoph Rapp, Muenchen, Germany>

% % % This program is free software: you can redistribute it and/or modify
% % % it under the terms of the GNU General Public License as published by
% % % the Free Software Foundation, either version 3 of the License, or
% % % (at your option) any later version.

% % % This program is distributed in the hope that it will be useful,
% % % but WITHOUT ANY WARRANTY; without even the implied warranty of
% % % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% % % GNU General Public License for more details.

% % % You should have received a copy of the GNU General Public License
% % % along with this program.  If not, see <http://www.gnu.org/licenses/>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file='dataGerinne.csv';
delimiter='=';
header=2;
% input
datenEinlesen(file,delimiter,header);
% input

% input 
fname=sprintf('Type in the known flow depth yr (sub) [m]: ');
yr=input(fname);
fname=sprintf('Type in the known flow depth yl (super) [m]: ');
yl=input(fname);
% input 

% cross sections
if cs==1
	cs='circle';
	csP=d;
elseif cs==2
	cs='trapezoid';
	csP=[b,m];
elseif cs==3
	cs='parable';
	csP=a;
end
% cross sections
Al=flowArea(cs,csP,yl);
Ar=flowArea(cs,csP,yr);
Pl=perimeter(cs,csP,yl);
Pr=perimeter(cs,csP,yr);
vl=Q/Al;
vr=Q/Ar;
vm=(vl+vr)/2;
Rm=(Ar+Al)/(Pr+Pl);
JEm=vm^2/kSt^2/Rm^(4/3);
kl=vl^2/(2*g);
kr=vr^2/(2*g);
deltax=(yr+kr-yl-kl)/(JB-JEm);
fname=sprintf('deltax = %1.3f', deltax);
disp(fname);
