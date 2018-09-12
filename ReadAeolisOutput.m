function ReadAeolisOutput
% ReadAeolisOutput reads Aeolis model outputs and updates the relevant
% files passing data needed for next steps.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------
            z = ncread('aeolis.nc', 'zb');
            if numel(z)>numel(grids.ZGrid)
                tempz = z(:, 1, end);
            else
                tempz = z;
            end
            run.wind_dz = tempz(:) - run.z(:);
            run.z = tempz;
                        delete('aeolis.nc');    
