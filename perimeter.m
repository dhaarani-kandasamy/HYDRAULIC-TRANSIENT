% Calcualtion of a wetted perimeter
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
function P=perimeter(cs,csP,y)

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
	alpha=2*acos(1-y/r); % full opening angle
	P=r*alpha; % wetted perimeter
elseif strcmp(cs,'trapezoid')   
    P=b+2*y*sqrt(1+m^2); % wetted perimeter
elseif strcmp(cs,'parable')
	p=1/(2*abs(a)); % half parameter
	P=p/2*(sqrt(2*y/p*(1+2*y/p))+log(sqrt(2*y/p)+sqrt(1+2*y/p)))*2; % siehe Bronstein S. 211; Bogen doppelt! also * 2
end

return