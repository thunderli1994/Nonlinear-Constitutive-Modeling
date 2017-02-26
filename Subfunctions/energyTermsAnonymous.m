function [ U ] = energyTerms( alpha1,alpha2,alpha3,H,T,options )
%ENERGYTERMS Summary of this function goes here
%   Detailed explanation goes here

%return options as variables
parseStructure(options);

%Zeeman (external field energy)
U_H = @(theta,phi,H,T) -permeability_0.*Ms.*(alpha1(theta,phi).*H(1,:) + alpha2(theta,phi).*H(2,:) + alpha3(theta,phi).*H(3,:));

%Crystalline
switch crystal
    case 'uniaxial'
        U_mca = @(theta,phi,H,T) K1.*sin(theta).^2 +K2.*sin(theta).^4 + K4.*sin(theta).^6.*cos(phi)  ;
    case 'cubic'
        U_mca = @(theta,phi,H,T) ...
            K1.*(...
            alpha1(theta,phi).^2.*alpha2(theta,phi).^2 + ...
            alpha1(theta,phi).^2.*alpha3(theta,phi).^2 + ...
            alpha2(theta,phi).^2.*alpha3(theta,phi).^2   ) +...
            K2.*(...
            alpha1(theta,phi).^2.*...
            alpha2(theta,phi).^2.*...
            alpha3(theta,phi).^2);
end

%Magnetoelastic Energy
B1 = 3/2.*S100.*(C12-C11);
B2 = -3.*S111*C44;
C = [C11 C12 C12 0  0   0;...
    C12 C11 C12 0   0   0;...
    C12 C12 C11 0   0   0;...
    0   0   0   C44 0   0;...
    0   0   0   0   C44 0;...
    0   0   0   0   0   C44;
    ];
S = C^(-1);

U_magElast = @(theta,phi,H,T) ...
    B1.*(S(1,1)-S(1,2)).*...
    (...
    T(1,:) .* alpha1(theta,phi).^2 + ...
    T(2,:) .* alpha2(theta,phi).^2 + ...
    T(3,:) .* alpha3(theta,phi).^2 - ...
    1/3 .* (T(1,:)+T(2,:)+T(3,:))...
    ) + ...
    B2.*S(4,4).*...
    (...
    T(4,:) .* alpha2(theta,phi) .* alpha3(theta,phi) +...
    T(5,:) .* alpha1(theta,phi) .* alpha3(theta,phi) +...
    T(6,:) .* alpha1(theta,phi) .* alpha2(theta,phi)...
    );

%Total
U =@(theta,phi,H,T)...
    U_H(theta,phi,H,T) + ...
    U_mca(theta,phi,H,T) + ...
    U_magElast(theta,phi,H,T) ;     %J/m^3

end

