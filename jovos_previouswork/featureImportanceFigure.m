figure;
ybot = -.1; ytop = 0.9;
xbot=0.5; xtop=1.5;
vert=4; horiz=4;


subplot(vert,horiz,1), bar([mean(featvalcrop(1:4,:)); zeros(1,6)]);    set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','Synapsin'); shading flat
subplot(vert,horiz,2), bar([mean(featvalcrop(9:12,:)); zeros(1,6)]);   set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','VGluT1'); shading flat
subplot(vert,horiz,3), bar([mean(featvalcrop(13:16,:)); zeros(1,6)]);  set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','VGluT1'); shading flat
subplot(vert,horiz,5), bar([mean(featvalcrop(17:20,:)); zeros(1,6)]);  set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','VGluT2'); shading flat
subplot(vert,horiz,6), bar([mean(featvalcrop(21:24,:)); zeros(1,6)]);  set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','VGluT3'); shading flat
subplot(vert,horiz,7), bar([mean(featvalcrop(25:28,:)); zeros(1,6)]);  set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','PSD95'); shading flat
subplot(vert,horiz,9), bar([mean(featvalcrop(29:32,:)); zeros(1,6)]);  set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','GAD'); shading flat
subplot(vert,horiz,10), bar([mean(featvalcrop(33:36,:)); zeros(1,6)]); set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','VGAT'); shading flat
subplot(vert,horiz,11), bar([mean(featvalcrop(37:40,:)); zeros(1,6)]); set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','PV'); shading flat
subplot(vert,horiz,12), bar([mean(featvalcrop(41:44,:)); zeros(1,6)]); set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','Gephyrin'); shading flat
subplot(vert,horiz,13), bar([mean(featvalcrop(45:48,:)); zeros(1,6)]); set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','GABAaR1'); shading flat
subplot(vert,horiz,14), bar([mean(featvalcrop(49:52,:)); zeros(1,6)]); set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','TH'); shading flat
subplot(vert,horiz,15), bar([mean(featvalcrop(53:56,:)); zeros(1,6)]); set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','VAchT'); shading flat
subplot(vert,horiz,16), bar([mean(featvalcrop(57:60,:)); zeros(1,6)]); set(gca,'YLim',[ybot ytop], 'XLim', [xbot xtop],'XTickLabel','DAPI'); shading flat
legend('vlgut1','vglut2','vglut3','gaba','vacht','th')



%misc stuff
%kmntst=kmeans(constructedFeat(:,[18]),2);kmntst2=kmntst(vglut2Class(:,1)+1);confusionmat(kmntst2,vglut2Class(:,2)+1)

%dataVglut1=channelerrorplot(constructedFeat(vglut1Class(:,1)+1,:),4,channelnames,vglut1Class(:,2),{'VGluT1'});
%dataVglut2=channelerrorplot(constructedFeat(vglut2Class(:,1)+1,:),4,channelnames,vglut2Class(:,2),{'VGluT2'});
%dataVglut3=channelerrorplot(constructedFeat(vglut3Class(:,1)+1,:),4,channelnames,vglut3Class(:,2),{'VGluT3'});
%dataGABA=channelerrorplot(constructedFeat(gabaClass(:,1)+1,:),4,channelnames,gabaClass(:,2),{'GABA'});
%dataGnPV=channelerrorplot(constructedFeat(gadnoPVClass(:,1)+1,:),4,channelnames,gadnoPVClass(:,2),{'GADnotPV'});
%dataGadCB1=channelerrorplot(constructedFeat(gadCB1Class(:,1)+1,:),4,channelnames,gadCB1Class(:,2),{'GAD-CB1'});
%dataTH=channelerrorplot(constructedFeat(THClass(:,1)+1,:),4,channelnames,THClass(:,2),{'TH'});