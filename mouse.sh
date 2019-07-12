#!/bin/zsh

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
