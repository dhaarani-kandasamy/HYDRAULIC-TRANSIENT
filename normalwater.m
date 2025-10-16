% Program for the computation of normal water conditions in an open channel
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
% input
datenEinlesen(file,delimiter,header);
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

% normal water depth
y=fsolve(@(y) NWC(y,cs,csP,Q,g,T,ks,kSt,JS), csP(1)/2);
% normal water depth
A=flowArea(cs,csP,y);
% velocity head
v=Q/A;
k=Q^2/A^2/2/g;
% velocity head
% energy head
H=y+k;
% energy head
% Froude number
bws=bWS(cs,csP,y);
Fr=v/sqrt(g*A/bws);
% Froude number

% display
display=sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\nnormal water conditions');
disp(display);
display=sprintf('yN = %1.3f m', y);
disp(display);
display=sprintf('vN = %1.3f m/s', v);
disp(display);
display=sprintf('HN = %1.3f m', H);
disp(display);
display=sprintf('FrN = %1.3f', Fr);
disp(display);
display=sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(display);
% display

% critical conditions
yc=yC(cs,csP,Q,g);
Ac=flowArea(cs,csP,yc);
vc=Q/Ac;
Hmin=yc+Q^2/(Ac^2*2*g);
% critical conditions

% Bildschirmanzeige
display=sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\ncritical conditions');
disp(display);
display=sprintf('yc = %1.3f m', yc);
disp(display);
display=sprintf('vc = %1.3f m', vc);
disp(display);
display=sprintf('Hmin = %1.3f m', Hmin);
disp(display);
display=sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(display);
% display

% conjugated conditions
yk=conjugated(cs,csP,y,Q,g,rho,yc);
Ak=flowArea(cs,csP,yk);
% conjugated conditions
% conjugated energy head
Hk=yk+(Q^2/Ak^2)/(2*g);
% conjugated energy head

% Froude number
bwsk=bWS(cs,csP,yk);
Frk=Q/(Ak)/sqrt(g*Ak/bwsk);
% Froude number

% display
display=sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\nconjugated conditions');
disp(display);
display=sprintf('yk = %1.3f m', yk);
disp(display);
display=sprintf('Hk = %1.3f m', Hk);
disp(display);
display=sprintf('Frk = %1.3f', Frk);
disp(display);
display=sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(display);
% display
fname=sprintf('%03dMIK.csv',Q);
csvwrite(fname,[y,v,H,Fr])

return