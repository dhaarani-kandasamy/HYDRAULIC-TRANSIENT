% Program for the computation of surge waves in open channel flows
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
file='dataSurge.csv';
delimiter='=';
header=2;
% input
dataInput(file,delimiter,header);
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

% input 
y=input('Type in the initial flow depth y0 [m]: ');
dQ=input('Type in the change of flow rate dQ [m3/s]: ');
% input 

A=flowArea(cs,csP,y);
v=Q/A;

for i=1:2 % i=1 positive surge, i=2 negative surge
    h=0; % initial value
    hl=1; % initial value
    while abs(hl-h)>eps
        hl=h;
        c=sqrt(g*A/bWS(cs,csP,(y+h/2)))*sqrt(1+3/2*bWS(cs,csP,(y+h/2))*h/A+1/2*(bWS(cs,csP,(y+h/2))*h/A)^2); % propagation velocity
        if i==1
            a=v-c; % positive surge
        elseif i==2
            a=v+c; % a negative surge
        end
        h=dQ/(a*bWS(cs,csP,(y+h/2))); % height positive/negative surge
    end
    if i==1
        fname=sprintf('height positive surge %1.4f m\nsteady-state velocity %1.4f m/s\npropagation velocity %1.4f m/s', h,v,c);
    elseif i==2
        fname=sprintf('height negative surge %1.4f m\nsteady-state velocity %1.4f m/s\npropagation velocity %1.4f m/s', h,v,c);
    end
    disp(fname);
end

