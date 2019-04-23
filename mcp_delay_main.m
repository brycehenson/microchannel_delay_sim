%here i do a geomtric simulation of the difference in detection position
%across the input of a pore
%to check my simulations i can produce 3d plots that show that the
%calulated length is correct
%I start by uniformy sampling across a grid then i rotate it to match the
%slanted start of the pore, then i calculate how long the vector should be
%allong a particular angle and then make a line_end vector which should
%lie excatly on the cylinder which can be seen by do_3dplot=1;
do_3dplot=1;
vdet=sqrt(2*9.8*0.85);
pitch=2*pi/360*12;%12
%plot the hole walls
xpts_cyl=100;
ypts_cyl=50;
cyl_r=1;
worst_case=2*cyl_r/sin(pitch);

%% 3d plot
%rays
xpts_rays=50;
zpts_rays=50;
%[xvalues_mesh,zvalues_mesh]=meshgrid(linspace(-2,2,xpts_rays),linspace(-2,2,zpts_rays));

%rotate this input mesh to the MCP surface plane
xvalues_mesh=xvalues_mesh;
yvalues_mesh=zvalues_mesh.*sin(pitch);
zvalues_mesh=zvalues_mesh.*cos(pitch);

xvalues_list=xvalues_mesh(:);
zvalues_list=zvalues_mesh(:);
yvalues_list=yvalues_mesh(:);

line_mask=(xvalues_list.^2+zvalues_list.^2)<1;

linestart=[xvalues_list,yvalues_list,zvalues_list];
linestart=linestart(line_mask,:);
line_len=(linestart(:,3)+sqrt(1-linestart(:,1).^2))./sin(pitch);

a1=0;
b1=-cos(pitch);
c1=sin(pitch);
d1=0;
z1=-a1/c1.*xvalues_mesh-b1/c1*yvalues_mesh+d1/c1;

u=linspace(0,2*pi,1e3);
yelipse=sin(u)*sin(pitch)/cos(pitch);
xelipse=cos(u);
zelipse=sin(u);
xyz_elipse=[xelipse;yelipse;zelipse];
rot_elipse=rotx(pitch*180/pi)*xyz_elipse;

if do_3dplot
    figure(1)
    line_mask=line_len>0;%<worst_case;
    %line_mask=line_len<3.05 & line_len>2.95;
    line_end=linestart(line_mask,:)-line_len(line_mask)*[0,-cos(pitch),sin(pitch)];
    end_rad=(line_end(:,1).^2+line_end(:,3).^2);
    %start_rad=(linestart(line_mask,1).^2+linestart(line_mask,3).^2);
    clf;
    paths=cat(3,linestart(line_mask,:),line_end);
    paths=shiftdim(paths,2);
    [x,y] = meshgrid(linspace(-1.1,1.1,xpts_cyl),linspace(-0.4,4,ypts_cyl));
    z = -sqrt(1-x.^2);
    z(imag(z)~=0) = nan;
    surf(x,y,z)
    axis equal
    hold on
    surf(x,y,-z)
    
    mcp_surface_plane=mesh(xvalues_mesh,yvalues_mesh,z1);
    colormap('parula')

    plot3(xelipse,yelipse,zelipse,'r','LineWidth',2)
    plot3(rot_elipse(1,:),rot_elipse(2,:),rot_elipse(3,:),'g','LineWidth',2)
    
    
    %mcp_surface_plane2=surf(xvalues_mesh,yvalues_mesh,zvalues_mesh);
    %mcp_surface_plane2.CData= mcp_surface_plane2.CData*0+3;
    %alpha(mcp_surface_plane,0.3)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    set(gcf,'color','w')
    %colormap([0.5,0.5,0.5])
    %colormap gray
    %shading flat
    plot3(paths(:,:,1),paths(:,:,2),paths(:,:,3),'b' )
    hold off
    pause(0.1)
else

    mean_len=mean(line_len);
    std_len=std(line_len);
    figure(2)
    clf;
    line_len=line_len(line_len>0);
    [counts,edges] = histcounts(line_len,linspace(0,worst_case,1e2));
    cen=0.5*(edges(1:end-1)+edges(2:end));
    cen_t=cen/vdet;
    %counts=gaussfilt(cen,counts,worst_case/200);
    counts=counts./trapz(cen,counts);
    %counts=conv(counts,fspecial('gaussian',[1 50],5),'same');
    %counts=smoothdata(counts,'gaussian',10);
    cen_mir=[-fliplr(cen),cen];
    counts_mir=[fliplr(counts),counts];
    fwhm_width=fwhm(cen_mir,counts_mir);
    hwhm_width=fwhm_width/2;
    %plot(cen_mir,counts_mir)
    plot(cen,counts,'k')
    hold on
    plot(cen,(4/(pi*worst_case^2))*abs(sqrt(worst_case^2-cen.^2)))

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
    median=interp1(cum_counts,cen,0.5);
    plot(cen,cum_counts,'k')
    line(median*[1,1],ylim,'Color',[1 0 0])
    ylabel('Cumulative Fraction')
    xlabel('Travel Distance/Pore Radius')

    fprintf('mean %2.3e , std %2.3e , HWHM %2.3e \n',mean_len,std_len,hwhm_width)
    fprintf('median %2.3e , worst case %2.3e \n',median,worst_case) 
    %for our system
    pore_r=10e-6/2;
    t_worst=(pore_r*2/sin(pitch))/vdet;
    fprintf('for our det\n')
    fprintf('mean %2.3e us , std %2.3e us, HWHM %2.3e us\n',mean_len*1e6*pore_r/vdet,std_len*1e6*pore_r/vdet,hwhm_width*1e6*pore_r/vdet)
    fprintf('median %2.3e us, worst case %2.3e us \nsampled with %2.1e points \n',median*1e6*pore_r/vdet,t_worst*1e6,size(line_len,1)) 
    figure(2)
    line(median.*[1,1],ylim,'Color',[1 0 0])
end



