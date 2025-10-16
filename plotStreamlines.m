% Plots 2D Streamlines of the vecor field (x,y,u,v,seed) @ starting points indicated in seed[x,y]
% Finite Differences First Order
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
function stream=plotStreamlines(x,y,u,v,dx,dy,seed)

[dudx,dudy]=gradient(u,dx,dy);
[dvdx,dvdy]=gradient(v,dx,dy);

for i=1:size(seed,1)
	stream{i}(1,1)=seed(i,1);
	stream{i}(1,2)=seed(i,2);
	j=1;
	schritte=1;
	X(1)=stream{i}(1,1);
	Y(1)=stream{i}(1,2);
	while X(1)>=min(min(x)) && X(1)<=max(max(x)) && Y(1)>=min(min(y)) && Y(1)<=max(max(Y))
		dt=1; % timestep in Euler context
		U(1)=interp2(x,y,u,X(1),Y(1)); % interpolate velocity field u on exact (X,Y) position
		V(1)=interp2(x,y,v,X(1),Y(1)); % interpolate velocity field v on exact (X,Y) position
		dUdx(1)=interp2(x,y,dudx,X(1),Y(1)); % interpolate velocitygradient dudx on exact (X,Y) position
		dUdy(1)=interp2(x,y,dudy,X(1),Y(1));
		dVdx(1)=interp2(x,y,dvdx,X(1),Y(1));
		dVdy(1)=interp2(x,y,dvdy,X(1),Y(1));
		U(1)=U(1)+(U(1)*dUdx(1)+V(1)*dUdy(1))*dt; % Lagrange velocity
		V(1)=V(1)+(U(1)*dVdx(1)+V(1)*dVdy(1))*dt; % Lagrange velocity
		dtx=1e-1*dx/U(1); % time that passes until the movement in the x direction is 0.1*dx to save computational time
		dty=1e-1*dy/V(1); % time that passes until the movement in the x direction is 0.1*dy to save computational time
		dt=min(abs(dtx),abs(dty)); % movement in x or y direction maximal dx / dy.
		% calculation of the conditions at point 2
		X(2)=X(1)+U(1)*dt; % x position is originally x+U*dt; Lagrangian path
		Y(2)=Y(1)+V(1)*dt; % y position is originally y+V*dt; Lagrangian path
		dt=1; % timestep ha to be set to 1 for the velocity gradient.
		U(2)=interp2(x,y,u,X(2),Y(2));
		V(2)=interp2(x,y,v,X(2),Y(2));
		dUdx(2)=interp2(x,y,dudx,X(2),Y(2));
		dUdy(2)=interp2(x,y,dudy,X(2),Y(2));
		dVdx(2)=interp2(x,y,dvdx,X(2),Y(2));
		dVdy(2)=interp2(x,y,dvdy,X(2),Y(2));
		U(2)=U(2)+(U(2)*dUdx(2)+V(2)*dUdy(2))*dt;
		V(2)=V(2)+(U(2)*dVdx(2)+V(2)*dVdy(2))*dt;
		U(1)=(U(1)+U(2))/2; % the velocity is calculated at x_0 and x_0+u_0*dt and averaged
		V(1)=(V(1)+V(2))/2; % the velocity is calculated at y_0 and y_0+v_0*dt and averaged
		% calculation of the conditions at point 2
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% TEST
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if isinf(sqrt(U(1)^2+V(1)^2))==1 || isnan(sqrt(U(1)^2+V(1)^2))==1
			break
		else
			dtx=1e-1*dx/U(1);
			dty=1e-1*dy/V(1);
			dt=min(abs(dtx),abs(dty));
			X(1)=X(1)+U(1)*dt;
			Y(1)=Y(1)+V(1)*dt;
			j=j+1;
			steps=steps+1;
			stream{i}(j,1)=X(1);
			stream{i}(j,2)=Y(1);
		end
	end
	fname=sprintf('Number of steps: %d',steps);
	disp(fname)
end