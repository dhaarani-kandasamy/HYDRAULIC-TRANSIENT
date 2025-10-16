% Calculation of the conjugated flow depth by means of the balance of forces
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
function f=stK(y,cs,csP,Q,g,rho,StN)

if strcmp(cs,'circle')
    d=csP(1);
elseif strcmp(cs,'trapezoid')
    b=csP(1);
    m=csP(2);
elseif strcmp(cs,'parable')
	a=csP(1);
end

if strcmp(cs,'circle')
	f=StN-(rho*Q^2/(flowArea(cs,csP,y))+balancePoint(cs,csP,y)*rho*g*flowArea(cs,csP,y));
elseif strcmp(cs,'trapezoid')
	f=StN-(rho*Q^2/(flowArea(cs,csP,y))+balancePoint(cs,csP,y)*rho*g*flowArea(cs,csP,y));
elseif strcmp(cs,'parable')
	f=StN-(rho*Q^2/(flowArea(cs,csP,y))+balancePoint(cs,csP,y)*rho*g*flowArea(cs,csP,y));
end

endfunction