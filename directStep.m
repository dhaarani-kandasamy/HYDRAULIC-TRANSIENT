% Program zur Berechnung der Fliesstiefe in einem bestimmten Abstand Delta x mit dem Boess-Verfahren
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
file='dataOpenChannel.csv';
delimiter='=';
header=2;
% Einlesen der Gerinnecharakteristik
dataInput(file,delimiter,header);
% Einlesen der Gerinnecharakteristik

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

% input data 
yUnknown=input('Do you want to compute yl (sub) or yr (super): [yl], [yr]: ','s');
if strcmp(yUnknown,'yl')
	toggle='SUB';
	fname=sprintf('Type in the known flow depth yr (sub) [m]: ');
elseif strcmp(yUnknown,'yr')
	toggle='SUPER';
	fname=sprintf('Type in the known flow depth yl (super) [m]: ');
end
yK=input(fname);
% input data 

step=1;
while step*dx<=L
	yK=fsolve(@(y) directStepSolve(y,cs,csP,yK,Q,g,T,ks,n,JB,dx,toggle), yK);
	step=step+1;
end
if strcmp(toggle,'SUB')
	fname=sprintf('yl = %1.3f m', yK);
elseif strcmp(toggle,'SUPER')
	fname=sprintf('yr = %1.3f m', yK);
end
disp(fname);
