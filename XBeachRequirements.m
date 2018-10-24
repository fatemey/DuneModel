function XBeachRequirements(data)
% XBeachRequirements prepares data requreiments needed for XBeach.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------

%-------------- make grid topographic data files
dlmwrite('x.grd', data.grid.X, 'delimiter', ' ', 'precision', '%10.4f');
dlmwrite('y.grd', zeros(size(data.grid.X)), 'delimiter', ' ', 'precision', '%10.4f');

%-------------- make a parameter file
fid = fopen('params.txt', 'w');

fprintf(fid, 'morfac = %d\n', data.timestep.XB.morfac);
fprintf(fid, 'morfacopt = %d\n', data.timestep.XB.morfacopt);
fprintf(fid, 'tstop = %d\n', data.timestep.XB.tstop);
fprintf(fid, 'depfile = z.dep\n');
fprintf(fid,  'xfile = x.grd\n');
fprintf(fid,  'yfile = y.grd\n');
fprintf(fid, 'nx = %d\n', length(data.grid.X)-1);
fprintf(fid, 'ny = 0\n');
fprintf(fid, 'vardx = %d\n', data.grid.XB.vardx);
fprintf(fid, 'posdwn = %d\n', data.grid.XB.posdwn);
fprintf(fid, 'windfile = wind.txt\n');
fprintf(fid, 'wind = %d\n', data.wind.XB.wind);
fprintf(fid, 'waveform = %s\n', data.wave.XB.waveform);
fprintf(fid, 'wavemodel = %s\n', data.wave.XB.wavemodel);
fprintf(fid, 'dtheta = %d\n', data.wave.XB.dtheta);
fprintf(fid, 'thetamin = %d\n', data.wave.XB.thetamin);
fprintf(fid, 'thetamax = %d\n', data.wave.XB.thetamax);
if strcmp(data.wave.XB.wavemodel, 'nonh') % Turn on non-hydrostatic pressure for nonhydrostatic waves
    fprintf(fid, 'nonh = %d\n', data.wave.XB.nonh);
end
fprintf(fid, 'break = %s\n', data.wave.XB.break);
fprintf(fid, 'roller = %d\n', data.wave.XB.roller);
fprintf(fid, 'wci = %d\n', data.wave.XB.wci);
fprintf(fid, 'cats = %d\n', data.wave.XB.cats);
fprintf(fid, 'taper = %d\n', data.wave.XB.taper);
fprintf(fid, 'turb = %d\n', data.wave.XB.turb);
fprintf(fid, 'zs0file = tide.txt\n');
fprintf(fid, 'zs0 = %d\n', data.tide.XB.zs0);
fprintf(fid, 'bedfriction = %s\n', data.flow.XB.bedfriction);
fprintf(fid, 'gwflow = %d\n', data.flow.XB.gwflow);
fprintf(fid, 'gw0 = %d\n', data.flow.XB.gw0);
fprintf(fid, 'morphology = %d\n', data.sed.XB.morphology);
fprintf(fid, 'form = %s\n',data.sed.XB.form);
fprintf(fid, 'avalanching = %d\n',data.sed.XB.avalanching);
fprintf(fid, 'lws = %d\n', data.sed.XB.lws);
fprintf(fid, 'lwt = %d\n', data.sed.XB.lwt);
fprintf(fid, 'sus = %d\n',data.sed.XB.sus);
fprintf(fid, 'bed = %d\n',data.sed.XB.bed);
fprintf(fid, 'sws = %d\n',data.sed.XB.sws);
fprintf(fid, 'bdslpeffmag = %s\n',data.sed.XB.bdslpeffmag);
fprintf(fid, 'bdslpeffdir = %s\n',data.sed.XB.bdslpeffdir);
fprintf(fid, 'bdslpeffini = %s\n',data.sed.XB.bdslpeffini);
fprintf(fid, 'turbadv = %s\n',data.sed.XB.turbadv);
fprintf(fid, 'fallvelred = %d\n',data.sed.XB.fallvelred);
fprintf(fid, 'dilatancy = %d\n',data.sed.XB.dilatancy);
fprintf(fid, 'bcfile = spectrafilelist.txt\n');
fprintf(fid, 'wbctype = %s\n', data.bc.XB.wbctype);
fprintf(fid, 'right = %s\n', data.bc.XB.right);
fprintf(fid, 'left = %s\n', data.bc.XB.left);
fprintf(fid, 'front = %s\n', data.bc.XB.front);
fprintf(fid, 'back = %s\n', data.bc.XB.back);
fprintf(fid, 'tideloc = %d\n', data.bc.XB.tideloc);
fprintf(fid, 'outputformat = netcdf\n');
fprintf(fid, 'nglobalvar = 3\n');
fprintf(fid, 'H\n'); % wave height?
fprintf(fid, 'zb\n'); % bed level
fprintf(fid, 'zs\n'); % water level

fclose(fid);

%-------------- make a file for a list of spectra files
fid = fopen('spectrafilelist.txt', 'w');

fprintf(fid, 'FILELIST\n');
fprintf(fid, '%d %d spectra.txt\n', data.timestep.ts, data.timestep.XB.dtbc);

fclose(fid);

%-------------- make a spectra file
fid = fopen('spectra.txt', 'w');

for i = 1 : data.timestep.n
    fprintf(fid, '%f %f %f\n', data.wave.Hs(i), data.wave.Tp(i), data.wave.dir(i));
end

fclose(fid);

%-------------- make a tide data file
fid = fopen('tide.txt', 'w');

time = 0 : data.timestep.ts : (data.timestep.n-1)*data.timestep.ts;
for i = 1 : data.timestep.n
    fprintf(fid, '%d %f\n', time(i), data.tide.waterlevel(i));
end

fclose(fid);

%-------------- make a wind data file
fid = fopen('wind.txt', 'w');

for i = 1 : data.timestep.n
    fprintf(fid, '%d %f %f\n', time(i), data.wind.velocity(i), data.wind.dir(i));
end

fclose(fid);

end