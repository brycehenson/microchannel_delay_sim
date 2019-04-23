%here i do a geomtric simulation of the difference in detection position
%across the input of a pore
%to check my simulations i can produce 3d plots that show that the
%calulated length is correct
%I start by uniformy sampling across a grid then i rotate it to match the
%slanted start of the pore, then i calculate how long the vector should be
%allong a particular angle and then make a line_end vector which should
%lie excatly on the cylinder which can be seen by do_3dplot=1;
do_3dplot=0;
vdet=sqrt(2*9.8*0.85);
pitch.deg=12;
pitch.rad=pitch.deg*pi/180;%12
%plot the hole walls
xpts_cyl=100;
ypts_cyl=50;
cyl_r=1;
worst_case=2*cyl_r/sin(pitch.rad);

%add all subfolders to the path
this_folder = fileparts(which(mfilename));
% Add that folder plus all subfolders to the path.
addpath(genpath(this_folder));

%% Plot the thing
rays=5e2;
[line_len,xyzrays_input,xyzrays_end]=gen_mcp_strikes(rays,pitch);

figure(1)
clf;
line_mask_input=line_len>0;%<worst_case;
%line_mask=line_len<3.05 & line_len>2.95;
%line_end=linestart(line_mask,:)+line_len(line_mask).*(rotx(-pitch.deg)*[0,1,0]')';
%start_rad=(linestart(line_mask,1).^2+linestart(line_mask,3).^2);
clf;
paths=cat(3,xyzrays_input(line_mask_input,:),xyzrays_end);
paths=shiftdim(paths,2);
plot3(paths(:,:,1),paths(:,:,2),paths(:,:,3),'k' )
hold on

% mcp holes
[x,y] = meshgrid(linspace(-1.1,1.1,xpts_cyl),linspace(-0.4,4,ypts_cyl));
z = -sqrt(1-x.^2);
z(imag(z)~=0) = nan;
lower_cyl=surf(x,y,z);
lower_cyl.FaceAlpha=0.7;
axis equal
%plot the upper half cyl
%surf(x,y,-z)

%mcp plane
mcp_plane_pts=10;
xyz_mcp_plane=[];
range_y=abs(tan(pitch.rad)); %range of y to capture input
[atmp,btmp]=meshgrid(linspace(-1,1,mcp_plane_pts),linspace(-range_y,range_y,mcp_plane_pts));
xyz_mcp_plane=cat(3,atmp,btmp);
clear('atmp','btmp')
a1=0;
b1=-cos(pitch.rad);
c1=sin(pitch.rad);
d1=0;
xyz_mcp_plane(:,:,3)=-a1/c1.*xyz_mcp_plane(:,:,1)-b1/c1*xyz_mcp_plane(:,:,2)+d1/c1;
mcp_surface_plane=mesh(xyz_mcp_plane(:,:,1),xyz_mcp_plane(:,:,2),xyz_mcp_plane(:,:,3));
mcp_surface_plane.FaceAlpha=0.5;
colormap('parula')

% plot the cyl surface intersection
u=linspace(0,2*pi,1e3);
yelipse=sin(u)*sin(pitch.rad)/cos(pitch.rad);
xelipse=cos(u);
zelipse=sin(u);
xyz_elipse=[xelipse;yelipse;zelipse];
clear('yelipse','xelipse','zelipse')
plot3(xyz_elipse(1,:),xyz_elipse(2,:),xyz_elipse(3,:),'r','LineWidth',2)
%rot_elipse=rotx(pitch.rad*180/pi)*xyz_elipse;
%plot3(rot_elipse(1,:),rot_elipse(2,:),rot_elipse(3,:),'g','LineWidth',2)



xlabel('x')
ylabel('y')
zlabel('z')
set(gcf,'color','w')
%colormap([0.5,0.5,0.5])
%colormap gray
%shading flat

%export_fig figs/test.png -m3 -a4


hold off
pause(0.1)

    
    %%
rays=1e8;
line_len=gen_mcp_strikes(rays,pitch);

approx_fun=@(x,worst_case) (4/(pi*worst_case^2))*abs(sqrt(worst_case^2-x.^2));

mean_len=mean(line_len);
std_len=std(line_len);
figure(2)
clf;
line_len=line_len(line_len>0);
[counts,edges] = histcounts(line_len,linspace(0,worst_case,1e6));
bin_cen=0.5*(edges(1:end-1)+edges(2:end));
cen_t=bin_cen/vdet;
counts=gaussfilt(bin_cen,counts,worst_case*1e-3);
counts=counts./trapz(bin_cen,counts);
%counts=conv(counts,fspecial('gaussian',[1 50],5),'same');
%counts=smoothdata(counts,'gaussian',10);
cen_mir=[-fliplr(bin_cen),bin_cen];
counts_mir=[fliplr(counts),counts];
fwhm_width=fwhm(cen_mir,counts_mir);
hwhm_width=fwhm_width/2;
%plot(cen_mir,counts_mir)
plot(bin_cen,counts,'k')
hold on
approx_dist=approx_fun(bin_cen,worst_case);
%approx_dist=approx_dist./trapz(bin_cen,approx_dist);
plot(bin_cen,approx_dist)

set(gcf,'color','w')
xlabel('Travel Distance/Pore Radius')
ylabel('Norm Counts')
%ylim([0 0.15])
set(gca,'fontsize',20)
set(gca,'LineWidth',2,'TickLength',[0.025 0.025]);
drawnow
line(worst_case*[1,1],ylim,'Color',[1 0 0])
line(mean_len*[1,1],ylim,'Color',[0 0 0])
line((mean_len+std_len)*[1,1],ylim,'Color',[0 0 0])
line((mean_len-std_len)*[1,1],ylim,'Color',[0 0 0])
line(hwhm_width*[1,1],ylim,'Color',[1 0 0])
hold off

figure(3)
cum_counts=cumsum(counts.*(edges(2:end)-edges(1:end-1)));
median=interp1(cum_counts,bin_cen,0.5);
plot(bin_cen,cum_counts,'k')
line(median*[1,1],ylim,'Color',[1 0 0])
ylabel('Cumulative Fraction')
xlabel('Travel Distance/Pore Radius')

fprintf('mean %2.3e , std %2.3e , HWHM %2.3e \n',mean_len,std_len,hwhm_width)
fprintf('median %2.3e , worst case %2.3e \n',median,worst_case) 
%for our system
pore_r=10e-6/2;
t_worst=(pore_r*2/sin(pitch.rad))/vdet;
fprintf('for our det\n')
fprintf('mean %2.3e us , std %2.3e us, HWHM %2.3e us\n',mean_len*1e6*pore_r/vdet,std_len*1e6*pore_r/vdet,hwhm_width*1e6*pore_r/vdet)
fprintf('median %2.3e us, worst case %2.3e us \nsampled with %2.1e points \n',median*1e6*pore_r/vdet,t_worst*1e6,size(line_len,1)) 
figure(2)
line(median.*[1,1],ylim,'Color',[1 0 0])




