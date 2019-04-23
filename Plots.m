figure(1)
clf;
vdet=sqrt(2*9.8*0.85);
pore_r=12e-6/2;
t_worst=(pore_r*2/sin(pitch))/vdet;
t_mean=t_worst*4/(3*pi);
t_sd=t_worst*(1/6)*sqrt(9 - 64/(pi^2)) ;
times=linspace(0,t_worst,500);
pop=(1/(0.25*pi*t_worst^2))*abs(sqrt(t_worst^2-times.^2));
plot(times*1e6,pop)
hold on
set(gcf,'color','w')
xlabel('Detection Time (\mus)')
ylabel('Frequency')
%ylim([0 0.15])
set(gca,'fontsize',30)
set(gca,'LineWidth',2,'TickLength',[0.025 0.025]);
drawnow
line(1e6*t_worst*[1,1],ylim,'Color',[1 0 0])
line(1e6*t_mean*[1,1],ylim,'Color',[0 0 0])
line(1e6*(t_mean+t_sd)*[1,1],ylim,'Color',[0 0 0])
line(1e6*(t_mean-t_sd)*[1,1],ylim,'Color',[0 0 0])
set(gcf,'units','points','position',[100,100,500,300])
hold off
