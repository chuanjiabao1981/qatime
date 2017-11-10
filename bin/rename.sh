#!/bin/bash
cd ../app/assets/images/



root_dir=`pwd`
subjects=(化学-chemistry 科学-science 历史-history 生物-biology 数学-mathematics 物理-physics 英语-english 语文-chinese 政治-politics 地理-geography)
cates=(直播课-courses-直 一对一-interactive_courses-一 视频课-video_courses-视 专属课-groups-专)
for cate in ${cates[@]}; do
  cd $root_dir
  c1=`echo $cate | cut -d "-" -f1`
  c2=`echo $cate | cut -d "-" -f2`
  c3=`echo $cate | cut -d "-" -f3`
  for subject in ${subjects[@]}; do
    s1=`echo ${subject} | cut -d "-" -f1`
    s2=`echo ${subject} | cut -d "-" -f2`
    for filename in `ls ${root_dir}/${c1}/${s1}/`; do
      new_name=`echo $filename | sed s/${c3}//`
      mv "$root_dir/$c1/$s1/${filename}" "$root_dir/$c2/$s2/$new_name"
    done
    rm -rf ${root_dir}/${c1}/${s1}
  done
done

for filename in `ls */*/*X*.png`; do
  new_name=`echo $filename | sed 's/160X100/small_default/'`
  new_name=`echo $new_name | sed 's/320X200/list_default/'`
  new_name=`echo $new_name | sed 's/480X300/info_default/'`
  new_name=`echo $new_name | sed 's/800X500/app_info_default/'`

  echo "rename file ${filename} ===> ${new_name}"
  mv $filename $new_name
done


for filename in `ls */*/*x*.png`; do
  new_name=`echo $filename | sed 's/160x100/small_default/'`
  new_name=`echo $new_name | sed 's/320x200/list_default/'`
  new_name=`echo $new_name | sed 's/480x300/info_default/'`
  new_name=`echo $new_name | sed 's/800x500/app_info_default/'`

  echo "rename file ${filename} ===> ${new_name}"
  mv $filename $new_name
done