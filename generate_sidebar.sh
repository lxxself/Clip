#!/bin/bash

#遍历所有 md 文件，生成 _sidebar.md
echo "<!-- docs/_sidebar.md -->" > _sidebar.md

for dir in docs/*/ ; do
    echo "" >> _sidebar.md

    # echo "* ${dir%/}" >> _sidebar.md
    dir1=${dir%/} # 删除末尾的斜线
    title=${dir1##*/} 
    echo "* $title" >> _sidebar.md

    # find "$dir" -name '*.md' -type f -print0 | sort -z | xargs -0 -I {} sh -c 'filename=${1##*/}; filename=${filename%.*}; filepath=${1// /%20}; filepath=${filepath//\.\//}; echo "    * [$filename]($filepath)" >> _sidebar.md' _ {} \;
    find "$dir" -name '*.md' -type f -print0 | sort -z | xargs -0 -I {} sh -c 'filename=${1##*/}; filename=${filename%.*}; filename=$(echo $filename | sed "s/^[0-9]*-[0-9]*-[0-9]*-//"); filepath=${1// /%20}; filepath=$(echo $filepath | sed "s,//,/,g"); echo "    * [$filename]($filepath)" >> _sidebar.md' _ {} \;
done