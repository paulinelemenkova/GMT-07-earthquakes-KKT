#!/bin/sh
# Purpose: Map of earthquakes and seismicity (here: Mariana Trench).
# Lambert conic conformal prj.
# GMT modules: makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, psxy, pslegend, pstext, logo
# Step-1. Generate a file
ps=GMT_JL_geol_MT.ps
# Step-2. Color palette table
gmt makecpt -Cred,green,blue -T0,70,300,10000 > quakes.cpt
# Step-3. Cut off the relief map from ETOPO5
gmt grdcut earth_relief_05m.grd -R120/160/0/30 -Gmt_relief.nc -V
gmt grdinfo @mt_relief.nc
# Step-4. Add coastlines; color areas: land-green water-blue
gmt pscoast -R120/160/0/30 -JL140/15/10/20/6i -P \
--FORMAT_GEO_MAP=dddF \
--MAP_FRAME_PEN=dimgray \
--MAP_FRAME_WIDTH=0.08c \
--MAP_TICK_PEN_PRIMARY=thinner,dimgray \
--MAP_GRID_PEN_PRIMARY=0.1p \
--MAP_ANNOT_OFFSET_PRIMARY=0.1c \
--MAP_TITLE_OFFSET=1c \
--FONT_TITLE=12p,Palatino-Roman,black \
--FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
--FONT_ANNOT_SECONDARY=8p,Times-Roman \
--FONT_LABEL=7p,Helvetica,black \
-B+t"Geological settings in the Mariana Trench area" \
-Bxg4f2a5 -Byg4f2a5 -W0.1p -Gdarkseagreen1 -Slightcyan -Df -K > $ps
# Step-5. Add elemens of basemap: rose, scale, time stamp
gmt psbasemap -R -J \
--FONT=7p,Palatino-Roman,dimgray \
--MAP_ANNOT_OFFSET=0.1c \
-Tdg124/27+w0.5c+f2+l \
-Lx5.1i/-0.5i+c50+w1000k+l"Lambert conic conformal projection. Scale at 15\232N, km"+f \
-O -K >> $ps
# Step-6. Add bathymetric contours
gmt grdcontour @mt_relief.nc -R -J -C1000 -A2000+f6p,Times-Roman -S4 -T+d15p/3p \
--MAP_GRID_PEN_PRIMARY=thinnest \
-O -K >> $ps
# Step-4. Add geological lines and points
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,red -Gred -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,purple -Gpurple -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gp7+bred+f-+r300 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,orange -Gorange -O -K >> $ps
# Step-8. Add legend
gmt pslegend -R -J -Dx0.0/-2.6+w5.5c+o0.0/0.2c -F+pthin+ithinner+gwhite \
--FONT_ANNOT_PRIMARY=8p -O -K << EOF >> $ps
S 0.3c f+l+t 0.7c red 0.15p 1.0c Trench
S 0.3c f+l+t 0.7c purple 0.15p 1.0c Ridge
S 0.3c f+l+t 0.7c orange 0.15p 1.0c Transform lines
S 0.3c c 0.2c magenta 0.15p 1.0c Ophiolites
S 0.3c r 0.5c p7+bred+f+r300- 0.15p 1.0c Large igneous provinces (LIPs)
EOF
# Step-9. Add text
gmt pstext -R0/10/0/10 -Jx1i -X2.7c -Y-1.7c -N -O -K \
-F+f7p,Palatino-Roman,dimgray+jCB >> $ps << END
4.0 0.0 Standard paralles at 10\232 and 20\232 N
END
# Step-10. Add GMT logo
gmt logo -R0/10/0/10 -Jx1i -Dx4.0/0.0c+o0.0c/0.0c+w2c -O -K >> $ps
# Step-11. Add subtitle
gmt pstext -R0/10/0/10 -Jx1i -X-2.7c -Y1.2c -N -O \
-F+f10p,Palatino-Roman,black+jCB >> $ps << EOF
3.0 5.0 Bathymetric contour: ETOPO 5 arc min Global Relief Model
EOF
