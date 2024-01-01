ylimvec = [0 max(ytickvec)];
figure;
ax1 = axes;
ax1.Units = 'inches';
ax1.Position = axPos1;
for i = 1:1:length(tableTypes)
    table = tableTypes{i};
    eval(['plot( table.MTOW_lbs_,table.' yval '*scale,''.'',''MarkerSize'',ms)']);
    hold on;
end
xlabel('MTOW (lbs)')
ylabel(yval_label)
grid on;
set(gcf,'Color','w')
legend( legendStr  ,'Location',legendLoc) 
yticks(ytickvec)
ylim(ylimvec)

ax2 = axes;
ax2.Units = 'inches';
ax2.Position = axPos2;
X = [];
g = [];
for i = 1:1:length(tableTypes)
    table = tableTypes{i};    
    eval(['X = [X; table.' yval '*scale];']);
    g = [g; table.Type];
    hold on;
end
violins = violinplot(X,g,'EdgeColor',[0.1 0.1 0.1]);
grid on;
xlabel('UAS Type')
ylabel(yval_label)
yticks(ytickvec)
ylim(ylimvec)
set(gcf,'Color','w')
set(gcf,'Units','inches')
set(gcf,'Position',figPosSize)
set(gcf,'Color','w')
set(gca,'ColorOrder',color_dist)

ax3 = axes;
ax3.Units = 'inches';
ax3.Position = axPos3;
X = [];
g = [];
for i = 1:1:length(tableGroups)
    table = tableGroups{i};
    eval(['X = [X; table.' yval '*scale];']);
    g = [g; ones(size(table,1),1)*i];
    hold on;
end
violins = violinplot(X,g,'ViolinColor',[1 0 0 ; 0.1 0.1 0.1; 0 0 1],'EdgeColor',[0.1 0.1 0.1]);
grid on;
xlabel('UAS Group')
ylabel(yval_label)
yticks(ytickvec)
ylim(ylimvec)
set(gcf,'Color','w')
set(gcf,'Units','inches')
set(gcf,'Position',figPosSize)
set(gcf,'PaperSize',figPaperSize, 'Units', 'inches');