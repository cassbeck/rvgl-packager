#!/bin/bash

usage(){
  echo "usage $0 input_file"
  echo
  echo "- input_file: file must contains Re-Volt World URL to add in the package"
  echo
}

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo
    usage
    exit 1
fi

if [ ! -f $1 ]; then
    echo "File not found"
    echo
    usage
    exit 1
fi

list=`cat $1`

rvgl_linux=https://distribute.re-volt.io/packs/rvgl_linux.zip
rvgl_linux_zip=zips/rvgl_linux.zip
fix_cases=pack/fix_cases
package_file=package.json
package_zip=package.zip
package_sha=package.sha256


if [ ! -f ${fix_cases} ]; then
  wget ${rvgl_linux} -q -O ${rvgl_linux_zip}  
  unzip -q ${rvgl_linux_zip} fix_cases
  mv fix_cases ${fix_cases}
fi


\rm $package_zip $package_file $package_sha 2>/dev/null

echo "[" > $package_file
for file in $list; do

   if [ ! -z "${name}" ];
   then
     echo "  ," >>$package_file
   fi

   unset name
   unset folder_name
   unset img_url
   unset download_link
   unset category

   echo $file
   echo "  donwloading..."

   wget $file -q -O index.html

   if [ $? -eq 0 ]; then
     echo "  processing..."
     
    while IFS= read -r line; do
      if [ -z "${name}" ];
      then
        name=`echo $line | sed -n 's/.*<h1 class="post-title entry-title">\(.*\)<\/h1>.*/\1/p'`
      fi        
      if [ -z "${folder_name}" ];
      then
        folder_name=`echo $line | sed -n 's/.*<span class="badge">\([a-Z].*\)<\/span>.*/\1/p' | tr '[:upper:]' '[:lower:]'`
      fi        
      if [ -z "${img_url}" ];
      then
        img_url=`echo $line | sed -n 's/.*<img class="wpdm-default-template-preview-image" src=\(.*\) width.*/\1/p'`
      fi     
      if [ -z "${download_link}" ];
      then
        download_link=`echo $line | sed -n 's/.*href=\x27\(.*\)\x27>Download<\/a>.*/\1/p'`
      fi         
      if [ -z "${category}" ];
      then
        category=`echo $line | sed -n 's/<span class="badge">.*rel="tag">\(.*\)<\/a>.*/\1/p'`
      fi                       
    done < index.html

    img_name=`echo -n images/${name} | sed 's/\ /_/g';echo .${img_url##*.}`        
    zip_file="zips/${folder_name}.zip"

    echo "    Name:         ${name}"
    echo "    Category:     ${category}"
    echo "    Folder name:  ${folder_name}"
    echo "    Image url:    ${img_url}"
    echo "    Download url: ${download_link}"    
    echo "    Image:        ${img_name}"
    echo "    Zip File:     ${zip_file}"

    echo "  {"                                   >> $package_file;
    echo "    \"name\":     \"${name}\","        >> $package_file;
    echo "    \"category\": \"${category}\","    >> $package_file;
    echo "    \"folder\":   \"${folder_name}\"," >> $package_file;
    echo "    \"image\":    \"${img_name}\","    >> $package_file;
    echo "    \"zip\":      \"${zip_file}\","    >> $package_file;
    echo "    \"url\":      \"${file}\""         >> $package_file;        
    echo "  }"                                   >> $package_file;

    if [ ! -f ${img_name} ]; then
      wget ${img_url} -q -O ${img_name}
    fi

    if [ ! -f ${zip_file} ]; then
      wget ${download_link} -q -O ${zip_file}
      unzip -q ${zip_file} -d pack
    fi

   else
     echo "  failed, skipping"
   fi
done

echo "]" >> $package_file

echo
echo Generating files...

cd pack

./fix_cases > /dev/null << EOF
y
EOF

zip -rq ../$package_zip cars/* gfx/* levels/*
cd ..
sha256sum $package_zip > $package_sha

\rm index.html
echo
echo Generated files:
echo " - $package_file"
echo " - $package_zip"
echo " - $package_sha"
echo