function SetupAeolisInput
% SetupAeolisInput0 sets up input parameters for Aeolis model.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------

if i==2
    %aeolis_params.m - Code to set up Aeolis parameter file for Windsurf coupler
    %Created By: N. Cohn, Oregon State University
    
    %create filename
    fid = fopen([project.Directory, filesep, 'aeolis', filesep, 'aeolis.txt'], 'w');
    
    %implement grain size distribution from d10,d50,d90
    %assume the following distribution to start - NEED TO UPDATE THIS IN
    %FUTURE TO TRACK CHANGES IN GRAIN SIZE WITH TIME
    sed_dist = [0.3 0.4 0.3];
    
    %write variables to file
    fprintf(fid, '%s\n', ['bed_file = z.txt']);
    %fprintf(fid, '%s\n', ['bi = 0.050000']);
    fprintf(fid, '%s\n', ['bi = 1']);
    fprintf(fid, '%s\n', ['dt = ', num2str(project.Aeolis.timestep)]);
    fprintf(fid, '%s\n', ['dx = ', num2str(grids.dx)]);
    fprintf(fid, '%s\n', ['dy = 1.000000']);
    fprintf(fid, '%s\n', ['grain_dist = 0.3 0.4 0.3']);
    fprintf(fid, '%s\n', ['grain_size = ', num2str(sed.XB.D10), ' ', num2str(sed.XB.D50), ' ', num2str(sed.XB.D90)]);
    %    if run_number>1 %add in the bed composition file if it is not the first simulation
    %       fprintf(fid, '%s\n', ['bedcomp_file = bedcomp.txt'])
    %    end
    %fprintf(fid, '%s\n', ['layer_thickness = 0.01000']);
    fprintf(fid, '%s\n', ['nfractions = 3']);
    fprintf(fid, '%s\n', ['nlayers = 5']);
    fprintf(fid, '%s\n', ['nx = ', num2str(grids.nx-1)]);
    fprintf(fid, '%s\n', ['ny = 0']);
    fprintf(fid, '%s\n', ['output_file = aeolis.nc']);
    fprintf(fid, '%s\n', ['output_times = ', num2str(project.timeStep)]);
    fprintf(fid, '%s\n', ['output_types = avg']);
    %fprintf(fid, '%s\n', ['output_vars = zb zs Ct Cu uw udir uth mass pickup w']);
    fprintf(fid, '%s\n', ['output_vars = zb']);
    fprintf(fid, '%s\n', ['scheme = euler_backward']);
    fprintf(fid, '%s\n', ['tide_file = tide.txt']);
    fprintf(fid, '%s\n', ['tstart = 0']);
    fprintf(fid, '%s\n', ['tstop = ', num2str(project.timeStep)]);
    %fprintf(fid, '%s\n', ['wind_file = wind.txt'])
    fprintf(fid, '%s\n', ['xgrid_file = x_aeolis.txt']);
    fprintf(fid, '%s\n', ['ygrid_file = y_aeolis.txt']);
    %fprintf(fid, '%s\n', ['meteo_file = meteo.txt']);
    %fprintf(fid, '%s\n', ['process_meteo = T']);
    fprintf(fid, '%s\n', ['Cb = ', num2str(sed.Aeolis.Cb)]);
    fprintf(fid, '%s\n', ['m = ', num2str(sed.Aeolis.m)]);
    fprintf(fid, '%s\n', ['A = ', num2str(sed.Aeolis.A)]);
    
    %DONT NEED THE FOLLOWING BECAUSE OF HOTSTART FUNCTION
    %fprintf(fid, '%s\n', ['u_type = 2']) %this is new variable to read external files
    %fprintf(fid, '%s\n', ['u_file = cdm_u_file.txt'])
    %fprintf(fid, '%s\n', ['ux_file = cdm_ux_file.txt'])
    %fprintf(fid, '%s\n', ['uy_file = cdm_uy_file.txt'])
    %fprintf(fid, '%s\n', ['tau_file = cdm_tau_file.txt'])
    %fprintf(fid, '%s\n', ['taux_file = cdm_taux_file.txt'])
    %fprintf(fid, '%s\n', ['tauy_file = cdm_tauy_file.txt'])
    
    fclose(fid);
    clear sed_dist
    dlmwrite('x_aeolis.txt', grids.XGrid-grids.XGrid(1), 'delimiter', ' '); %write aeolis x-grid
    dlmwrite('y_aeolis.txt', zeros(size(grids.XGrid)), 'delimiter', ' '); %write aeolis y-grid
    
    
    if winds.windspeed(run_number) > winds.threshold  && abs(winds.winddir(run_number)) < 88%only run above wind threshold
        % Generate Environmental Parameters
        
        %until moisture and groundwater are implemented, assume that the
        %swash zone does not dry instantaneously, so give a 6 hour buffer
        %for drying
        iuse = [run_number-waves.Aeolis.swashDryTimeSteps]:run_number;
        iuse(iuse<1) = run_number;
        max_tide = nanmax(project.twl(iuse));
        
        fid = fopen('tide.txt', 'w');
        fprintf(fid, '%s\n', ['0 ', num2str(max_tide)]);
        fprintf(fid, '%s\n', [num2str(project.timeStep), ' ', num2str(max_tide)]);
        fclose(fid);
        clear iuse max_tide
        
        %Generate Morphology Input
        dlmwrite('z.txt', run.z(:), 'delimiter', ' ');
        
        %Velocity and Shear Stress - store all outputs to standard netcdf file, assume shore normal winds if nan'd out
        wind_direction = winds.winddir(run_number);
        if isnan(wind_direction) == 1
            wind_direction = 0;
        end
        
        if project.flag.CDM == 2 %flag says that CDM is run for wind model only and not morphology change
            shear = run.shear; %use the existing shear if already ran CDM
            maxshear = 5; %this is a high value to start, but should help model from blowing up
            shear(shear>maxshear) = maxshear;
            shear(run.z < project.twl(run_number)) = 0;
            shearx = shear.*cosd(wind_direction);
            sheary = shear.*sind(wind_direction);
            run.shear = shear;
            run.shearx = shearx;
            run.sheary = sheary;
            dlmwrite('tau.hotstart', shear(1:end)', 'delimiter', ' ', 'precision', '%.6f');
        else
            run.shear = zeros(size(run.z)); %else temporarily store as zeros, can add ability to output from Aeolis later
            run.shearx = zeros(size(run.z)); %else temporarily store as zeros, can add ability to output from Aeolis later
            run.sheary = zeros(size(run.z)); %else temporarily store as zeros, can add ability to output from Aeolis later
        end
        
        %set u to constant value for Aeolis simulations
        u = ones(size(run.z))*winds.windspeed(run_number);
        
        %set values that are zero slightly above zero
        smallval = 0.001;
        shear(shear == 0) = smallval;
        u(u == 0) = smallval;
        
        %eliminate any shear for water cells
        u(run.z < project.twl(run_number)) = smallval;
        
        %fix values for wind direction
        ux = u.*cosd(wind_direction);
        uy = u.*sind(wind_direction);
        
        %use hotstart files to initialize aeolis from CDM
        
        %for now just utilize the cross-shore component of wind to transport
        dlmwrite('uw.hotstart', ux(1:end)', 'delimiter', ' ', 'precision', '%.6f');
        
        %Clean up variables
        clear wind_direction u ux uy shear shearx sheary smallval maxshear
    else %check this else
        run.wind_dz = zeros(size(run.z(:))); %this needs to be updated in the case that CDM is run to calculate aeolian transport
    end
end
