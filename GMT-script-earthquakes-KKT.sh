#!/bin/sh
# Purpose: Map of earthquakes and seismicity (here: Kuril-Kamchatka Trench)
# GMT modules: makecpt, grdcut, pscoast, grdcontour, psxy, pslegend, logo
# Step-1. Color palette table
gmt makecpt -Cred,green,blue -T0,70,300,10000 > quakes.cpt
# Step-2. Cut off the relief map from ETOPO5
gmt grdcut earth_relief_05m.grd -R140/170/40/60 -Gkkt_relief.nc -V
# Step-3. Add coastlines
gmt pscoast -R140/170/40/60 -JB155/50/45/55/6i -P -Gdarkseagreen1 -V \
	-Lx5.0i/-0.5i+c50+w1000k+l'Conic equal-area Albers projection. Scale at 50\232N (km)'+f -W0.1p -Slightcyan -Df \
    -Tdg142/58+w1.5c+l \
	-B+t"Seismicity and magnitude of the earthquakes in the Kuril-Kamchatka area" -Bxa5g5f1 -Bya5g5f1 \
    --FORMAT_GEO_MAP=dddF \
    --MAP_FRAME_PEN=dimgray \
    --MAP_FRAME_WIDTH=0.08c \
    --MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    --MAP_GRID_PEN_PRIMARY=0.5p \
    --FONT_TITLE=12p,Palatino-Roman,black \
	--FONT_ANNOT_PRIMARY=8p,Times-Roman \
    --FONT_ANNOT_SECONDARY=8p,Times-Roman \
	--FONT_LABEL=8p,Times-Roman \
    -K > GMT_earthq_KKT.ps
# Step-4. Add bathymetric contours
gmt grdcontour @kkt_relief.nc -R140/170/40/60 -JB155/50/45/55/6.0i -C500 -A1000+f7p,Times-Roman -S4 -T+d15p/3p \
    --MAP_GRID_PEN_PRIMARY=thinnest \
    -P -O -K >> GMT_earthq_KKT.ps
# Step-5. Add earthquake points
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> GMT_earthq_KKT.ps
# Step-6. Add legend
gmt pslegend -R -J -Dx0.0/-2.8+w2.2i+o0/0.4i -F+pthick+ithinner+gwhite --FONT_ANNOT_PRIMARY=8p -O -K << EOF >> GMT_earthq_KKT.ps
S 0.1i c 0.1i red 0.25p 0.2i Shallow depth (0-100 km)
S 0.1i c 0.1i green 0.25p 0.2i Intermediate depth (100-300 km) 
S 0.1i c 0.1i blue 0.25p 0.2i Very deep (> 300 km)
EOF
# Step-7. Add GMT logo
gmt logo -R -J -O -Dx6.5/-2.2+o0.1i/0.1i+w2c  >> GMT_earthq_KKT.ps
