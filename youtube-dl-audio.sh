# installez youtube-dl (paquet)
# créez un fichier nommé "url" dans le même répertoire que ce script
# lancez le script (cd repertoire; ./nomduscript)

# par defaut, option --no-playlist (pour notamment eviter de telecharger plusieurs fois la meme video)
# mettez un + devant votre url pour activer l'option --yes-playlist
# mettez un # devant votre url pour ne rien en faire

dossier=$(pwd)
nom="url"

# -o specifie l'endroit ou l'on envoie les audios, renvoie une erreur si le dossier n'existe pas
if  [[ $1 = "-o" ]]; then
    cd $2 ||  
    {
    	echo "ERREUR: l'option -o necessite un chemin vers un dossier existant"
    	exit 1
    }
    echo "-o : les audios seront enregistres dans $2"
else
    echo "!o : par defaut, les fichiers sont enregistres dans $dossier"
    echo "la liste d'URLs est $dossier/$nom"
fi

# videos seules
echo "telechargement d'une liste d'audios..."
for var1 in `cat $dossier/$nom | grep '^[a-zA-Z]'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --no-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	youtube-dl  --no-playlist -x -f $var2 --audio-format mp3 $var1
	echo "fait"
done

# playlists
echo "telechargement de playlists"
for var1 in `cat $dossier/$nom | grep '^\+' | sed 's/^\+//'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --yes-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	youtube-dl  --yes-playlist -x -f $var2 --audio-format mp3 $var1
	echo "fait"
done
echo "telechargement termine"
echo "actualisation de la liste..."
# les lignes suivantes envoient les url dans un fichier nomme url.old
# vous pouvez commenter pour desactiver cette fonction
cd $dossier
mv $nom.old $nom.temp
cat $nom.temp $nom > $nom.old
rm $nom.temp
echo "" > $nom
echo "actualisation terminee"

