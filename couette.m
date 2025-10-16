% Program fo rth evisualization of a Couette flow
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
mu=1e-3; % [kg/(ms)]
resolution=1000;
B=input('Type in te width of the channel B: '); % [m]
dpdx=input('Type in the pressure gradient dp/dx: '); % [N/m3]
uP=input('Type in the velocity of the upper plate: '); % [m/s]

z=(0:B/resolution:B)';

u=uP/B.*z+1/mu*dpdx.*z/2.*(z-B);

plot(u,z)

print('velocityProfile.png','-dpng') 
