function [line_len,xyzrays_input,xyzrays_end]=gen_mcp_strikes(rays,pitch)

%%
xyzrays=rand(rays,2);
xyzrays(:,3)=xyzrays(:,2);
xyzrays(:,2)=0;
%%scale input sampling range to max lim in the mcp plane
input_range=1/cos(pitch.rad);
input_range=1.2*input_range;
xyzrays=4.*(xyzrays-0.5);
xyzrays(:,2)=0;
%rotate this input mesh to the MCP surface plane
xyzrays=(rotx(-pitch.deg)*xyzrays')';
line_mask_input=(xyzrays(:,1).^2+xyzrays(:,3).^2)<1;

xyzrays_input=xyzrays(line_mask_input,:);
clear('xyzrays');
line_len=(xyzrays_input(:,3)+sqrt(1-xyzrays_input(:,1).^2))./sin(pitch.rad);

xyzrays_end=xyzrays_input-line_len*[0,-cos(pitch.rad),sin(pitch.rad)];
%check that the end is within the cyl
end_rad=(xyzrays_end(:,1).^2+xyzrays_end(:,3).^2);
if sum(abs(end_rad-1)>eps*5)>1
    error('some endpoints do not lie on the cyl')
end


%%Old method
%rays
%xpts_rays=50;
%zpts_rays=50;
%[xvalues_mesh,zvalues_mesh]=meshgrid(linspace(-2,2,xpts_rays),linspace(-2,2,zpts_rays));
%rotate this input mesh to the MCP surface plane
% xvalues_mesh=xvalues_mesh;
% yvalues_mesh=zvalues_mesh.*sin(pitch_rad);

% zvalues_mesh=zvalues_mesh.*cos(pitch_rad);
% xvalues_list=xvalues_mesh(:);
% zvalues_list=zvalues_mesh(:);
% yvalues_list=yvalues_mesh(:);

%sohcahtoa