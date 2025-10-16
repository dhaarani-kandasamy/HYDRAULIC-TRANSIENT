% Program to read data and assign values to variables / constants
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
function readData(file,delimiter)

fid=fopen(file);
% find first line of data
ln=fgetl(fid);
i=1;
while ischar(ln)
	if isempty(ln)==0
		if strcmp(ln(1),'#')==1
			Zeile=i+1;
			break
		end
		i=i+1;
	end
ln=fgetl(fid);
end
% find first line of data
% assigning of values to variables / constants
i=1;
while ischar(ln)
	if isempty(ln)==0
		for j=1:length(ln)
			if strcmp(ln(j),delimiter)==1
			var{i}=num2str(ln(1:j-1));
				assignin('base',var{i},str2num(ln(j+1:end)));
			end
		end
		i=i+1;
	end
ln=fgetl(fid);
end
fclose(fid);
% assigning of values to variables / constants
return