# par defaut, option --no-playlist (pour notamment eviter de telecharger plusieurs fois la meme video)
# mettez un + devant votre url pour activer l'option --yes-playlist
# mettez un # devant votre url pour ne rien en faire

# videos seules
echo "telechargement d'une liste d'audios..."
for var1 in `cat url | grep '^[a-zA-Z]'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --no-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	youtube-dl  --no-playlist -x -f $var2 --audio-format mp3 $var1
	echo "fait"
done

# playlists
echo "telechargement de playlists"
for var1 in `cat url | grep '^\+' | sed 's/^\+//'`;do
	echo "URL: $var1"
	var2=$(youtube-dl --yes-playlist -F $var1 | grep "audio only" | sed 's/ .*//' | sed -n "1 p")
	youtube-dl  --yes-playlist -x -f $var2 --audio-format mp3 $var1
	echo "fait"
done
echo "telechargement termine"
echo "actualisation de la liste..."
#decommentez les 4 lignes suivantes si vous voulez enregistrer ailleurs vos url après utilisation
#mv url_old url_temp
#cat url_temp url > url_old
#rm url_temp
#echo "" > url
echo "actualisation terminee"

