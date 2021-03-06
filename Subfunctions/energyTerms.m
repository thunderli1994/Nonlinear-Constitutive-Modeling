function [ U ] = energyTerms( alpha1,alpha2,alpha3,...
    alpha1rot,alpha2rot,alpha3rot,...
    H,S,options )
%ENERGYTERMS Summary of this function goes here
%   Detailed explanation goes here

%return options as variables
parseStructure(options);

%% Zeeman (external field energy)
U_H = -permeability_0.*Ms.*(alpha1.*H(1,:) + alpha2.*H(2,:) + alpha3.*H(3,:));

%% Crystalline

switch crystal
    case 'uniaxial'
        U_mca =  K1.*sin(theta).^2 +K2.*sin(theta).^4 + K4.*sin(theta).^6.*cos(phi)  ;
    case 'cubic'
        
        U_mca =  ...
            K1.*(...
            alpha1rot.^2.*alpha2rot.^2 + ...
            alpha1rot.^2.*alpha3rot.^2 + ...
            alpha2rot.^2.*alpha3rot.^2   ) +...
            K2.*(...
            alpha1rot.^2.*...
            alpha2rot.^2.*...
            alpha3rot.^2);
end

%% Magnetoelastic Energy

U_magElast = ...
    B1.*...
    (...
    S(1,:) .* alpha1rot.^2 + ...
    S(2,:) .* alpha2rot.^2 + ...
    S(3,:) .* alpha3rot.^2 ...
    ) + ... 
    B2.*...
    (...
    S(4,:) .* alpha2rot .* alpha3rot +...
    S(5,:) .* alpha1rot .* alpha3rot +...
    S(6,:) .* alpha1rot .* alpha2rot...
    );

%add the elastic energy 


%% Total
U = U_H + U_mca + U_magElast ;     %J/m^3

end
