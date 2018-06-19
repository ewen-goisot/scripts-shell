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

Futures options:
	TODO : (s) sous-titres
	TODO : (m) masquer les messages de youtube-dl
	TODO : moifications légères de l'aide selon les options précédemment sélectionnées (partiellement fait)

Dans le fichier $nom:
si le premier caractère d'une ligne est,
	(pas de caractère special) : enregistre la vidéo seule (option --no-playlist dans youtube-dl).
	+ : télécharge la playlist correspondante lorsque cela a un sens, la vidéo seule sinon (option --yes-playlist)
	# : ne tient pas compte de cette ligne (la traite comme un commentaire)


Exemples d'utilisation:
----> basique:
	$thisthis
----> aide:
	$thisthis -h
----> enregistrer les audios dans \"Musiques\"
	$thisthis -o ~/Musiques
----> complet (depuis ~/Documents/$nom vers ~/Musiques/ma_playlist_5 au format audio aac et actualiser) :
	$thisthis https://www.youtube.com/watch?v=V2vSq0YoWjA.sh -O ~/Musiques/ma_playlist_5 -k -i ~/Documents -n $nom -f aac
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
echo "telechargement d'une liste d'audios..."
for var1 in `cat $dossier/$nom | grep '^[a-zA-Z]'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --no-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	youtube-dl  --no-playlist -x -f $var2 --audio-format $format $var1
	echo "fait"
done

# playlists
echo "telechargement de playlists"
for var1 in `cat $dossier/$nom | grep '^\+' | sed 's/^\+//'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --yes-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	youtube-dl  --yes-playlist -x -f $var2 --audio-format $format $var1
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
