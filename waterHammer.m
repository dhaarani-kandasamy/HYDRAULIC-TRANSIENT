% Program for the computation of water hammers by means of the method of characteristics 
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

% physikalische quantities
g=9.80566; % [m/s²]
Ef=2.1E9; % [N/m²]
rho=1000; %[kg/m³]
T=20; % [°C]
hAtm=10; % [mWs] atmospheric pressure head
n=1.2; % [] modified kappa value, ratio of specific heat capacity at const. pressure vs. const. temperature 
nue=csvread('kinViscosity.csv');
pD=csvread('vaporPressure.csv');
nue=interp1(nue(:,1),nue(:,2),T);
pD=interp1(pD(:,1),pD(:,2),T);
% physikalische quantities

% pipe
L=6000; % [m]
Er=2.1E11; % [N/m²] E-Modulus of the pipe
hu=312; % [m]
hd=298; % [m]
d=.3; % [m]
A=(d/2)^2*pi; % [m²]
ks=1E-3; % [m] equivalent sand roughness
sumK=0; % [] sum of local losses WITHOUT outflow and valve loss
w=0.008; % [m] wall thickness
mueq=0.33; % [] lateral contraction coefficient
% pipe

% course of pipe
%x-Position in [m], facility #:
%first row: x, second row y, third row z, fourth row facility 
%0 standard value, straight pipe
%1 open end,
%2 valve: vValve
%3 variable velocity: voft
%4 variable WS in reservoir: hoft
%5 valve in pipe
%6 surge chamber
%7 surge tank
xyz=[0,L/2,L;0,0,0;hu-5,(hu+hd)/2-5,hd-5;1,0,2];
course=input("piezometric head (piezo), water hammer only (only), pressure head (HGL): ", 's');
% course

% valve
A0=A; %.0356; % [m²] initial opening
fname=sprintf('A0=A=%1.3f m2',A0);
disp(fname);
A0New=input('change A0? if yes type in flow area in m2: ');
if isempty(A0New)==0
	A0=A0New;
end
At=A0; % for steady-state conditions only
mue=0.98; % [] discharge coefficient at valve 
ts=30; % [s] closing time
closingLaw=input('closing law linear/hyperbola: ','s'); %  closing law
gap=0; % gap: flow area that is still open after ts 
% valve

% system of characteristics
nodes=3; % j index (columns)
timesteps=40; % i index (rows)
positionAcc=10; % accuracy that decides if facility is on node
jPlot=nodes; % node whose pressure shall be plotted
% system of characteristics

% calculation of Deltax and Delta t
deltax=L/(nodes-1);
a=sqrt(1/rho/(1/Ef+d*(1-mueq^2)/(Er*w)));
fname=sprintf('a=%3d m/s',a);
disp(fname);
aNew=input('change a? if yes type in velocity in m/s: ');
if isempty(aNew)==0
	a=aNew;
end
deltat=deltax/a;
x=(0:deltax:L); % Position nodes
topo=interp1(xyz(1,:),xyz(3,:),x);
% Deltax and Delta t

% steady state / Bernoulli with Darcy-Weisbach; Prandtl-Colebrook
[Q,fval,info]=fsolve(@(Q)energy(Q,'circle',d,d,L,ks,sumK,A0,A0,mue,g,T,hu-hd),sqrt(2*g*(hu-hd))*A);
v0=Q/A;
fD=pc('circle',d,d,Q,ks,T);
% steady state / Bernoulli with Darcy-Weisbach; Prandtl-Colebrook

% where does anything happen?
o=zeros(1,nodes); 
for k=1:size(xyz,2)
    for l=1:length(x)
        if abs(xyz(1,k)-x(l))<positionAcc;
            o(l)=xyz(4,k);
        end
    end
end
pos=find(o,2); % where is the valve?
% where does anything happen?

% Joukowsky-Stoß
maxh=a/g*v0;
if 2*L/a>ts
    fname=sprintf('the Joukowsky peak takes place: maxh=%1.2f m\n',maxh);
    disp(fname)
else
    fname=sprintf('the Joukowsky peak (maxh=%1.2f m) does not take place.\n',maxh);
    disp(fname)
end
% Joukowsky-Stoß

% Initialisation
kp=zeros(timesteps,nodes); 
km=zeros(timesteps,nodes); 
% kp für +Charakteristik,km für -Charakteristik
h=zeros(timesteps,nodes);
v=zeros(timesteps,nodes);
Je=zeros(timesteps,nodes);
vrK=[ones(1,nodes);zeros(1,nodes)]; % if cavitation takes place
vlK=[ones(1,nodes);zeros(1,nodes)]; % if cavitation takes place

lK=zeros(1,nodes); % if cavitation takes place
% Initialisation

% steady solution
h(1,:)=hu-v0^2/(2*g)*(fD*x./d); % h(x), steady case with sumK=0 and EL=HGL
v(1,:)=v0; % v(x), steady case
% steady solution

% characteristic at first timestep
Je(1,:)=sign(v(1,:))*fD/d.*v(1,:).^2/(2*g);
km(1,:)=-h(1,:)+a/g*v(1,:)-a*deltat*Je(1,:);
kp(1,:)=-h(1,:)-a/g*v(1,:)+a*deltat*Je(1,:);
% characteristic at first timestep

% unsteady computation by means of method of characteristics
for i=2:timesteps
    for j=1:nodes
        if j==1 % upper node at ununeven timesteps
            if rem(i,2)==1 % i=timestep==uneven
                if o(1,j)==1
                    v(i,j)=g/a*(hu+km(i-1,j+1));
                    h(i,j)=hu;
                elseif o(1,j)==2
					At=closing(A0,ts,(i-1)*deltat,gap,closingLaw);
                    v(i,j)=vValve(hu,km(i-1,j+1),mue,At,A,a,g,'start');
					h(i,j)=a/g*v(i,j)-km(i-1,j+1);
                elseif o(1,j)==3
                    v(i,j)=voft();
                    h(i,j)=a/g*voft()-km(i-1,j+1);
                elseif o(1,j)==4
                    h(i,j)=hoft();
					v(i,j)=a/g*(h(i,j)+km(i-1,j+1));
                end
			elseif rem(i,2)==0 % zeitschritt gerade
				v(i,j)=NaN; % at this time and place no solution possible
				h(i,j)=NaN; % at this time and place no solution possible
            end
        elseif j==nodes % end of penstock
            if rem(i,2)==1 % i=timestep==uneven
                if o(1,j)==1
                    v(i,j)=-g/a*(hd+kp(i-1,j-1));
                    h(i,j)=hd;
                elseif o(1,j)==2
                    At=closing(A0,ts,(i-1)*deltat,gap,closingLaw);
					v(i,j)=vValve(hd,kp(i-1,j-1),mue,At,A,a,g,'end');
                    h(i,j)=-a/g*v(i,j)-kp(i-1,j-1);
                elseif o(1,j)==3
                    v(i,j)=voft();
					h(i,j)=-a/g*voft-kp(i-1,j-1);
                elseif o(1,j)==4
                    h(i,j)=hoft();
					v(i,j)=-g/a*(h(i,j)+kp(i-1,j-1));
                end
			elseif rem(i,2)==0 % timestep even
				v(i,j)=NaN; % at this time and place no solution possible
				h(i,j)=NaN; % at this time and place no solution possible
            end
			% all even nodes and all even timesteps OR
			% all uneven nodes and all uneven timesteps
        elseif rem(j,2)==0 && rem(i,2)==0 || rem(j,2)==1 && rem(i,2)==1 
			if o(1,j)==0
				v(i,j)=g/a*(km(i-1,j+1)-kp(i-1,j-1))/2;
				h(i,j)=-(km(i-1,j+1)+kp(i-1,j-1))/2;
			end
		elseif rem(j,2)==0 && rem(i,2)==1 || rem(j,2)==1 && rem(i,2)==0
				v(i,j)=NaN; % at this time and place no solution possible
				h(i,j)=NaN; % at this time and place no solution possible
        end
        Je(i,j)=sign(v(i,j))*pc('circle',d,d,abs(v(i,j))*d^2*pi/4,ks,T)...
			/d*v(i,j)^2/(2*g);
        km(i,j)=-h(i,j)+a/g*v(i,j)-a*deltat*Je(i,j);
        kp(i,j)=-h(i,j)-a/g*v(i,j)+a*deltat*Je(i,j);
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% check if cavitation
		p=rho*g*(h(i,j)-topo(1,j)+hAtm);
		if p<pD
			fname=sprintf('attention cavitation! t=%1.2f, j=%1.2f, pressure head h=%1.2f m', deltat*(i-1), j, h(i,j)-topo(1,j)+hAtm);
			disp(fname)
			h(i,j)=topo(1,j)-hAtm+pD/(rho*g);
			if j==1
				vr=g/a*(h(i,j)+km(i-1,j+1));
				vl=0;
			elseif j==nodes
				vl=-g/a*(h(i,j)+kp(i-1,j-1));
				vr=0;
			else
				vr=g/a*(h(i,j)+km(i-1,j+1));
				vl=-g/a*(h(i,j)+kp(i-1,j-1));
			end
			km(i,j)=-h(i,j)+a/g*vr-a*deltat*Je(i,j);
			kp(i,j)=-h(i,j)-a/g*vl+a*deltat*Je(i,j);
			% Je stays untouched because initial v(i,j)=1/2(vl+vr).
			if vrK(1,j)~=i-2
				lK(1,j)=0; % if no vapor pressure at timestep i-1 at place (j-2).
			end
			lK(1,j)=lK(1,j)+.5*(vr-vl+vrK(2,j)-vlK(2,j))*deltat;
			vrK(1,j)=i; vrK(2,j)=vr;
			vlK(1,j)=i;	vlK(2,j)=vl;
			fname=sprintf('Laenge Kavitationsblase lK=%1.2f m, vr=%1.2f m/s, vl=%1.2f m/s\n', lK(1,j), vr, vl);
			disp(fname)
		end
		% check if cavitation
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
% unsteady computation by means of method of characteristics
% pressure head in penstock
fname=sprintf('the maximum pressure head is: %1.2f m\nthe minimum pressure head is: %1.2f m',max(max(h-topo)),min(min(h-topo)));
disp(fname)
% pressure head in penstock
% course of penstock
if strcmp(course,'only')==1
    for i=1:timesteps
        for j=1:nodes
            if h(i,j)~=0
                h(i,j)=h(i,j)-topo(1,j);
            end
        end
    end
elseif strcmp(course,'HGL')==1
    for i=timesteps:-1:1
        for j=1:nodes
            if h(i,j)~=0
                h(i,j)=h(i,j)-h(1,j);
            end
        end
    end
end
% course of penstock
% Plot
timestamp=(0:deltat:deltat*(timesteps-1))';
plot(timestamp(!isnan(h(:,jPlot))),h(!isnan(h(:,jPlot)),jPlot),'-k','linewidth',8)
hold on
plot(timestamp(!isnan(h(:,jPlot-1))),h(!isnan(h(:,jPlot-1)),jPlot-1),'-.k','linewidth',8)
plot(timestamp(!isnan(h(:,jPlot-2))),h(!isnan(h(:,jPlot-2)),jPlot-2),':k','linewidth',8)
legende=legend('end of penstock', 'center of penstock', 'start of penstock');
if strcmp(course,'piezo')==1
    title('piezometric pressure head over time','fontsize',18)
elseif strcmp(course,'only')==1
    title('pressure head over time','fontsize',18)
elseif strcmp(course,'HGL')==1
    title('dynamic vs. static pressure head','fontsize',18)
end
set(legende, 'fontsize', 18)
xlabel('t [s]', 'fontsize', 18)
ylabel('h_p [m]', 'fontsize', 18)
set(gca, 'fontsize', 18)
print('waterHammerExample.png','-dpng')
print('waterHammerExample.pdf','-dpdf')
% Plot
