% Solution of the Boess equation
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
function f=directStepSolve(y,cs,csP,yK,Q,g,T,ks,n,JB,dx,toggle)

if strcmp(toggle,'SUPER')
	if n==0	
		f=-y+yK+(Q/flowArea(cs,csP,yK))^2/(2*g)-(Q/flowArea(cs,csP,y))^2/(2*g)+...
		(JB-(.5*(Q/flowArea(cs,csP,y)+Q/flowArea(cs,csP,yK)))^2/(8*g)*...
		pc(cs,csP,(y+yK)/2,Q,ks,T)/((flowArea(cs,csP,y)+flowArea(cs,csP,yK))/...
		(perimeter(cs,csP,y)+perimeter(cs,csP,yK))))*dx;
		
	elseif ks==0
	f=-y+yK+(Q/flowArea(cs,csP,yK))^2/(2*g)-(Q/flowArea(cs,csP,y))^2/(2*g)+...
		(JB-(.5*(Q/flowArea(cs,csP,y)+Q/flowArea(cs,csP,yK)))^2/...
		((1/n)^2*((flowArea(cs,csP,y)+flowArea(cs,csP,yK))/...
		(perimeter(cs,csP,y)+perimeter(cs,csP,yK)))^(4/3)))*dx;
	end
elseif strcmp(toggle,'SUB')
	if n==0
	f=-y+yK+(Q/flowArea(cs,csP,yK))^2/(2*g)-(Q/flowArea(cs,csP,y))^2/(2*g)+...
		((.5*(Q/flowArea(cs,csP,y)+Q/flowArea(cs,csP,yK)))^2/(8*g)*...
		pc(cs,csP,(y+yK)/2,Q,ks,T)/((flowArea(cs,csP,y)+flowArea(cs,csP,yK))/...
		(perimeter(cs,csP,y)+perimeter(cs,csP,yK)))-JB)*dx;
	elseif ks==0
	f=-y+yK+(Q/flowArea(cs,csP,yK))^2/(2*g)-(Q/flowArea(cs,csP,y))^2/(2*g)+...
		((.5*(Q/flowArea(cs,csP,y)+Q/flowArea(cs,csP,yK)))^2/...
		((1/n)^2*((flowArea(cs,csP,y)+flowArea(cs,csP,yK))/...
		(perimeter(cs,csP,y)+perimeter(cs,csP,yK)))^(4/3))-JB)*dx;
	end
end
endfunction
