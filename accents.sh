#/bin/zsh

# Fait par Ewen Goisot
# Ce script part d'un dictionnaire complet d'une langue, en extrait les mots
# avec des lettres indesirables, et tente de créer des abrev pour Vim

# Les lettres sont remplacées par des lettres sans accents, ou par un "x",
# expérimentalement:
# 300,000 mots
# 30,000 ont des lettres rares
# 1,000 bugs avec remp
# 2 bugs avec joker
# 0 bug avec les deux
# ce programme marche pour toutes les langues mais prend le postulat:
# « si _remp ne fonctionne pas, alors _joker fonctionne »

# Changez ces variables selon vos préférences
# l_ liste de mots, c_ caractères
dico="gut_uni_sort.txt"
# le dico avec lettres rares n'est pas forcément le même
dico_rare="dic_accents.txt"
l_rare="accents/l_rare.txt"
l_remp="accents/l_remp.txt"
l_joker="accents/l_joker.txt"
# diff
d_remp="accents/d_remp.txt"
d_joker="accents/d_joker.txt"
# vim
v_remp="accents/v_remp.txt"
v_joker="accents/v_joker.txt"
# varloc
aux="accents/aux"
aux2="accents/aux2"
c_rare="àâäåêëîïôöùûüÿçñ"
c_remp="aaaaeeiioouuuycn"
# sinon le tri ne prends pas les accents en compte
c_usual="éè"
c_masqe="56"
c_extra="æœ"
joker="x"
extra="s/œ/oe/g ; s/æ/ae/g"

# Test rapide
echo "à çhaqûe fois ça rempläçê, œùf" | sed "y/$c_rare/$c_remp/ ; $extra"
echo "à çhaqûe fois ça rempläçê, œùf" | sed "s/[$c_rare$c_extra]/$joker/g"

rm $l_remp 2>/dev/null
cat $dico_rare | grep "[$c_rare$c_extra]" > $l_rare
cat $l_rare | sed "s/.*/&\n1&/" > $aux
cat $aux | sed "/^[^1]/ y/$c_rare/$c_remp/" > $l_remp
cat $l_remp  | grep "^[^1]" | sort > $aux
# les abrev ne doivent pas être des mots du dico
comm -13 $dico $aux  | sed "s/$/0/" > $d_remp
cat $l_remp  | sed "/^[^1]/N ; s/\n//" > $aux
cat $aux $d_remp | sed "y/$c_usual/$c_masqe/"  | sort > $aux2
cat $aux2 | sed ":a /0$/N ; s/\n// ;ta; s/^.*0/0/" > $l_remp
cat $l_remp | sed "y/$c_masqe/$c_usual/ ; s/^0\(.*\)1\(.*\)$/iab \1 \2/ ;t; s/^[^0]\(.*\)1\(.*\)$/\2 \2/ ;Ta;:b;  s/[$c_rare$c_extra]\(.* \)/$joker\1/g ;tb; s/^/iab / ;t;:a; d" | sort > $v_remp
#for i in $(cat $l_rare) ; do
	##echo -n "$i" "0"
	##echo -n "$i" | sed "y/$c_rare/$c_remp/ ; $extra"
	##echo "\n"
	#echo "${i}0$(echo -n "$i" | sed "y/$c_rare/$c_remp/ ; $extra")" >> /mnt/tmpfs/l_remp.txt
#done


#rm $l_joker 2>/dev/null
#cat $l_rare | sed "y/$c_rare/$c_remp/ ; $extra" > $l_remp
#cat $l_rare | sed "s/[$c_rare$c_extra]/$joker/g" > $aux
#cat $aux | sort > $l_joker

