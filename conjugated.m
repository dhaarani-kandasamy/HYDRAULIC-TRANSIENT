% Calculation of the conjugated flow depth
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
function yk=conjugated(cs,csP,y,Q,g,rho,yc)

if strcmp(cs,'circle')
    d=csP(1);
elseif strcmp(cs,'trapezoid')
    b=csP(1);
    m=csP(2);
elseif strcmp(cs,'parable')
	a=csP(1);
end

A=flowArea(cs,csP,y);
bws=bWS(cs,csP,y);
sp=balancePoint(cs,csP,y);

Fr=Q/A/sqrt(g*A/bws);
StN=rho*Q^2/A+sp*rho*g*A; % supporting force at normal water conditions
% initial value
if Fr>1
	yGuess=yc*1.5;
elseif Fr<1
	yGuess=yc/1.5;
end
% initial value
if strcmp(cs,'circle')
	[yk,fval,info]=fsolve(@(yk) stK(yk,cs,d,Q,g,rho,StN),yGuess); 
	% attention! keep order!
elseif strcmp(cs,'trapezoid')
	if m==0
		yk=y/2*(sqrt(1+8*Fr^2)-1);
	else
		[yk,fval,info]=fsolve(@(yk) stK(yk,cs,csP,Q,g,rho,StN),yGuess); 
		% attention! keep order
	end
elseif strcmp(cs,'parable')
	[yk,fval,info]=fsolve(@(yk) stK(yk,cs,a,Q,g,rho,StN),yGuess); 
	% attention! keep order
end

return