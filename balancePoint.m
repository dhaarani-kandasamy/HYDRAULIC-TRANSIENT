% Berechnung des Schwerpunkts einer Flaeche 
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
function sp=balancePoint(cs,csP,y)

if strcmp(cs,'circle')
    d=csP(1);
elseif strcmp(cs,'trapezoid')
    b=csP(1);
    m=csP(2);
elseif strcmp(cs,'parable')
	a=csP(1);
end

if strcmp(cs,'circle')
	r=d/2;
	alpha=acos((r-y)/r); % half opening angle
	A=flowArea(cs,csP,y);
	sp=y-(r-bWS(cs,csP,y)^3/(12*A));
elseif strcmp(cs,'trapezoid')   
	bws=bWS(cs,csP,y);
    sp=y/3*(bws+2*b)/(bws+b);
elseif strcmp(cs,'parable')
	sp=2/5*y;
end

return