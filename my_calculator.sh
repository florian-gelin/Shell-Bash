nombre1=$1
operateur=$2
nombre2=$3
if [ "$operateur" = "+" ]
then
  echo $(($nombre1 + $nombre2))
elif [ "$operateur" = "-" ]
then
  echo $(($nombre1 - $nombre2))
elif [ "$operateur" = "x" ]
then
  echo $(($nombre1 * $nombre2))
elif [ "$operateur" = "/" ]
then
  echo $(bc -l <<<"$nombre1 / $nombre2")
fi
