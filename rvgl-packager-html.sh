#!/bin/bash

categories=`cat package.json | jq -r '[.[].category] | unique | join(",")'`
directory=${PWD##*/}


cat > package.html << EOT 
<html>
    <head>
        <meta charset="UTF-8">
EOT
echo "        <title>ReVolt: $directory Pack</title>" >> package.html
cat >> package.html << EOT
        <link rel="icon" type="image/png" href="https://www.jeuxavolonte.asso.fr/revolt/favicon.png"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-wEmeIV1mKuiNpC+IOBjI7aAzPcEZeedi5yW5f2yOq55WWLwNGmvvx4Um1vskeMj0" crossorigin="anonymous">
EOT
echo "        <meta property=\"og:title\"       content=\"ReVolt: $directory Pack\" />" >> package.html
cat >> package.html << EOT         
        <meta property="og:description" content="Custom pack for rvgl-launcher">
    </head>    
</head>
<body class="bg-dark text-center text-light">
EOT
echo "    <h1>ReVolt: $directory Pack</h1>" >> package.html

IFS=',' read -ra ADDR <<< "$categories"
for category in "${ADDR[@]}"; do
    echo "    <hr/>" >> package.html
    echo "    <h2>$category</h2>" >> package.html
    echo "    <div class=\"row\">" >> package.html
    for row in `cat package.json | jq -r "group_by(.category) | .[] | .[] | select(.category==\"$category\") | @base64"`; do
        _jq() {
            echo ${row} | base64 --decode | jq -r ${1}            
        }
        name=$(_jq '.name')
        image=$(_jq '.image')
        url=$(_jq '.url')
        echo "        <div class=\"col-xl-2 col-lg-3 col-md-4 col-sm-6 col-6\">" >> package.html
        echo "            <h3>$name</h3>" >> package.html
        echo "            <a target=\"_img\" href=\"$url\"><img src=\"$image\" class=\"img-fluid\"></a>" >> package.html
        echo "        </div>" >> package.html
    done
    echo "    </div>" >> package.html
done
echo "</body>" >> package.html
