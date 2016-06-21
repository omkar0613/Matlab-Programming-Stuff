function [ adveq, rhsvec ] = AdvEqual( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for kindex=1:nargin
    switch kindex
        case 1
            adveq.himp = varargin{1};
            adveq.Nlength_h= length(adveq.himp);
            adveq.state_h   = zeros(1,adveq.Nlength_h-1);
        case 2
            adveq.b = varargin{2};
            adveq.Nlength_b= length(adveq.b);
        case 3
            adveq.gimp = varargin{3};
            adveq.Nlength_g= length(adveq.gimp);
            adveq.state_g   = zeros(1,adveq.Nlength_g-1);
        case 4
            adveq.weq    = 1;
            adveq.Nlength_w =varargin{4};
            adveq.state_w = zeros(1, adveq.Nlength_w-1);
        case 5
            adveq.P   = varargin{5};
        case 6
            adveq.np  = varargin{6};
        case 7
            adveq.nvar = varargin{7};
        case 8
            adveq.stattype = varargin{8};
        otherwise
            error('AdvEqual.m: Too many input arguments');
    end
end

adveq.hmat=zeros(adveq.Nlength_w,adveq.Nlength_w+ adveq.Nlength_h-1);
for nh=1:adveq.Nlength_w
    adveq.hmat(nh,nh:nh+adveq.Nlength_h-1)=adveq.himp.';
end

adveq.bmat=zeros(adveq.P,adveq.Nlength_h+adveq.Nlength_w-1);
for ng=0:adveq.Nlength_h+adveq.Nlength_w-2
    adveq.bmat(:,ng+1)=indorg(adveq.b, adveq.np-ng, adveq.np-ng+adveq.P-1);
end


adveq.Rvv=max(adveq.Nlength_w)*adveq.nvar*eye(max(adveq.Nlength_w));

zhead=zeros(ceil(0.5*(adveq.Nlength_w+adveq.Nlength_h-1-adveq.Nlength_g)),1);
ztail=zeros(floor(0.5*(adveq.Nlength_w+adveq.Nlength_h-1-adveq.Nlength_g)),1);
switch adveq.stattype
    case 'emperical'
        F1=(adveq.Rvv+ conj(adveq.hmat)*adveq.bmat'*adveq.bmat*adveq.hmat.');
        F2= conj(adveq.hmat)*adveq.bmat'*adveq.bmat*[zhead; adveq.gimp; ztail];
        rhsvec=[zhead; adveq.gimp; ztail];
    case 'statistical'
        Rbbstat=adveq.P*var(adveq.b,1)*eye(adveq.Nlength_h+adveq.Nlength_w-1);
        F1=(adveq.Rvv+ conj(adveq.hmat)*Rbbstat*adveq.hmat.');
        F2= conj(adveq.hmat)*Rbbstat*[zhead; adveq.gimp; ztail];
        rhsvec=[zhead; adveq.gimp; ztail];
    otherwise
        error('invalid statistical model')
end
tempval=inv(F1)*F2;
adveq.weq = tempval(1:adveq.Nlength_w);

adveq = class(adveq, 'AdvEqual');


end

