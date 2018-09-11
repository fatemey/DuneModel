function ReadXBeachOutput0
% ReadXBeachOutput reads XBeach model outputs and updates the relevant
% files passing data needed for next steps.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------

zb = ncread('xboutput.nc', 'zb');
zb = zb(:); %convert to column vector
if numel(zb)> grids.nx
    zb = zb(end-grids.nx+1:end);
end
run.z = zb(:);

Hmean = ncread('xboutput.nc', 'H_mean');
Hmean = Hmean(:); %convert to column vector
if numel(Hmean)> grids.nx
    Hmean = Hmean(end-grids.nx+1:end);
end
run.Hmean = Hmean(:);




zsmax = ncread('xboutput.nc', 'zs_max');
zsmax = zsmax(:); %convert to column vector
if numel(zsmax)> grids.nx
    zsmax2 = zsmax(end-grids.nx+1:end);
else
    zsmax2 = zsmax;
end

zsmax2(zsmax2>999) = NaN; %sometimes has high output for last time step, so get rid of that
ibad = find([zsmax2(:)-run.z(:)]< waves.XB.eps);
zsmax2(ibad) = NaN;
project.twl(run_number) = nanmax(zsmax2);
if isnan(project.twl(run_number)) == 1
    project.twl(run_number) = tides.waterlevel(run_number);
end
run.zsmax = zsmax2(:);

%                                    % or Use Runup Gauge Instead
%                                    zstemp = ncread('xboutput.nc', 'point_zs');
%                     zstemp(zstemp>999) = NaN;
%                     project.twl(run_number) = nanmax(zstemp);
%
%                     if project.twl(run_number) == max(run.z) %dont use if matches dune crest elevation exactly for some reason, sometimes there are output issues
%                         project.twl(run_number) = tides.waterlevel(run_number);
%                     end

run.startz = dlmread('z.dep'); %probably orig z is loaded in somewhere in history, so this is a bit I/O intensive. But should be limited for 1D sims
run.z(1:10) = run.startz(1:10);  %Correct offshore since there can be sediment accumulation at offshore extent of the model grid which can mess up long term simulations (though this does pose some mass balance issues...

end
