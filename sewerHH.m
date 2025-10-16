% Program for the solution of the set of equations of the pipeflow example 'Hamburg sewer'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Copyright (C) <2016>  <Christoph Rapp>

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
% input
file='dataHH.csv';
delimiter='=';
header=2;
dataInput(file,delimiter,header);
% input
% cross sections
if cs==1
	cs='circle';
	csP1=d1;
	csP2=d2;
	csP3=d3;
else 
	error('Valid for circular cross sections only.')
end
% crosssections

Q3=Q1+Q2; % [m3/s]
% INITIAL VALUE ONLY
Q3=1; % [m3/s] INITIAL VALUE ONLY
% INITIAL VALUE ONLY
k=0;
while abs(Q1-(Q3-Q2))>1E-3
	Q3=Q1+Q2; 
	Hp1=-2.6368*Q1^3+10.578*Q1^2-20.908*Q1+28.812; % throttle curve for 2 parallel pumps
	if Q2<0.0872
		Hp2=-24.472*Q2+9; % throttle curve for 2 parallel pumps
	elseif Q<.11
		Hp2=-300.66*Q2+33.072; % throttle curve for 2 parallel pumps
	else
		error('Pumps in pump station 2 are to small.')
	end
	fD1=pc(cs,csP1,csP1,Q1,ks1,T); % fD via subroutine pc
	fD2=pc(cs,csP2,csP2,Q2,ks2,T); % fD via subroutine pc
	fD3=pc(cs,csP3,csP3,Q3,ks3,T); % fD via subroutine pc
	% set of equations
	A =	[(fD1*L1/d1+sumZ1+1)/(d1^4*pi^2*g/8),0,1;
	0,(fD2*L2/d2+sumZ2+1)/(d2^4*pi^2*g/8),1;
	-1*(fD3*L3/d3+sumZ3+1)/(d3^4*pi^2*g/8),-1*(fD3*L3/d3+sumZ3+1)/(d3^4*pi^2*g/8),1]; 
	% set of equations
	% solution matrix
	E = [.5+Hp1;.8+Hp2;3.11]; 
	% solution matrix
	X=A\E; % solving of the set of equations
	Q1=sqrt(X(1)); % solving of the substitution
	Q2=sqrt(X(2)); % solving of the substitution
	DlKn=X(3);
end
fname=sprintf('Q1 = %1.3f m3/s,\nQ2 = %1.3f m3/s,\nQ3 = %1.3f m3/s',Q1,Q2,Q3);
disp(fname) % display of the results