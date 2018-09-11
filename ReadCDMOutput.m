function ReadCDMOutput0
% ReadCDMOutput reads CDM model outputs and updates the relevant
% files passing data needed for next steps.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------
%pick the last output file
if project.flag.CDM ~=2
    output_num = project.timeStep/project.CDM.timestep;
else
    output_num = 1; %only run for 1 time step if only pulling out wind
end

output.h = load([project.Directory, filesep, 'cdm', filesep, 'CDM_temp', filesep, 'h.', sprintf('%05d',output_num),'.dat']);
output.veget_x = load([project.Directory, filesep,'cdm', filesep,'CDM_temp', filesep, 'veget_x.', sprintf('%05d',output_num),'.dat']);
output.shear_x = load([project.Directory, filesep,'cdm', filesep,'CDM_temp', filesep, 'shear_x.', sprintf('%05d',output_num),'.dat']);
output.u_x = load([project.Directory, filesep,'cdm', filesep,'CDM_temp', filesep, 'u_x.', sprintf('%05d',output_num),'.dat']);
% output.flux_x = load([project.Directory, filesep, 'cdm', filesep,'CDM_temp', filesep, 'flux_x.', sprintf('%05d',output_num),'.dat']);
output.stall = load([project.Directory, filesep, 'cdm', filesep,'CDM_temp', filesep, 'stall.', sprintf('%05d',output_num),'.dat']);
output.shear_pert_x = load([project.Directory, filesep, 'cdm', filesep,'CDM_temp', filesep, 'shear_pert_x.', sprintf('%05d',output_num),'.dat']);
output.h_sep = load([project.Directory, filesep, 'cdm', filesep,'CDM_temp', filesep, 'h_sep.', sprintf('%05d',output_num),'.dat']);
%output.u_y = load([project.Directory, filesep,'cdm', filesep,'CDM_temp', filesep, 'u_y.', sprintf('%05d',output_num),'.dat']);
%output.shear_y = load([project.Directory, filesep,'cdm', filesep,'CDM_temp', filesep, 'shear_y.', sprintf('%05d',output_num),'.dat']);
%output.shear_pert_y = load([project.Directory, filesep,'cdm', filesep,'CDM_temp', filesep, 'shear_pert_y.', sprintf('%05d',output_num),'.dat']);

    %save CDM values for NetCDF file - Note that fill in zeros for where CDM grid was not run (e.g., seaward of water line)
    ycells2use = 2:3; %assumed ny = 4 for this which could change into the future for fully 2D simulations
    if project.flag.VegCode ~= 1 %only update vegetation if calculated internally within CDM
        run.veget = zeros(size(grids.XGrid)); %dont use CDM output for now
        run.veget((run.iuse+(max(itemp))):end) = mean(output.veget_x((max(itemp)+1):end, ycells2use), 2);
    end
    run.u = zeros(size(grids.XGrid));
    run.u((run.iuse+(max(itemp))):end) = mean(output.u_x((max(itemp)+1):end, ycells2use), 2);        
    run.shear = zeros(size(grids.XGrid));
    run.shear((run.iuse+(max(itemp))):end) = mean(output.shear_x((max(itemp)+1):end, ycells2use), 2);   
    run.shear_pertx = zeros(size(grids.XGrid));
    run.shear_pertx((run.iuse+(max(itemp))):end) = mean(output.shear_pert_x((max(itemp)+1):end, ycells2use), 2);  
    run.h_sep = zeros(size(grids.XGrid));
    run.h_sep((run.iuse+(max(itemp))):end) = mean(output.h_sep((max(itemp)+1):end, ycells2use), 2);  
    run.stall = zeros(size(grids.XGrid));
    run.stall((run.iuse+(max(itemp))):end) = mean(output.stall((max(itemp)+1):end, ycells2use), 2);          
    run.startvalue = run.iuse+(max(itemp));
    run.itemp = itemp;
    run.output = output;
    
    %Correct for the fact that CDM output does not represent the "final" shear velocity  
    run.shear = winds.windshear(run_number); %start with the input shear velocity
    total_tau = run.shear(:)+abs(run.shear(:)).*run.shear_pertx(:);
    
    %The variable that relates to seperation bubble seems to be "stall"
    %(h_sep) usually just equals h - DOES NOT SEEM TO FULLY WORK, COMMENTED OUT FOR NOW
    total_tau(run.stall<0) = 0; %set shear to zero where there is stall
      
    %Correct shear for vegetation
    if veg.CDM.shearType == 1 %this is the standard routine
        vegetgamma = veg.CDM.m*veg.CDM.beta/veg.CDM.sigma;
        total_tau = total_tau(:)./(1+vegetgamma.*run.veget(:));
    else % can add in the Okin model or others if want
        total_tau = total_tau(:).*(1-run.veget(:)); %linear reduction that will get rid of shear where there is 100% veg cover
    end
        
    %Fix issues near edge of grid
    total_tau(end-grids.CDM.fixboundary_numcells:end) = 0; 
    
    %Now pass the total shear
    run.shear = total_tau;
    
    
end