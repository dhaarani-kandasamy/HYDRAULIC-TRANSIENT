% Computation of the Darcy-Weisbach equation for flows under pressure
% the outflow loss has to be added to sumK
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
% [Q, fval, info] = fsolve(@(Q)pipe(Q,'circle',d,d,L,ks,sumK,g,T,dH,PT,PP,eta), guess);
function f=pipe(Q,cs,csP,y,l,ks,sumK,g,T,dH,PT,PP,eta)

f=-dH+Q^2/(flowArea(cs,csP,y)^2*2*g)*(sumK+pc(cs,csP,y,Q,ks,T)*l/...
	(4*flowArea(cs,csP,y)/perimeter(cs,csP,y)))+PT/(eta*1000*g*Q)-PP*eta/(1000*g*Q);

endfunction