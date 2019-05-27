scripts shell

made for GNU/Linux, sometimes needs Xdotool (works on Xorg, probably not on Wayland)

contient plusieurs projets:

--> youtube-dl-audio
(uses youtube-dl … can be installed with apt-get or something else)
download audios from YouTube without the video part (usefull if your internet is very low),
this script gives the right options to do so (find a valid audio format and use it… then convert if you want)
and can download several audios (the url should be saved on the same file)

--> prelatex:
split CSV to avoid quadratic complexity of some badly made LaTeX plugin

--> robot / robot2:
a robot that proves that it is not a robot (for one simple && useless captcha only)
(needs xdotool)

--> mouse:
remember the mouse position on each window, and put the mouse on foccused window when I move with keyboard (needs i3wm and xdotool)

--> hack_paste:
alternative solution for copy paste when website says "confirm your email" and tries to prevent you to paste
