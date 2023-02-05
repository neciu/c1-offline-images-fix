#!/bin/bash
echo "input file:" $1
echo "base path:" $2

input=$1
basePath=$2
offline_pks=()
while IFS= read -r line
do
  IFS=";" read -r path pk <<< "$line"

  if [ -e "$basePath$path" ]
  then
    echo "online $basePath$path ($pk)"
  else
    echo "offline $basePath$path ($pk)"
    offline_pks=(${offline_pks[@]} $pk)
  fi
done < "$input"

printf -v joined_pks ',"%s"' "${offline_pks[@]}"
joined_pks=${joined_pks:1}  

query=""
query=$query"UPDATE zimage\n"
query=$query"SET ZCAMERA_SERIAL = \"offline_photo\"\n"
query=$query"WHERE z_pk IN ("$joined_pks");"

echo -e $query > "./update-query.sql"
