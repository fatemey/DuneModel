function [Z, wl, H] = ReadXBeachOutput
% ReadXBeachOutput reads XBeach model outputs and updates the relevant
% files passing data needed for next steps.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------
% 'H_mean', 'zs_max'

Z = ncread('xboutput.nc', 'zb'); % bed level
Z = squeeze(Z(:,:,end));

wl = ncread('xboutput.nc', 'zs'); % water level
wl = squeeze(wl(:,:,end));

H = ncread('xboutput.nc', 'H');
H = squeeze(H(:,:,end));

end
