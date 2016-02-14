subfeat=csvread('ConstructedSubsetPivots.txt.Features.txt');
allfeat=csvread('ConstructedAllFeatures.txt');
allpiv=csvread('synapsinR_7thA.tif.Pivots.txt');
chanvglut1=csvread('chanVGluT1.classFile');
chanvglut2=csvread('chanVGluT2.classFile');
chanvglut3=csvread('chanVGluT3.classFile');
chanpsd=csvread('chanPSD.classFile');
changad=csvread('chanGAD.classFile');
chanvgat=csvread('chanVGAT.classFile');
chanvacht=csvread('chanVAchT.classFile');
chanth=csvread('chanTH.classFile');
chanpv=csvread('chanPV.classFile');

%matlabpool 5
for i=1:9
    i
    if i==1
        vglut1=classifysynapses(chanvglut1,2,subfeat(chanvglut1(:,1)+1,:),allfeat);
    end
    if i==2
        vglut2=classifysynapses(chanvglut2,2,subfeat(chanvglut2(:,1)+1,:),allfeat);
    end
    if i==3
        vglut3=classifysynapses(chanvglut3,2,subfeat(chanvglut3(:,1)+1,:),allfeat);
    end
    if i==4
        gad=classifysynapses(changad,2,subfeat(changad(:,1)+1,:),allfeat);
    end
    if i==5
        psd=classifysynapses(chanpsd,2,subfeat(chanpsd(:,1)+1,:),allfeat);
    end
    if i==6
        vgat=classifysynapses(chanvgat,2,subfeat(chanvgat(:,1)+1,:),allfeat);
    end
    if i==7
        pv=classifysynapses(chanpv,2,subfeat(chanpv(:,1)+1,:),allfeat);
    end
    if i==8
        th=classifysynapses(chanth,2,subfeat(chanth(:,1)+1,:),allfeat);
    end
    if i==9
        vacht=classifysynapses(chanvacht,2,subfeat(chanvacht(:,1)+1,:),allfeat);
    end
end
allscores=[gad.posteriors,vgat.posteriors,pv.posteriors,vglut3.posteriors,vglut2.posteriors,vglut1.posteriors,psd.posteriors,vacht.posteriors,th.posteriors];
allclasses=[gad.predictions,vgat.predictions,pv.predictions,vglut3.predictions,vglut2.predictions,vglut1.predictions,psd.predictions,vacht.predictions,th.predictions];
allscores(:,10)=rand(size(allscores,1),1);

%feature importance stuff - example, psd95
gadfeat=zeros(1,96);
vgatfeat=zeros(1,96);
pvfeat=zeros(1,96);
vglut1feat=zeros(1,96);
vglut2feat=zeros(1,96);
vglut3feat=zeros(1,96);
psdfeat=zeros(1,96);
vachtfeat=zeros(1,96);
thfeat=zeros(1,96);
for i=1:200
    gadfeat = gadfeat + varimportance(gad.classifier.Trees{i});
    vgatfeat = vgatfeat + varimportance(vgat.classifier.Trees{i});
    pvfeat = pvfeat + varimportance(pv.classifier.Trees{i});
    vglut1feat = vglut1feat + varimportance(vglut1.classifier.Trees{i});
    vglut2feat = vglut2feat + varimportance(vglut2.classifier.Trees{i});
    vglut3feat = vglut3feat + varimportance(vglut3.classifier.Trees{i});
    psdfeat = psdfeat + varimportance(psd.classifier.Trees{i});
    vachtfeat = vachtfeat + varimportance(vacht.classifier.Trees{i});
    thfeat = thfeat + varimportance(th.classifier.Trees{i});
end
%figure;bar(psdfeat+vglut1feat)
vert=7; horiz=1;
subplot(vert,horiz,1), bar(psdfeat+vglut1feat)
subplot(vert,horiz,2), bar(psdfeat+vglut2feat)
subplot(vert,horiz,3), bar(vglut3feat)
subplot(vert,horiz,4), bar(gadfeat+vgatfeat)
subplot(vert,horiz,5), bar(pvfeat+gadfeat+vgatfeat)
subplot(vert,horiz,6), bar(vachtfeat)
subplot(vert,horiz,7), bar(thfeat)

%plot feature type importances for each class
allfeatimport=[pvfeat+gadfeat+vgatfeat+vachtfeat+thfeat+psdfeat+vglut1feat+vglut2feat+vglut3feat; gadfeat; vgatfeat; pvfeat; vglut3feat; vglut2feat; vglut1feat; psdfeat; vachtfeat; thfeat];
figure;vert=5; horiz=2;
for i=1:10
    subplot(vert,horiz,i), bar([sum(allfeatimport(i,2:4:end)) sum(allfeatimport(i,1:4:end)) sum(allfeatimport(i,3:4:end)) sum(allfeatimport(i,4:4:end))]./max([sum(allfeatimport(i,1:4:end)) sum(allfeatimport(i,2:4:end)) sum(allfeatimport(i,3:4:end)) sum(allfeatimport(i,4:4:end))]))
end

%oob error averaging
err=0;
for i=1:10
    i
    e=classifysynapses(chanvglut2,2,subfeat(chanvglut2(:,1)+1,:),allfeat);
    e=oobError(e.classifier);
    err=err+e(end)/10
end

figure;bar3(cov(allscores))
for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5);
        pt(i,j)=myBinomTest(numovrlp,sum(allscores(:,i)>0.5),sum(allscores(:,j)>0.5)/size(allscores,1),'Two');
    end
end
for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5);
        pg(i,j)=myBinomTest(numovrlp,sum(allscores(:,i)>0.5),sum(allscores(:,j)>0.5)/size(allscores,1),'Greater');
    end
end
for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5);
        pl(i,j)=myBinomTest(numovrlp,sum(allscores(:,i)>0.5),sum(allscores(:,j)>0.5)/size(allscores,1),'Lesser');
    end
end


for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5);
        expectedovrlp=sum(allscores(:,i)>0.5)/size(allscores,1) * sum(allscores(:,j)>0.5)/size(allscores,1) * size(allscores,1); %prob of i * prob of j * n pivots
        foundvsexpecteddiffoversum(i,j)=(numovrlp-expectedovrlp)/(numovrlp+expectedovrlp);
    end
end

%get heights of binom diagonal
for i=1:size(foundvsexpecteddiffoversum,1)
    fndvsexdiffsumdiag(i)=foundvsexpecteddiffoversum(i,i);
end

%heatmapped binom test figure
h=HeatMap(foundvsexpecteddiffoversum,'ColorMap','redbluecmap');

%normalize
foundvsexpecteddiffoversumnorm=foundvsexpecteddiffoversum;
for i=1:size(foundvsexpecteddiffoversum,1)
    for j=1:size(foundvsexpecteddiffoversum,2)
        %parres= foundvsexpecteddiffoversum(i,i)*foundvsexpecteddiffoversum(j,j);
        parres=2/(1/foundvsexpecteddiffoversum(i,i) + 1/foundvsexpecteddiffoversum(j,j)) ;%parallel resistance equiv
        foundvsexpecteddiffoversumnorm(i,j)=foundvsexpecteddiffoversum(i,j)/parres;
    end
end
h=HeatMap(foundvsexpecteddiffoversumnorm,'ColorMap','redbluecmap');

%stretch normalization so that above- and below-zero are the same range;
%normalise the normalization how retarded is that?
foundvsexpecteddiffoversumnormeq=foundvsexpecteddiffoversumnorm;
foundvsexpecteddiffoversumnormeq(foundvsexpecteddiffoversumnormeq > 0)=3*foundvsexpecteddiffoversumnormeq(foundvsexpecteddiffoversumnormeq > 0);
h=HeatMap(foundvsexpecteddiffoversumnormeq,'ColorMap','redbluecmap');

%colormapped binom test figure
figure;h=bar3(foundvsexpecteddiffoversum);
rotate3d

%giantass binomial signfiicance figure
figure;h=bar3(foundvsexpecteddiffoversum);
cm = get(gcf,'colormap');  % Use the current colormap.
cnt = 0;
for jj = 1:length(h)
    xd = get(h(jj),'xdata');
    yd = get(h(jj),'ydata');
    zd = get(h(jj),'zdata');
    delete(h(jj))    
    idx = [0;find(all(isnan(xd),2))];
    if jj == 1
        S = zeros(length(h)*(length(idx)-1),1);
        dv = floor(size(cm,1)/length(S));
    end
    for ii = 1:length(idx)-1
        cnt = cnt + 1;
        S(cnt) = surface(xd(idx(ii)+1:idx(ii+1)-1,:),...
                         yd(idx(ii)+1:idx(ii+1)-1,:),...
                         zd(idx(ii)+1:idx(ii+1)-1,:),...
                         'facecolor',cm((cnt-1)*dv+1,:));
    end
end
rotate3d
for i=1:length(S)
    p=min(1,20*pt(i));
    if p > 0.05
        set(S(i),'facecolor',[0 1-p p]);
    else
       if p > 0.01
           set(S(i),'facecolor',[1-20*p 1 0]);
       else
           set(S(i),'facecolor',[1 100*p 0]);
       end
    end
end

%correcting for slanting layers
%x2=x1
%y2=(y1*c + d)(1-x1/1400)+y1

%pt 1: 1056 300 (LI - LII/III boundary)
%1056=300c+d+300
%d=756-300c

%pt 2: 11449 11821 (wm striatum boundary)
%11449 = 11821c+d+11821
%-372 = 11821c + 756 - 300c
%-1128 = 11521c

c=-1128/11521; %derived from layer boundaries
d=756-300*c; %etc
allpivcor=allpiv;
for i=1:size(allpiv,1)
q=1-allpiv(i,1)/1400;
allpivcor(i,2)=(allpiv(i,2)-d*q)/(1+c*q);
end


%print a graph of dist along depth of cortex for gaba vs gaba-pv
figure; hold on;
bar(1:100:13000,hist(allpivcor(gad.predictions & vgat.predictions,2),1:100:13000),'b','BarWidth',1,'LineStyle','none')
bar(1:100:13000,hist(allpivcor(gad.predictions & vgat.predictions & pv.predictions,2),1:100:13000),'m','BarWidth',1,'LineStyle','none')


%subset of only striatal pivots
for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5 & allpiv(:,2)>11500);
        ptSt(i,j)=myBinomTest(numovrlp,sum(allscores(:,i)>0.5 & allpiv(:,2)>11500),sum(allscores(:,j)>0.5 & allpiv(:,2)>11500)/sum(allpiv(:,2)>11500,1),'Two');
    end
end
for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5 & allpiv(:,2)>11500);
        expectedovrlp=sum(allscores(:,i)>0.5 & allpiv(:,2)>11500)/sum(allpiv(:,2)>11500) * sum(allscores(:,j)>0.5 & allpiv(:,2)>11500)/sum(allpiv(:,2)>11500) * sum(allpiv(:,2)>11500); %prob of i * prob of j * n pivots
        foundvsexpecteddiffoversumSt(i,j)=(numovrlp-expectedovrlp)/(numovrlp+expectedovrlp);
    end
end

%generalizing, for all pivots with depth > y1 and < y2 pixels
y1=3000;
y2=4500;
for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5 & allpiv(:,2)>y1 & allpiv(:,2)<y2);
        ptL4(i,j)=myBinomTest(numovrlp,sum(allscores(:,i)>0.5 & allpiv(:,2)>y1 & allpiv(:,2)<y2),sum(allscores(:,j)>0.5 & allpiv(:,2)>y1 & allpiv(:,2)<y2)/sum(allpiv(:,2)>y1 & allpiv(:,2)<y2,1),'Two');
    end
end
for i=1:size(allscores,2)
    for j= 1:size(allscores,2)
        numovrlp=sum(allscores(:,i)>0.5 & allscores(:,j)>0.5 & allpiv(:,2)>y1 & allpiv(:,2)<y2);
        expectedovrlp=sum(allscores(:,i)>0.5 & allpiv(:,2)>y1 & allpiv(:,2)<y2)/sum(allpiv(:,2)>y1 & allpiv(:,2)<y2) * sum(allscores(:,j)>0.5 & allpiv(:,2)>y1 & allpiv(:,2)<y2)/sum(allpiv(:,2)>y1 & allpiv(:,2)<y2) * sum(allpiv(:,2)>y1 & allpiv(:,2)<y2); %prob of i * prob of j * n pivots
        foundvsexpecteddiffoversumL4(i,j)=(numovrlp-expectedovrlp)/(numovrlp+expectedovrlp);
    end
end

%depth of cortex figure, for everything
const=3920;%pixels per um3, for 10 um bins
maxdepth=13300;
figure;
%ybot = -.1; ytop = 0.9;
xbot=-99; xtop=maxdepth;
vert=7; horiz=1;
subplot(vert,horiz,1), bar(xbot:100:xtop,hist(allpivcor(vglut1.predictions & psd.predictions,2),xbot:100:xtop)/const,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]); 
subplot(vert,horiz,2), bar(xbot:100:xtop,hist(allpivcor(vglut2.predictions & psd.predictions,2),xbot:100:xtop)/const,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]); 
subplot(vert,horiz,3), bar(xbot:100:xtop,hist(allpivcor(vglut3.predictions,2),xbot:100:xtop)/const,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]); 
subplot(vert,horiz,4), bar(xbot:100:xtop,hist(allpivcor(vgat.predictions & gad.predictions,2),xbot:100:xtop)/const,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]); 
subplot(vert,horiz,5), bar(xbot:100:xtop,hist(allpivcor(vgat.predictions & gad.predictions & pv.predictions,2),xbot:100:xtop)/const,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]); 
subplot(vert,horiz,6), bar(xbot:100:xtop,hist(allpivcor(vacht.predictions ,2),xbot:100:xtop)/const,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]); 
subplot(vert,horiz,7), bar(xbot:100:xtop,hist(allpivcor(th.predictions,2),xbot:100:xtop)/const,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]); 

classes=[vglut1.predictions & psd.predictions,vglut2.predictions & psd.predictions,vglut3.predictions,vgat.predictions & gad.predictions,vgat.predictions & gad.predictions & pv.predictions,vacht.predictions,th.predictions];
%size distributions
figure; hold on;
vert=7; horiz=1;
for j=1:size(classes,2)    
    tmpv1mean=[];   
    for i=xbot:100:xtop       
        tmpv1mean(round(i/100)+2)=mean(allfeat(classes(:,j) & allpivcor(:,2)>i & allpivcor(:,2)<i+100,1));
    end
    tmpv1mean(isnan(tmpv1mean))=0;
    tmpmean=mean(tmpv1mean);
    tmpstd=std(tmpv1mean);
    axh=subplot(vert,horiz,j), bar(xbot:100:xtop,tmpv1mean,'b','BarWidth',1,'LineStyle','none');set(gca,'XLim', [xbot xtop]);
    %hold(axh,'on');
    %plot(axh,xbot:100:xtop,ones(size(tmpv1mean))*tmpmean+2*tmpstd,'b','LineStyle','--','Color',[1,0,0]);%set(gca,'XLim', [xbot xtop]);
end

%scatterplot of classified synapses
subset=vglut2.predictions & psd.predictions;
figure;scatter(allpiv(subset,1),14000-allpiv(subset,2),1)

%example ROC curve - vglut1 classifier (on psd95 data)
vglut1ROC=classifysynapses(chanvglut1,2,subfeat(chanvglut1(:,1)+1,:),subfeat(chanpsd(:,1)+1,:));
rocdata=rocBrd([vglut1ROC.posteriors, chanpsd(:,2)])


%ROC curves - vglut1 vs psd
vglut1ROC=classifysynapses(chanvglut1(1:100,:),2,subfeat(chanvglut1(1:100,1)+1,:),subfeat(chanvglut1(101:200,1)+1,:));
rocdata=rocBrd([vglut1ROC.posteriors, chanvglut1(101:200,2)])

%ROC curves - vglut1, psd, both (product) vs classified vg1 synapses
classVG1=csvread('VGluT1.classFile');
classpsdROC=classifysynapses(chanpsd,2,subfeat(chanpsd(:,1)+1,:),subfeat(classVG1(:,1)+1,:));
classvglut1ROC=classifysynapses(chanvglut1,2,subfeat(chanvglut1(:,1)+1,:),subfeat(classVG1(:,1)+1,:));
figure;rocvglut1data=rocBrd([classvglut1ROC.posteriors, classVG1(:,2)])
figure;rocPSDdata=rocBrd([classpsdROC.posteriors, classVG1(:,2)])
figure;rocBothdata=rocBrd([classpsdROC.posteriors .* classvglut1ROC.posteriors, classVG1(:,2)])
figure;hold on;
h=(line(rocBothdata.xr,rocBothdata.yr));set(h,'LineStyle','-','Color',[0,0,0],'Marker','.')
h=(line(rocvglut1data.xr,rocvglut1data.yr));set(h,'LineStyle','-','Color',[1,0,0],'Marker','.')
h=(line(rocPSDdata.xr,rocPSDdata.yr));set(h,'LineStyle','-','Color',[0,0,1],'Marker','.')


%human rating stuff (switch to human accuracy test dir)
synhumtestfeat=csvread('synapsinR_7thA.tif.SubsetPivots.txt.Features.txt');
synhumtestfeat(:,5:6:end)=[];
synhumtestfeat(:,5:5:end)=[];
vglut1HumTst=classifysynapses(chanvglut1(1:100,:),2,subfeat(chanvglut1(1:100,1)+1,:),synhumtestfeat);
psdHumTst=classifysynapses(chanpsd(1:100,:),2,subfeat(chanpsd(1:100,1)+1,:),synhumtestfeat);
humRaters=[csvread('brad.txt'),csvread('forrest.txt'),csvread('kristina.txt'),csvread('Nancy.txt'),csvread('Nick.txt'),csvread('rachel.txt')];
humClass=humRaters(:,2:2:end);
for h = 1:6
    gold=humClass;
    gold(:,h)=[]; %remove holdout rater
    %calculate confidence matrix
    tpr(h) = sum (humClass(:,h) & round(mean(gold'))');   
    fpr(h) = sum (humClass(:,h) & ~round(mean(gold'))');   
    fnr(h) = sum (~humClass(:,h) & round(mean(gold'))');   
    tnr(h) = sum (~humClass(:,h) & ~round(mean(gold'))');   
end
%human agreement histogram
figure;hist(sum(humClass(:,1:6),2),7)

%add machine
humClass(:,7)= vglut1HumTst.predictions(1:100) & psdHumTst.predictions(1:100);
gold=humClass;
h=7;
gold(:,h)=[];
tpr(h) = sum (humClass(:,h) & round(mean(gold(:,1:6)'))');
fpr(h) = sum (humClass(:,h) & ~round(mean(gold(:,1:6)'))');
fnr(h) = sum (~humClass(:,h) & round(mean(gold(:,1:6)'))');
tnr(h) = sum (~humClass(:,h) & ~round(mean(gold(:,1:6)'))');

%display
figure;bar(tpr+tnr)


%human test ROC curve
figure;rocvglut1data=rocBrd([vglut1HumTst.posteriors, round(mean(humClass(:,1:6)'))'])
figure;rocPSDdata=rocBrd([psdHumTst.posteriors, round(mean(humClass(:,1:6)'))'])
figure;rocBothdata=rocBrd([vglut1HumTst.posteriors .* psdHumTst.posteriors, round(mean(humClass(:,1:6)'))'])
figure;hold on;
h=(line(rocBothdata.xr,rocBothdata.yr));set(h,'LineStyle','-','Color',[0,0,0],'Marker','.')
h=(line(rocvglut1data.xr,rocvglut1data.yr));set(h,'LineStyle','-','Color',[1,0,0],'Marker','.')
h=(line(rocPSDdata.xr,rocPSDdata.yr));set(h,'LineStyle','-','Color',[0,0,1],'Marker','.')