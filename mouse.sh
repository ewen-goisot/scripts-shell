#!/bin/bash

# doit être lancé dans i3wm: exec "./chemin/vers/ça move left" sert à déplacer la fenêtre à gauche (comme en temps normal dans i3) et faire que la souris adapte sa position.
# la position de la souris est mémorisée pour chaque fenêtre dans laquelle le script a été lancé au moins une fois
# par défaut elle est placée au milieu des fenêtres (en l'absence d'informations)
# la position est relative: prends en compte la taille et la position de la fenêtre (si la souris est à 20 pixels du haut et que l'on réduit la fenêtre de moitié verticalement, elle sera alors à environ 10 pixels du haut)
# TODO: ne fonctionne pas parfaitement quand une touche est maintenue (garder appuyé pour redimentionner) mais cet usage est rare… fonctionne pour plusieurs appuis, consécutifs ou non.
# mémorise l'ancienne position de l'ancienne fenêtre
unset i xm ym xp yp x y w h
eval $(echo "i=$(xdotool getwindowfocus)")
eval $(xwininfo -id $i |
	sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
	-e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
	-e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
	-e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )
eval $(xdotool getmouselocation |
	sed -n -e "s/.*x:\([0-9]*\).*/xm=\1/p" )
eval $(xdotool getmouselocation |
	sed -n -e "s/.*y:\([0-9]*\).*/ym=\1/p" )
xp=$(( 1000*($xm-$x)/$w ))
yp=$(( 1000*($ym-$y)/$h ))
if [[ $(cat /tmp/flist | grep "$i") =~ "$i" ]];
then
	sed -i "s/^$i .*/$i $xp $yp/" /tmp/flist
else
	echo "$i $xp $yp" >> /tmp/flist
fi

# se déplace
i3-msg "$1 $2 $3 $4 $5 $6 $7 $8 $9"

# mets le pointeur de la souris à la même position que la dernière fois
# prenant en compte le déplacement ou resize de la fenêtre
unset i x y xp yp w h ith oth
eval $(echo "i=$(xdotool getwindowfocus)")
eval $(xwininfo -id $i |
	sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
	-e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
	-e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
	-e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )
read ith xp yp<<<$(cat /tmp/flist | grep "$i .*")
if [[ $(cat /tmp/flist | grep "$i") =~ "$i" ]];
then
	# éviter de sortir le pointeur de la fenêtre
	if [[ $xp -ge 0 && $xp -le 1000 && $yp -ge 0 && $yp -le 1000 ]];
	then
		# ajouter "1" pour éviter un décallage sur le long terme
		# ajouter ici des conditions dépendant du logiciel pour la sauvegarde
		#xdotool mousemove $(echo "$(expr 1 + $x + $w \* $xp / 1000) $(expr 1 + $y + $h \* $yp / 1000)")
		xdotool mousemove $(( 1+$x+$w*$xp/1000 )) $(( 1+$y+$h*$yp/1000  ))
	else
		# ajouter ici des conditions dépendant du logiciel pour le dépassement du cadre
		xdotool mousemove $(echo "$(expr $x + $w / 2) $(expr $y + $h / 2)")
	fi
else
	# ajouter ici des conditions dépendant du logiciel pour l'initialisation
	xdotool mousemove $(echo "$(expr $x + $w / 2) $(expr $y + $h / 2)")
fi
