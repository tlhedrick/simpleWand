function  [c,rmse] = dlt_computeCoefficients(frame,camPts)

% function  [c,rmse] = dlt_computeCoefficients(frame,camPts)
%
% A basic implementation of 11 parameter DLT
%
% Inputs:
%  frame - an array of x,y,z calibration point coordinates
%  camPts - an array of u,v pixel coordinates from the camera
%
% Outputs:
%  c - the 11 DLT coefficients
%  rmse - root mean square error for the reconstruction; units =
%
% Notes - frame and camPts must have the same number of rows.  A minimum of
% 6 rows are required to compute the coefficients.  The frame points must
% not all lie within a single plane
%
% Ty Hedrick

% check for any NaN rows (missing data) in the frame or camPts
ndx=find(sum(isnan([frame,camPts]),2)>0);

% remove any missing data rows
frame(ndx,:)=[];
camPts(ndx,:)=[];

% re-arrange the frame matrix to facilitate the linear least squares
% solution
M=zeros(size(frame,1)*2,11);
for i=1:size(frame,1)
  M(2*i-1,1:3)=frame(i,1:3);
  M(2*i,5:7)=frame(i,1:3);
  M(2*i-1,4)=1;
  M(2*i,8)=1;
  M(2*i-1,9:11)=frame(i,1:3).*-camPts(i,1);
  M(2*i,9:11)=frame(i,1:3).*-camPts(i,2);
end

% re-arrange the camPts array for the linear solution
camPtsF=reshape(flipud(rot90(camPts)),numel(camPts),1);

% get the linear solution to the 11 parameters
c=linsolve(M,camPtsF);

% compute the position of the frame in u,v coordinates given the linear
% solution from the previous line
Muv=dlt_inverse(c,frame);

% compute the root mean square error between the ideal frame u,v and the
% recorded frame u,v
rmse=(sum(sum((Muv-camPts).^2))./numel(camPts))^0.5;

