#!/bin/bash
# fonctionne sur GNU/Linux (testé), fonctionne probablement sur OS X (non testé)
# si vous constatez une erreur ou voulez suggerer une modification, contactez moi à ewengoisot@laposte.net

# installez youtube-dl (paquet)
# créez un fichier nommé "url" dans le même répertoire que ce script
# lancez le script (cd repertoire; ./nomduscript)

# par defaut, option --no-playlist (pour notamment eviter de telecharger plusieurs fois la meme video)
# mettez un + devant votre url pour activer l'option --yes-playlist
# mettez un # devant votre url pour ne rien en faire

# options par défaut (vous pouvez les changer avec -o/O/i/f/n ou en modifiant le script)
thisthis=$0
initial=$(pwd)
dossier=$(pwd)
nom="url.txt"
format="mp3"
actualise=""
silence="&1"
silence_erreur="&2"
nom_audio="-o fichier_audio"
num_audio="001"
univ=""
univ_video=""
univ_playlist=""

# -h affiche un message d'aide.
aide () {
	echo "(L'affichage de l'aide désactive les éventuels téléchargements demandés ici.)



Aide:

Permet d'enregistrer les audios (musiques, audiobooks, ...) de vidéos youtube grâce à youtube-dl sans jamais télécharger la partie vidéo.
Vous n'a pas besoin de \"faire télécharger la vidéo à un autre site\" tels que font la plupart des sites de téléchargement en ligne. 
Veuillez vous assurer que vous avez déjà téléchargé youtube-dl avant d'utiliser ce script.
Prends les URLs (de vidéos YouTube) de votre fichier $nom, et télécharge les audios .mp3 corespondants.

Options:
	-h : affiche cette aide.
	-o : spécifie le répertoire dans lequel seront enregistrés les audios.
	-O : comme -o, mais crée le répertoire s'il n'existe pas, au lieu de retourner un message d'erreur.
	-i : spécifie le répertoire où se trouve la liste d'URLs.
	-n : permet de choisir un autre nom que $nom pour le fichier contenant les URLs.
	-f : permet de choisir un format éventuellement autre que .mp3 .
	-k : active l'actualisation: les URLs seront envoyées vers un fichier $nom.old.
	-s : silencieux: n'affiche que les messages d'erreurs de youtube-dl, masque les autres.
	-S : silencieux+: n'affiche ni les messages standards ni les messages d'erreurs de youtube-dl.
	-u : rajoute n'importe quelle option de youtube-dl à chaque téléchargement
	-uv : universel pour les vidéos seules uniquement
	-up : universel pour les playlist uniquement
	TODO:
	-c : nomme les fichiers 001 002 003...
	-c1 : comme -c, préciser le premier indice.
	-cn : nomme les fichiers $nom_audio\_001 $nom_audio\_002 ...
	-cn1 : -cn et -c1, précisez d'abord l'indice

Futures options:
	TODO : (t) sous-titres
	TODO : moifications légères de l'aide selon les options précédemment sélectionnées (partiellement fait)

Dans le fichier $nom:
si le premier caractère d'une ligne est,
	(pas de caractère special) : enregistre la vidéo seule (option --no-playlist dans youtube-dl).
	! : garde le format par défaut (webm)
	+ : télécharge la playlist correspondante lorsque cela a un sens, la vidéo seule sinon (option --yes-playlist)
	!+ : playlist, garde le format webm
	# : ne tient pas compte de cette ligne (la traite comme un commentaire)


Exemples d'utilisation:
----> basique:
	$thisthis
----> aide:
	$thisthis -h
----> enregistrer les audios dans \"Musiques\"
	$thisthis -o ~/Musiques
----> complet (depuis ~/Documents/$nom vers ~/Musiques/ma_playlist_5 au format audio aac et actualiser) :
	$thisthis https://www.youtube.com/watch?v=V2vSq0YoWjA.sh -O ~/Musiques/ma_playlist_5 -k -i ~/Documents -n $nom -f aac -s
----> si ces options ne vous suffisent pas:
	Utilisez directement youtube-dl ou un équivalent, ou faites votre propre script.

"
}
#	-o : spécifie le répertoire dans lequel seront enregistrés les audios.
output () {
	cd $1 ||  
    {
    	echo "ERREUR: -o necessite un chemin vers un dossier existant"
    	exit 1
    }
    echo "-o : les audios seront enregistres dans le dossier $1"
}
#	-O : comme -o, mais crée le répertoire s'il n'existe pas, au lieu de retourner un message d'erreur.
output_force () {
	cd $1 ||
	{
		mkdir $1 ||
		{
			echo "ERREUR: -O le dossier $1 n'existe pas ET n'a pas pu être créé. Assurez vous de disposer des privilèges nécessaires pour le créer, vérifiez la syntaxe, ou choisissez un autre chemin."
			exit 1
		}
	}
}
#	-i : spécifie le répertoire où se trouve la liste d'URLs.
input () {
	echo "-i : la liste d'URLs est située dans le dossier $1"
	dossier=$1
}
#	-n : permet de choisir un autre nom que \"url\" pour le fichier contenant les URLs.
name_input () {
	echo "-n : la liste d'URLs est située dans le fichier $1"
	nom=$1
}
#	-f : permet de choisir un format éventuellement autre que .mp3 .
format () {
	echo "-f : format choisi: $1"
	format=$1
}
#	-k : active l'actualisation: les URLs seront envoyées vers un fichier *.old.
actualise () {
	echo "les URLs seront transférées vers un fichier *.old"
	actualise="methode_1"
}
silence () {
	echo "les messages de youtube-dl ne seront pas affichés, SAUF en cas d'erreur"
	echo "utilisez l'option -S pour masquer aussi les messages d'erreurs"
	silence="/dev/null"
}
silence_tout () {
	echo "les messages et messages d'erreurs de youtube-dl ne seront pas affichés"
	echo "utilisez l'option -s pour masquer seulement les messages standards"
	silence="/dev/null"
	silence_erreur="/dev/null"
}
universel () {
	echo "tous les telechargements sont affectes par l'option $1"
	univ="$1"
}
universel () {
	echo "tous les telechargements de VIDEOS SEULES sont affectes par l'option $1"
	univ_video="$1"
}
universel () {
	echo "tous les telechargements de PLAYLISTS sont affectes par l'option $1"
	univ_playlist="$1"
}

# lecture des options sélectionées
# vous avez le droit d'être "stupide" et de répéter plusieurs fois certaines options, dans ce cas, snerr, on tient compte du dernier changement.
# les options sont expliquées aux lignes précédantes / dans l'aide
while [[ -n $1 ]] ; do
	case "$1" in
		-h) aide;
			exit 0;;
		-o) output $2;
			shift 2;;
		-O) output_force $2;
			shift 2;;
		-i) input $2;
			shift 2;;
		-n) name_input $2;
			shift 2;;
		-f) format $2;
			shift 2;;
		-k) actualise;
			shift;;
		-s) silence;
			shift;;
		-S) silence_tout;
			shift;;
		-u) universel $2;
			shift 2;;
		-uv) universel_video $2;
			shift 2;;
		-up) universel_playlist $2;
			shift 2;;
		*) echo "ERREUR: L'option $1 n'est pas reconnue."; exit 1; break;;
	esac
done

#echo "récapitulatif:
#répertoire du script: $initial
#répertoire des url: $dossier
#fichier des url: $dossier/$nom
#format: $format
#répertoire d'enregistrement des videos:"
#pwd

# vérifications -i / -n
cat $dossier/$nom > /dev/null ||
{
	echo "ERREUR: aucun fichier $nom dans $dossier."
	exit 1
}

# videos seules
echo "telechargement d'une liste d'audios SANS FORMATAGE..."
for var1 in `cat $dossier/$nom | grep '^\![a-zA-Z]' | sed 's/^\!//'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --no-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	echo "SHELL: youtube-dl  --no-playlist -x -f $var2 \$URL $univ $univ_video"
	youtube-dl  --no-playlist -x -f $var2 $var1 $univ $univ_video > $silence 2> $silence_erreur
	echo "fait"
done

echo "telechargement d'une liste d'audios..."
for var1 in `cat $dossier/$nom | grep '^[a-zA-Z]'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --no-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	echo "SHELL: youtube-dl  --no-playlist -x -f $var2 --audio-format $format \$URL $univ $univ_video"
	youtube-dl  --no-playlist -x -f $var2 --audio-format $format $var1 $univ $univ_video > $silence 2> $silence_erreur
	echo "fait"
done

# playlists NON FORMATEES
echo "telechargement de playlists SANS FORMATAGE"
for var1 in `cat $dossier/$nom | grep '^\+' | sed 's/^\+//'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --yes-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	echo "SHELL: youtube-dl  --yes-playlist -x -f $var2 \$URL $univ $univ_video"
	youtube-dl  --yes-playlist -x -f $var2 $var1 $univ $univ_playlist > $silence 2> $silence_erreur
	echo "fait"
done
echo "telechargement termine"

# playlists
echo "telechargement de playlists"
for var1 in `cat $dossier/$nom | grep '^\+' | sed 's/^\+//'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --yes-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	echo "SHELL: youtube-dl  --yes-playlist -x -f $var2 --audio-format $format \$URL $univ $univ_video"
	youtube-dl  --yes-playlist -x -f $var2 --audio-format $format $var1 $univ $univ_playlist > $silence 2> $silence_erreur
	echo "fait"
done
echo "telechargement termine"

# actualisation du fichier $nom
if [[ $actualise = "methode_1" ]]; then
	echo "actualisation de la liste..."
	cd $dossier
	mv $nom.old $nom.temp
	cat $nom.temp $nom > $nom.old
	rm $nom.temp
	echo "" > $nom
	echo "actualisation terminee"
else
	echo "Pas d'actualisation de $nom demandée."
	echo "Utilisez l'option -k pour activer l'actualisation."
fi













#
