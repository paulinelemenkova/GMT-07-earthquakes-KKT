#!/bin/sh
# Purpose: Map of earthquakes and seismicity (here: Kuril-Kamchatka Trench).
# Lambert conic conformal prj.
# GMT modules: makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, psxy, pslegend, logo
# Step-1. Generate a file
ps=GMT_JL_earthq_KKT.ps
# Step-2. Color palette table
gmt makecpt -Cred,green,blue -T0,70,300,10000 > quakes.cpt
# Step-3. Cut off the relief map from ETOPO5
gmt grdcut earth_relief_05m.grd -R140/170/40/60 -Gkkt_relief.nc -V
gmt grdinfo @kkt_relief.nc
# Step-4. Add coastlines; color areas: land-green water-blue
gmt pscoast -R140/170/40/60 -JL155/50/45/55/6i -P \
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
    -B+t"Seismicity and magnitude of the earthquakes in the Kuril-Kamchatka area" \
    -Bxg4f2a5 -Byg2f1a2 -W0.1p -Gdarkseagreen1 -Slightcyan -Df -K > $ps
# Step-5. Add elemens of basemap: rose, scale, time stamp
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,dimgray \
    --MAP_ANNOT_OFFSET=0.1c \
    -Tdg144/57.5+w0.5c+f2+l \
    -Lx5.1i/-0.5i+c50+w1000k+l"Lambert conic conformal projection. Scale at 50\232N, km"+f \
    -UBL/-27p/-60p -O -K >> $ps
# Step-6. Add bathymetric contours
gmt grdcontour @kkt_relief.nc -R -J -C500 -A1000+f7p,Times-Roman -S4 -T+d15p/3p \
    --MAP_GRID_PEN_PRIMARY=thinnest \
    -O -K >> $ps
# Step-7. Add earthquake points
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps
# Step-8. Add legend
gmt pslegend -R -J -Dx0.0/-2.6+w2.1i+o-1.0/1.0c -F+pthick+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << EOF >> $ps
S 0.1i c 0.1i red 0.25p 0.2i Shallow depth (0-100 km)
S 0.1i c 0.1i green 0.25p 0.2i Intermediate depth (100-300 km) 
S 0.1i c 0.1i blue 0.25p 0.2i Very deep (> 300 km)
EOF
# Step-9. Add text
gmt pstext -R0/10/0/10 -Jx1i -X2.0c -Y-1.7c -N -O -K \
    -F+f7p,Palatino-Roman,dimgray+jCB >> $ps << END
4.0 0.0 Standard paralles at 45\232 and 55\232 N
END
# Step-10. Add GMT logo
gmt logo -R0/10/0/10 -Jx1i -Dx5.0/0.0c+o0.0c/0.0c+w2c -O -K >> $ps
# Step-11. Add subtitle
gmt pstext -R0/10/0/10 -Jx1i -X5.5c -Y6.0c -N -O \
-F+f10p,Palatino-Roman,black+jCB >> $ps << EOF
0.0 4.0 Bathymetry: ETOPO 5 arc min Global Relief Model
EOF
