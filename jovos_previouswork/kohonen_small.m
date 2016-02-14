clear all;
takemovie=1;
('V:\Mouse\KDM-SYN-100824B\aligned stacks')

%make evenly spaced points on the color circle
hue=0:.002:1;

%calculate the difference in hue between all the points
%setup matrices with values of hue1 and hue2
[h1,h2]=meshgrid(hue,hue);
%calculate the absolute difference
dhue=abs(h1-h2);
%for hues more than .5 apart, take the complement distance which is smaller
badones=find(dhue>.5);
dhue(badones)=1-dhue(badones);



%we want constant saturation and value for our HSV values
saturation=ones(size(hue));
value=ones(size(hue));

%construct an hsv colormap
hsv=[hue;saturation;value]';

%plot out our color wheel
figure(1);
clf;
%calculate the x and y positions
x=cos(hue*2*pi);
y=sin(hue*2*pi);
%scatter plot the results using our hsv values to color them
scatter(x,y,10,hsv2rgb(hsv));

r=.3+5*abs(randn(1000,1)).^.7;
theta=.1;
phi=0;
x=r*cos(theta);
y=r*sin(theta);
z=r*sin(phi);
data=[x y z];

r=.2+7*abs(randn(1000,1)).^.7;
theta=2.4;
phi=0;
x=r*cos(theta);
y=r*sin(theta);
z=r*sin(phi);
data=[data;[x y z]];

r=.2+7*abs(randn(1000,1)).^.7;
theta=2.5;
phi=0.7;
x=r*cos(theta);
y=r*sin(theta);
z=r*sin(phi);
data=[data;[x y z]];

r=.2+7*abs(randn(1000,1)).^.7;
theta=4.7;
phi=.3;
x=r*cos(theta);
y=r*sin(theta);
z=r*sin(phi);
data=[data;[x y z]];


data=data+.6*randn(size(data));

%N is the number of synapses
N=size(data,1);
%M is the number of features
M=size(data,2);

figure(1);
clf;
scatter(data(:,1),data(:,2));

%%
%K is the number of points in our kohonen network
K=length(hue);

%calculate the min, max, range, standard deviation and mean
%of every feature
maxvals=max(data,1);
minvals=min(data,1);
range=maxvals-minvals;
stds=std(data,[],1);
means=mean(data,1);

%normalize the data, by subtracting the mean and dividing by the standard
%deviation of every feature
data=(data-repmat(means,N,1))./repmat(stds,N,1);

%start out with random positions for each member of the kohonen network
%in this normalized space.  Each row is a member of our network along the
%color wheel, each column is the value in the dimension of the feature space.
positions=randn(K,M);
positions(:,1)=2.5*cos(hue*2*pi);
positions(:,2)=2.5*sin(hue*2*pi);
positions(:,3)=2.5*zeros(1,length(positions));

%%
if (takemovie==1)
    aviobj=avifile('kohonen_small4.avi');
    aviobj.Quality=90;
    aviFile.Compression='MSVC';
    aviFile.KeyFramePerSec=15;
end
fn=0;

figure(1);
clf;
plot3(data(:,1), data(:,2), data(:,3));
pos=get(gca,'CameraPosition');
[az el] = view;
set(gca,'CameraViewAngleMode','manual');
set(gca,'CameraPosition',pos/5);
cameraangle=get(gca,'CameraViewAngle');






figure(1);
clf;
hold on;
h=plot3(data(:,1), data(:,2), data(:,3),'o');
ylim([-4 4]);
xlim([-4 4]);
zlim([-2 5]);
set(h,'MarkerSize',2);
%set(gca,'CameraPosition',pos/5);
set(gca,'CameraViewAngle',cameraangle);
set(h,'MarkerEdgeColor',[.5 .5 .5]);
for t=1:180
    view([az+2*fn el])
    fn=fn+1;
    
    drawnow
    pause(.1);
   
    if (takemovie==1)
        F=getframe(gcf);
        aviobj = addframe(aviobj,F);
    end
    
    
end


figure(1);
clf;
hold on;
h=plot3(data(:,1), data(:,2), data(:,3),'o');
ylim([-4 4]);
xlim([-4 4]);
zlim([-2 5]);
set(h,'MarkerSize',2);
%set(gca,'CameraPosition',pos/5);
set(gca,'CameraViewAngle',cameraangle);
set(h,'MarkerEdgeColor',[.5 .5 .5]);



plot3(positions(:,1),positions(:,2),positions(:,3),'k');
scatter3(positions(:,1),positions(:,2),positions(:,3),5*ones(size(hue')),hsv2rgb(hsv))
for t=1:180
    view([az+2*fn el])
    fn=fn+1;
    drawnow
    pause(.1);
   
    
    if (takemovie==1)
        F=getframe(gcf);
        aviobj = addframe(aviobj,F);
    end
end
%loop through time
T=5000;
counts=zeros(1,K);
t=0;
while (fn<4*180)
    t=t+1
    %have a factor which gets smaller and smaller over time
    eta=.3*exp(-t/(T/5))+1*exp(-t/(100));;
    
    %define the coefficents which will modulate the pull of all the other hues
    %when you pull on one.
    sig_hue=.0001+.2*exp(-t/(500));
    move_coeff=exp(-dhue.^2/(2*sig_hue.^2));
    
    %pull out a random index from all the synanpses
    randguy=ceil(N*rand(1));
    
    %calculate the differential vector from our random guy
    %to each of the members of the kohonen network
    deltv_inspace=repmat(data(randguy,:),K,1)-positions;
    
    %calculate the absolute euclidean distance
    distances_inspace=sqrt(sum(deltv_inspace.^2,2));
    
    %find out the minimum distance amongst the members of the kohonen
    %network and which member is the minimum
    [mindist,minguy]=min(distances_inspace);
    
    %calculate the delta vector that we want to move each of the members
    %of the kohonen network.  It should be in the direction of the
    %difference between each member and the random point
    %but modulated in strength by eta, and the movement coefficents
    %which will drag the guy closest and the guys near the closest guy
    %(near in terms of the color hue space) farther than those "far" away
    %(again.. far in terms of the color hue space).
    positions=positions+eta*repmat(move_coeff(:,minguy),1,M).*deltv_inspace;
    
    counts(minguy)=counts(minguy)+1;
    %plot out the positions every 100th time step
    if (((mod(t,10)==1)&&(t<500))||(t<80)||((mod(t,100)==1)))
     
        figure(1);
        clf;
        hold on;
        h=plot3(data(:,1), data(:,2), data(:,3),'o');
        ylim([-4 4]);
        xlim([-4 4]);
        zlim([-2 5]);
        set(h,'MarkerSize',2);
        %set(gca,'CameraPosition',pos/5);
        set(gca,'CameraViewAngle',cameraangle);
        set(h,'MarkerEdgeColor',[.5 .5 .5]);
        
        view([az+2*fn el])
        fn=fn+1;
        plot3(positions(:,1),positions(:,2),positions(:,3),'k');
        scatter3(positions(:,1),positions(:,2),positions(:,3),5*ones(size(hue')),hsv2rgb(hsv))
        
        drawnow
        pause(.1);
        t
        if (takemovie==1)
            F=getframe(gcf);
            aviobj = addframe(aviobj,F);
        end
        if (t<80)
            view([az+2*fn el])
            fn=fn+1;
            drawnow;
            if (takemovie==1)
                F=getframe(gcf);
                aviobj = addframe(aviobj,F);
            end
            view([az+2*fn el])
            fn=fn+1;
            drawnow;
            if (takemovie==1)
                F=getframe(gcf);
                aviobj = addframe(aviobj,F);
        
            end
        end
    end
end
pause(1)




%%


% after we have the positions of the synapse we want to go through the
% entire list of synapses, find the kohonen network guy closest
% and then give him the hue value of that closest guy

data_hue=zeros(N,1);
for i=1:N
    
    if mod(i,10000)==1
        
        disp(i*1.0/N);
        
        disp(i);
    end
    
    delt=repmat(data(i,:),K,1)-positions;
    dist=sum(delt.^2,2);
    [mindist,minguy]=min(dist);
    data_hue(i)=hue(minguy);
    
    
    
end
%
%
% %%
%we want constant saturation and value for our HSV values
data_hsv=[data_hue ones(size(data_hue)) ones(size(data_hue))];

%convert this to RGB values from 0 to 255
data_rgb=floor(256*hsv2rgb(data_hsv));


figure(1);
clf;
hold on;
h=scatter3(data(:,1),data(:,2),data(:,3),5*ones(1,size(data,1)),data_rgb/256.0);
ylim([-4 4]);
xlim([-4 4]);
zlim([-2 5]);
%set(h,'MarkerSize',2);
set(gca,'CameraPosition',pos/5);
set(gca,'CameraViewAngle',cameraangle);

plot3(positions(:,1),positions(:,2),positions(:,3),'k');
scatter3(positions(:,1),positions(:,2),positions(:,3),5*ones(size(hue')),hsv2rgb(hsv))

for t=1:180
    view([az+2*fn el])
    fn=fn+1;
    drawnow;
    if (takemovie==1)
    F=getframe(gcf);
    aviobj = addframe(aviobj,F);
    end
end
if (takemovie==1)
    aviobj=close(aviobj);
end
% %save this as a txt file
% fid=fopen('synapsinR_7thA.tif.Pivots.kohonen_rgb4.txt','w');
% fprintf(fid,'%d,%d,%d\n',data_rgb');
% fclose(fid);
%
%
% %%
%
% figure(5);
% clf;
% for i=1:4
%    subplot(2,2,i)
%    imagesc(positions(:,1+i-1:4:end));
%   caxis([-2 5]);
% end
%
%
% %%
% pivots=load('synapsinR_7thA.tif.Pivots.txt');
% data_minguy=round(data_hue*500);
% data_minguy=data_minguy+1;
%
% numbins=100;
% densities=zeros(K,numbins);
%
% for i=1:K
%    goodones=find(data_minguy==i);
%    N=hist(pivots(goodones,2),numbins);
%    densities(i,:)=N;
%
% end
%
%
% figure(8);
% clf;
% imagesc(densities);
%
% figure(9);
% clf;
% scatter(zeros(1,K),-(1:K),10,hsv2rgb(hsv));
% axis tight;
%
% densities_norm=densities./repmat(sum(densities,2),1,numbins);
% figure(10);
% clf;
% imagesc(densities_norm);
%
% figure(11);
% clf;
% hist(data_minguy,500);
% axis tight;
%
%
%
%
%
