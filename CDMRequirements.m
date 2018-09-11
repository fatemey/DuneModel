function input  = CDMRequirements(data)
% CDMRequirements prepares data requreiments needed for CDM.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------
%set up model grids
grids.CDM.CDM_YGrid = [0:grids.dx:grids.dx*3];
grids.CDM.XD = repmat(grids.XGrid(:)', numel(grids.CDM.CDM_YGrid), 1);
grids.CDM.YD = repmat(zeros(size(grids.XGrid(:)')), numel(grids.CDM.CDM_YGrid), 1); %this is all zeros, but is never used so shouldnt matter
grids.CDM.ZD = repmat(grids.ZGrid(:)', numel(grids.CDM.CDM_YGrid), 1);
iuse = find(grids.CDM.ZD>=veg.CDM.elevMin & grids.CDM.ZD<=veg.CDM.elevMax);
veg.CDM.vegmatrix = zeros(size(grids.CDM.ZD));
veg.CDM.vegmatrix(iuse) = veg.CDM.startingDensity; %starting vegetation density - ultimately this probably shouldnt be hard coded
dlmwrite([project.Directory, filesep, 'cdm', filesep, 'init_vx.dat'], veg.CDM.vegmatrix', 'delimiter', ' ');
dlmwrite([project.Directory, filesep, 'cdm', filesep, 'init_vy.dat'], zeros(size(veg.CDM.vegmatrix')), 'delimiter', ' ');
run.veget = veg.CDM.vegmatrix(round(grids.ny/2), :);
%%% check the above and below difference
%set up model grids
grids.CDM.CDM_YGrid = [0:grids.dx:grids.dx*3];
grids.CDM.XD = repmat(grids.XGrid(:)', numel(grids.CDM.CDM_YGrid), 1);
grids.CDM.YD = repmat(zeros(size(grids.XGrid(:)')), numel(grids.CDM.CDM_YGrid), 1); %this is all zeros, but is never used so shouldnt matter
grids.CDM.ZD = repmat(grids.ZGrid(:)', numel(grids.CDM.CDM_YGrid), 1);

%set up the vegetation grid
[~, i_zmin] = min(abs(run.z-veg.CDM.elevMin)); %find location corresponding to veg.zmin
veg.CDM.xmin = i_zmin * grids.dx; %this should be valid as long as size of grid is contant (e.g., dont update grid size based on TWL condition)
if project.flag.VegCode == 0
    iuse = find(grids.CDM.ZD>=veg.CDM.elevMin & grids.CDM.ZD<=veg.CDM.elevMax);
    veg.CDM.vegmatrix = zeros(size(grids.CDM.ZD));
    veg.CDM.vegmatrix(iuse) = veg.CDM.startingDensity; %starting vegetation density - ultimately this probably shouldnt be hard coded
    dlmwrite('init_vx.dat', veg.CDM.vegmatrix', 'delimiter', ' ');
    dlmwrite('init_vy.dat', zeros(size(veg.CDM.vegmatrix')), 'delimiter', ' ');
    run.veget = veg.CDM.vegmatrix(round(grids.ny/2), :);
end

%set up the shear velocity
winds.windshear = (winds.CDM.vonKarman/log(winds.CDM.z/winds.CDM.z0))*winds.windspeed(:);
winds.windshear(find(isnan(winds.windshear) == 1)) = 0;

%eliminate very oblique winds
winds.windfrac = ones(size(winds.winddir));
ibad = find(winds.winddir<-88 | winds.winddir>88);%find things that have some x-shore component
winds.windfrac(ibad) = 0;
winds.winddir(ibad) = 0;
winds.windshear = winds.windshear(:).*winds.windfrac(:); %turn windshear to zero when has no x-shore component

%clean up variables

end