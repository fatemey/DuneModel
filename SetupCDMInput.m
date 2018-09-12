function SetupCDMInput0
% SetupCDMInput sets up input parameters for CDM model.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------

%set up vegetation and calculate temporal vegetation growth
if run_number > 1
    
    
    %perform vegetation growth
    try
        dhdt = run.wind_dz(:)';
    catch err
        dhdt = zeros(size(run.z(:)'));
    end
    
    %re-calculate where vegetation is allowed to grow at each time step
    [~, iveg] = min(abs(run.z-veg.CDM.elevMin));
    xmin = iveg;
    
    %run 1d veg model
    run.veget = cdm_veg_routine_1d(project, veg, grids, run.veget, dhdt, xmin);
end

%eliminate vegetation if it was knocked out by waves & water levels
if project.flag.XB == 1 && run_number>1 %need to update the vegetation grid if there was erosion from XBeach
    
    %assume erosion eliminates the vegetation and requires it to regrow
    ierode = find(run.wave_dz < veg.erosion_threshold & run.veget > 0);
    run.veget(ierode) = 0; %set vegetation back to zero density if vertical rates of erosion sufficient
    
    %assume that if too much accretion happens that the vegetation is
    %covered and also needs to start re-growing to induce wind+sed
    %transport
    iacc = find(run.wave_dz > veg.accretion_threshold & run.veget > 0);
    run.veget(iacc) = 0; %set vegetation back to zero density if vertical rates of erosion sufficient
    
    %if the water level has been above the vegetation for more than the threshold than assume it has died - this really eliminates the need for a Lveg condition
    iflood = find((run.z - project.twl(run_number)+veg.flood_threshold)<0);
    run.veget(iflood) = 0; %set vegetation back to zero density if vertical rates of erosion sufficient
end

if project.flag.CDM > 0 && winds.windspeed(run_number) > winds.threshold && abs(winds.winddir(run_number)) < 88 %dont need to do anything if this is an XBeach only simulation
    %move to right sub-model directory
    cd([project.Directory, filesep, 'cdm'])
    
    %If for some reason get NaN for TWL then make it zero (need to assume that 0 is MSL for that to be reasonable water level on average)
    if isnan(project.twl(run_number)) == 1
        project.twl(run_number) = 0;
    end
    
    %Run model for above water areas only
    run.iuse = find(X == min(grids.XGrid)); %this is not typically used in current Windsurf implemenetation, but can be applicable if CDM grid is not identical to XB grid
    
    %Set up CDM morphology - only initialize morphology for zones that are above water
    itemp = find(run.z<= project.twl(run_number)); %find areas below TWL
    itemp = 1:max(itemp);
    tempz = run.z;
    tempz(1:max(itemp)) = project.twl(run_number); %make elevations below TWL, the TWL elevation for influencing the wind field
    ZNEW= tempz-project.twl(run_number); %make all elevations relative to the TWL elevation temporarily
    ZNEW = ZNEW(:)'; %make sure row vector
    ZDNEW = repmat(ZNEW, numel(grids.CDM.CDM_YGrid), 1); %make right dimension
    dlmwrite('init_h.dat', ZDNEW', ' ');
    
    %Save data temporarily back to main set of files
    run.z_cdm = ZDNEW'; %load input morphology file
    
    %Make a Non-Erodible Surface that corresponds to anything below water since CDM is an aeolian model
    nonerode = ZDNEW;
    for ii = 1:grids.ny
        nonerode((max(itemp)+1):(end-grids.CDM.fixboundary_numcells), ii) = 0; %this makes the beach up to ten grid points before the end erodible, everything else is non-erodible
    end
    
    %Save out non-erodible surface file
    if project.flag.Aeolis ~=1
        dlmwrite([project.Directory, filesep, 'cdm', filesep, 'init_h_nonerod.dat'], nonerode', 'delimiter', ' ');
    else %if running an aeolis simulation then just run winds, dont have morphological evolution by turning all bed to non-erodible surface
        dlmwrite([project.Directory, filesep, 'cdm', filesep, 'init_h_nonerod.dat'], ZDNEW', 'delimiter', ' ');
    end
    clear nonerode ii
    delete([project.Directory, filesep, 'cdm', filesep, 'CDM_temp', filesep, '*.dat']) %delete all old output files
  
    % check this else
else %still need to create wind output if CDM was not run
    run.shear = ones(size(run.z)).*winds.windshear(run_number);
end
    
    %open file
    fid = fopen([project.Directory, filesep, 'cdm', filesep, 'default.par'], 'w');
    
    %write out parameters
    fprintf(fid, '%s\n', ['NX = ', num2str(grid.nx)]);
    fprintf(fid, '%s\n', ['NY = ', num2str(grid.ny)]);
    fprintf(fid, '%s\n', ['dx = ', num2str(grid.dx/cosd(winds.winddir(idx)))]);
    fprintf(fid, '%s\n', ['dt_max = ', num2str(project.CDM.timestep)]);
    
    if project.flag.CDM ~=2
        fprintf(fid, '%s\n', ['Nt = ', num2str(project.timeStep/(project.CDM.timestep))]);
        fprintf(fid, '%s\n', ['save.every = ', num2str(project.timeStep/(project.CDM.timestep))]);
    else %only need to run 1 time step if just want wind field
        fprintf(fid, '%s\n', ['Nt = 1']);
        fprintf(fid, '%s\n', ['save.every = 1']);
    end
    fprintf(fid, '%s\n', ['Nt0 = 0']);
    fprintf(fid, '%s\n', ['save.x-line = 0']);
    fprintf(fid, '%s\n', ['save.dir = ./CDM_temp']);
    fprintf(fid, '%s\n', ['calc.x_periodic = 0']);
    fprintf(fid, '%s\n', ['calc.y_periodic = 0']);
    fprintf(fid, '%s\n', ['calc.shift_back = 0']);
    fprintf(fid, '%s\n', ['influx = const']);
    fprintf(fid, '%s\n', ['q_in = 0']); %since the new model should inherintly add in the q_in term we leave this as zero for the time being
    fprintf(fid, '%s\n', ['wind = const']);
    fprintf(fid, '%s\n', ['constwind.u = ', num2str(winds.windshear(idx))]);
    fprintf(fid, '%s\n', ['constwind.direction = 0']); %this doesnt actually work - CDM can currently only simulate cross-shore winds
    fprintf(fid, '%s\n', ['wind.fraction = 1']);
    fprintf(fid, '%s\n', ['veget.calc = 1']);
    if project.flag.VegCode==1
        fprintf(fid, '%s\n', ['veget.xmin = 0']);
    else
        fprintf(fid, '%s\n', ['veget.xmin = ', num2str(veg.CDM.xmin)]);
    end
    fprintf(fid, '%s\n', ['veget.zmin = ', num2str(veg.CDM.elevMin)]);
    fprintf(fid, '%s\n', ['veget.Tveg = ', num2str(veg.CDM.Tveg)]);
    fprintf(fid, '%s\n', ['veget.sigma = ', num2str(veg.CDM.sigma)]);
    fprintf(fid, '%s\n', ['veget.beta = ', num2str(veg.CDM.beta)]);
    fprintf(fid, '%s\n', ['veget.m = ', num2str(veg.CDM.m)]);
    fprintf(fid, '%s\n', ['veget.season.t = 0']);
    fprintf(fid, '%s\n', ['veget.Vlateral.factor = 0']);
    fprintf(fid, '%s\n', ['calc.shore = 0']);
    fprintf(fid, '%s\n', ['beach.tau_t_L = 0.5']);
    fprintf(fid, '%s\n', ['shore.MHWL = 0']);
    fprintf(fid, '%s\n', ['shore.sealevel = 0']);
    fprintf(fid, '%s\n', ['shore.motion = 0']);
    fprintf(fid, '%s\n', ['shore.sealevelrise = 0']);
    fprintf(fid, '%s\n', ['shore.alongshore_grad = 0']);
    fprintf(fid, '%s\n', ['calc.storm = 0']);
    fprintf(fid, '%s\n', ['shore.correct.profile = 0']);
    fprintf(fid, '%s\n', ['init_h.x-line = 0']);
    fprintf(fid, '%s\n', ['veget.Init-Surf = init_h']);
    fprintf(fid, '%s\n', ['veget.init_h.file = init_vx.dat']);
    fprintf(fid, '%s\n', ['veget.init_h.file_aux = init_vy.dat']);
    fprintf(fid, '%s\n', ['veget.rho.max = ', num2str(veg.CDM.maximumDensity)]);
    fprintf(fid, '%s\n', ['salt.d = ', num2str(sed.CDM.D)]); %grain size in meters
    
    %set up grids
    fprintf(fid, '%s\n', ['Init-Surf = init_h']);
    fprintf(fid, '%s\n', ['init_h.file= init_h.dat']);
    %fprintf(fid, '%s\n', ['nonerod.Init-Surf = init_h']);
    fprintf(fid, '%s\n', ['nonerod.init_h.file = init_h_nonerod.dat']);
    
    %Save Outputs - 0 = save, 1 = don't save
    fprintf(fid, '%s\n', ['dontsave.veget = 0']);
    fprintf(fid, '%s\n', ['dontsave.u = 0']);
    fprintf(fid, '%s\n', ['dontsave.flux = 1']);
    fprintf(fid, '%s\n', ['dontsave.flux_s = 1']);
    fprintf(fid, '%s\n', ['dontsave.shear = 0']);
    fprintf(fid, '%s\n', ['dontsave.shear_pert = 0']);
    fprintf(fid, '%s\n', ['dontsave.stall = 0']);
    fprintf(fid, '%s\n', ['dontsave.rho = 1']);
    fprintf(fid, '%s\n', ['dontsave.h_deposit = 1']);
    fprintf(fid, '%s\n', ['dontsave.h_nonerod = 1']);
    fprintf(fid, '%s\n', ['dontsave.h_sep = 0']);
    fprintf(fid, '%s\n', ['dontsave.dhdt = 1']);
    fclose(fid);
    
    
end