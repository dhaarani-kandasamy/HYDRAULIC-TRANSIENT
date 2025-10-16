% Programm zur Loesung der Normalwassergleichungen mit den Reibungsansaetzen von Manning-Strickler und Prandtl-Colebrook
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
function f=NWC(y,cs,csP,Q,g,T,ks,n,JS)
JE=JS;
if ks==0
	f=-Q+1/n * sqrt(JE) * flowArea(cs,csP,y)^(5/3) / perimeter(cs,csP,y)^(2/3);
elseif n==0
	f=-Q+flowArea(cs,csP,y)*sqrt(8*g*flowArea(cs,csP,y)*...
	JE/(perimeter(cs,csP,y)*pc(cs,csP,y,Q,ks,T)));
end
endfunction