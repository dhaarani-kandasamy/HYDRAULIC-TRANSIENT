% Prandtl-Colebrook-Algorithmus zur Berechnung von fD mit (cs,csP,y,Q,ks,T)
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
function fD=pc(cs,csP,y,Q,ks,T)
nue=csvread('kinViscosity.csv');
nue=interp1(nue(:,1),nue(:,2),T);
eps=1e-6; % accuracy
% cross sections
if strcmp(cs,'circle')
    d=csP(1);
elseif strcmp(cs,'trapezoid')
    b=csP(1);
    m=csP(2);
elseif strcmp(cs,'parable')
	a=csP(1);
end
A=flowArea(cs,csP,y);
P=perimeter(cs,csP,y);
R=A/P;
v=Q/A;
Re=v*4*R/nue;
% cross sections
% laminar / turbulent
% if turbulent, at first computation of fD and subsequently check if rough or smooth range has to be applied
if Re==0
	fD=0;
elseif Re>0 && Re<2300 % for laminar flows
	fD=64/Re;
else % for turbulent flows
	fD=0.02; % initial value of the iteration;
	rs=0.01; % = right side of the equation = initial value for iteration;
	ls=1/sqrt(fD); % = left side of the equation
	while abs(ls-rs)>eps % iteration, as long as rs ~= ls
		ls=1/sqrt(fD); % we start with the transition
		rs = -2*log10(2.51/(Re*sqrt(fD))+ks/(3.71*4*R));
		fD=(1/rs)^2;
	end
	if Re*sqrt(fD)*ks/(4*R)<5*sqrt(8) % check if smooth range
		rs=0.01; % = right side of the equation = initial value for iteration;
		ls=1/sqrt(fD);  % = left side of the equation
		while abs(ls-rs)>eps
			ls=1/sqrt(fD);
			rs = -2*log10(2.51/(Re*sqrt(fD)));
			fD=(1/rs)^2;
		end
		warning('smooth range')
	elseif Re*sqrt(fD)*ks/(4*R)>70*sqrt(8) % check if rough range
		fD = (1/(-2*log10(ks/(3.71*4*R))))^2;
		warning('rough range')
	end
end
return