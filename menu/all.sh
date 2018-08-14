path="/home/ewen-goisot/Documents/i3script/menu"
v1=",a1'drun"
v2=",a2'run"
v3=",a3'window"
v4=",a4'windowcd"
v5=",a5'mode"
v6=",a6'clipboard"
v7=",a7'ssh"
v8=",a8'texts"
v9=",a9'power"
v10=",a0'quit"
v11=",b1'keyboard"
v12=",b2'signal"
v13=",b3'rofi"
v14=",b4'"
v15=",b5'"
v16=",b6'"
v17=",b7'"
v18=",b8'"
v19=",b9'"
v20=",b0'"
# signal bar, kill process, reload this, list aliases, autres scripts, textes usuels, disposition clavier (toutes ne sont pas en racourci i3), mots de passe, mini tutoriel logiciel, audioboos longs


# utiliser l'option -format i pour que rofi ne renvoie qu'un nombre

answer=$(echo "$v1
$v2
$v3
$v4
$v5
$v6
$v7
$v8
$v9
$v10
$v11
$v12
$v13
$v14
$v15
$v16
$v17
$v18
$v19
$v20" | rofi -dmenu -auto-select -lines 10 -no-click-to-exit -format i)
echo $answer
case "$answer" in
	0) rofi -show drun -modi "run,drun";
		exit 0;;
	1) rofi -show run;
		exit 0;;
	2) rofi -show window;
		exit 0;;
	3) rofi -show windowcd;
		exit 0;;
	4) sh $path/script6.sh;
		exit 0;;
	5) sh $path/script6.sh;
		exit 0;;
	6) rofi -show ssh;
		exit 0;;
	7) sh $path/script8.sh;
		exit 0;;
	8) sh $path/script6.sh;
		exit 0;;
	9) exit 0;;
	*) true;
		exit 0;;
esac
