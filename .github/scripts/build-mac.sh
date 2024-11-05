#!/bin/bash

set -euxo pipefail

ci_build_dir=$SMALLTALK_CI_BUILD
package_dir="$PROJECT_NAME-$PLATFORM"
vm_dir=`cat $SMALLTALK_CI_VM | sed 's|\(.*\)/.*|\1|'`/pharo-vm

mkdir -p "$package_dir/image"

ditto $vm_dir $package_dir

cp $ci_build_dir/TravisCI.image $package_dir/image/$PROJECT_NAME.image
cp $ci_build_dir/TravisCI.changes $package_dir/image/$PROJECT_NAME.changes
cp $ci_build_dir/*.sources $package_dir/image

cat << EOF > $package_dir/$PROJECT_NAME
#!/bin/bash
xattr -r -d com.apple.quarantine "\`dirname "\$0"\`"
"\`dirname "\$0"\`/Pharo.app/Contents/MacOS/Pharo" "\`dirname "\$0"\`/image/$PROJECT_NAME.image"
EOF

chmod a+rx $package_dir/$PROJECT_NAME

cat << EOF > $package_dir/README.txt
# Installation

OpenPonk scripts are not signed and when you download OpenPonk, all the files become quarantined.
It means all the files have attribute com.apple.quarantine that has to be removed. To do that:

1) Open Terminal
2) Navigate to the directory with openponk-plugins (Unix executable script)
3) Run `xattr -d com.apple.quarantine openponk-plugins`
4) Double click $PROJECT_NAME (Unix executable script)

The $PROJECT_NAME script should remove the quarantine attribute from all the other files and open the OpenPonk application.
If there is a window asking to receive keystrokes, you may Deny it

# Opening

1) Double click $PROJECT_NAME (Unix executable script)

EOF

cat "ci-scripts/.github/scripts/readmecommon.txt" >> "$package_dir/README.txt"

$vm_dir/Pharo.app/Contents/MacOS/Pharo --headless $package_dir/image/$PROJECT_NAME.image eval --save "OPVersion currentWithRunId: $RUN_ID projectName: '$REPOSITORY_NAME'"

ditto -ck --keepParent --rsrc $package_dir $PROJECT_NAME-$PLATFORM-$VERSION.zip
