#!/bin/bash
cd ../app/assets/images/

for filename in `ls */*/*X*.png`; do
  new_name=`echo $filename | sed 's/160X100/small_default/'`
  new_name=`echo $new_name | sed 's/320X200/list_default/'`
  new_name=`echo $new_name | sed 's/480X300/info_default/'`
  new_name=`echo $new_name | sed 's/800X500/app_info_default/'`

  echo "rename file ${filename} ===> ${new_name}"
  mv $filename $new_name
done
