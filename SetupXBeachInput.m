function SetupXBeachInput0
% SetupXBeachInput sets up input parameters for XBeach model.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------
dlmwrite('z.dep', run.z(:), 'delimiter', ' ', 'precision', '%6.20f');

fid = fopen('spectra.spec', 'w');
fprintf(fid,'%s\n',['Hm0= ', num2str(waves.Hs(run_number))]);
if waves.Tp(run_number)>0 %need to check to make sure dont have infinite frequency
    fprintf(fid,'%s\n',['fp= ', num2str(1/waves.Tp(run_number))]);
else
    fprintf(fid,'%s\n',['fp= 0']);
end
fprintf(fid,'%s\n',['mainang= ', num2str(wave_angle)]);
fclose(fid);


fid = fopen('waterlevel.inp', 'w');
fprintf(fid, '%s\n', ['0 ', num2str(tides.waterlevel(run_number))]);
fprintf(fid, '%s\n', [num2str(project.timeStep+project.XB.hydro_spinup), ' ', num2str(tides.waterlevel(run_number))]);
fclose(fid);

fid = fopen('winds.inp', 'w');
fprintf(fid, '%s\n', ['0 ', num2str(winds.windspeed(run_number)), ' ', num2str(new_wind_angle)]);
fprintf(fid, '%s\n', [num2str(project.timeStep+project.XB.hydro_spinup), ' ', num2str(winds.windspeed(run_number)), ' ', num2str(new_wind_angle)]);
fclose(fid);

%check and update if morfac or stationary/instationary (etc?) changes

end


