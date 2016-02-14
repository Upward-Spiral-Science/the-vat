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

%load the data
data=load('synapsinR_7thA.tif.Pivots.txt.Features.txt');

data=data(:,[1 2 3 4 7 8 9 10 13 14 15 16 19 20 21 22 25 26 27 28 31 32 33 34 37 38 39 40 43 44 45 46 49 50 51 52 55 56 57 58 61 62 63 64 67 68 69 70 73 74 75 76 79 80 81 82 91 92 93 94]);
%N is the number of synapses
N=size(data,1);
%M is the number of features
M=size(data,2);
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
%%

%loop through time
T=50000;
counts=zeros(1,K);

for t=1:T
    
    %have a factor which gets smaller and smaller over time
    eta=.3*exp(-t/(T/5))+1*exp(-t/(100));;
    
    %define the coefficents which will modulate the pull of all the other hues
    %when you pull on one.
    sig_hue=.01*((T-t)/T)+.005+.2*exp(-t/(5000))+1*exp(-t/(100));
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
    if (mod(t,100)==1)
        
        figure(4);
        clf;
        bar(counts);
        
        figure(5);
        clf;
        for i=1:4
            subplot(2,2,i)
            imagesc(positions(:,1+i-1:4:end));
            caxis([-1 1]);
        end
        
        
    end
end
%%
%after we have the positions of the synapse we want to go through the
%entire list of synapses, find the kohonen network guy closest
%and then give him the hue value of that closest guy
N=length(data);
data_hue=zeros(N,1);
mindist=zeros(N,1);
minguy=zeros(N,1);
for i=1:N
    
    if mod(i,10000)==1
        
        disp(i*1.0/N);
        
        disp(i);
    end
    delt=repmat(data(i,:),K,1)-positions;
    dist=sum(delt.^2,2);
    [mindist(i),minguy(i)]=min(dist);
    data_hue(i)=hue(minguy(i));
end
%%
numbins=150;
dist_prob=zeros(K,numbins+1);
for i=1:K
    
    dist_prob(i,:)=histc(mindist(minguy==i),0:numbins);
    
    dist_prob(i,:)=dist_prob(i,:)./(repmat(sum(dist_prob(i,:),2),1,numbins+1));
    
    
end

%%
%we want constant saturation and value for our HSV values
data_hsv=[data_hue ones(size(data_hue)) ones(size(data_hue))];

%convert this to RGB values from 0 to 255
data_rgb=floor(256*hsv2rgb(data_hsv));

%save this as a txt file
fid=fopen('synapsinR_7thA.tif.Pivots.kohonen_rgb5.txt','w');
fprintf(fid,'%d,%d,%d\n',data_rgb');
fclose(fid);
%%

classes=zeros(size(data,1),4);
classes(:,1)=load('VGluT1Predictions.txt');
classes(:,2)=load('VGluT2Predictions.txt');
classes(:,3)=load('GabaPredictions.txt');
classes(:,4)=load('THPredictions.txt');




%%
pivots=load('synapsinR_7thA.tif.Pivots.txt');
data_minguy=round(data_hue*500);
data_minguy=data_minguy+1;

numbins=100;
densities=zeros(K,numbins);

for i=1:K
    goodones=find(data_minguy==i);
    N=hist(pivots(goodones,2),numbins);
    densities(i,:)=N;
    
end
densities_norm=densities./repmat(sum(densities,2),1,numbins);

%%

%%
borders=[399 411;
    390 400;
    22 30;
    145 154]
figure(11);
clf;
hold on;
for i=1:size(borders,1)
    goodones=find(and(data_minguy>borders(i,1),data_minguy<borders(i,2)));
    switch i
        case 1
            string='bx'
        case 2
            string = 'rx'
        case 3
            string='gx'
        case 4
            string ='kx';
        case 5
            string ='kx';
    end
            
            
            plot(phypos(goodones,1),-phypos(goodones,2),string);
    
    
end

%%
bottom=.15;
height=.75;
std_buff=.03;
numplots=2;
mini=.02;
std_width=(1-mini-std_buff*numplots-.005)/numplots;
std_total=std_width+std_buff;

figure(90);
set(gcf,'Position',[20 500 1024 768]);
clf;

SUBPLOT('position',[0 bottom mini height]);
scatter(zeros(1,K),-(1:K),10,hsv2rgb(hsv));
axis tight;
xlim([-.01 .01]);
axis off;

% Set the X-Tick locations so that every other month is labeled.
%Xt = 1:2:11;
%Xl = [1 12];
%set(gca,'XTick',Xt,'XLim',Xl);

% Add the months as tick labels.
labels = ['Synap ';
    'Synap ';
    'VGlut1';
    'VGlut1';
    'VGlut2';
    'Vglut3';
    'psd   ';
    'gad   ';
    'VGAT  ';
    'PV    ';
    'Gephyr';
    'GABAR1';
    'TH    ';
    'VACht ';
    'DAPI  '];

SUBPLOT('position',[mini+std_buff bottom std_width height]);
set(gca,'FontSize',16)
imagesc(positions(:,1:4:end));
caxis([-2 5]);
ylabel('Points on Circle');
%xlabel('Channels');
title('Localized Brightness');
%set(gca,'XTick',[1:14]);
%set(gca,'XTickLabel',{'syna','synaGP','vglut1-3', 'vglut1-8', 'vglut3-1','psd','gad','vgat','pv','gephy','GABARa1','TH','VAChT','DAPI'})
% Place the text labels
set(gca,'XTick',.5:1:size(labels,1),'Xlim',[0.5 size(labels,1)+.5]);
ax = axis; % Current axis limits
axis(axis); % Set the axis limit modes (e.g. XLimMode) to manual
Yl = ax(3:4); % Y-axis limits
t = text((.75:1:size(labels,1)),(K+5)*ones(1,size(labels,1)),labels);
set(t,'HorizontalAlignment','right','VerticalAlignment','top','Rotation',90,'FontSize',16);
set(gca,'XTickLabel','');
colormap gray;
for i=1:size(borders,1)
   
    line([0 16],[borders(i,1) borders(i,1)]);
    line([0 16],[borders(i,2) borders(i,2)]);
    
end


% SUBPLOT('position',[mini+std_buff+std_total bottom std_width height]);
% imagesc(positions(:,3:4:end));
% caxis([-2 5]);
% set(gca,'XTick',.5:1:size(labels,1),'Xlim',[0.5 size(labels,1)+.5]);
% %xlabel('Channels');
% title('Distance to COM');
% t = text((.75:1:size(labels,1)),(K+5)*ones(1,size(labels,1)),labels);
% set(t,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90);
% set(gca,'XTickLabel','');

SUBPLOT('position',[mini+std_buff+std_total bottom std_width height]);
set(gca,'FontSize',16)
imagesc(1:max(pivots(:,2)),1:501,densities_norm);
colormap gray;
set(gca,'YTick',[]);
xlabel('Percentage through volume in Y');
title('Normalized density of types');
for i=1:size(borders,1)
   
    h=line([0 max(pivots(:,2))],[borders(i,1) borders(i,1)]);
    h2=line([0 max(pivots(:,2))],[borders(i,2) borders(i,2)]);
  
end

% SUBPLOT('position',[mini+std_buff+3*std_total bottom std_width height]);
% N=hist(data_minguy,500);
% barh(N);
% axis tight;
% set(gca,'YTick',[]);
% xlabel('Frequency');
% title('Frequency of types');
%
% SUBPLOT('position',[mini+std_buff+4*std_total bottom std_width height]);
% imagesc(dist_prob);
% set(gca,'YTick',[]);
% xlabel('Distance (standard deviations^2)');
% title('Distribution of distances to circle');


%%





