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

# Installation and Opening

OpenPonk scripts are not signed and when you download OpenPonk, it is quarantined. 
To overcome this, you cannot open OpenPonk with simple double click first time.

First time opening (or after updating OP):
	1) Right click the $PROJECT_NAME (Unix executable)
	2) Open
	-> Confirmation dialog appears with Cancel and Open buttons
	3) Open
	4) If you are not an administrator, login dialog opens. Log in as admin and confirm the dialog
	-> OpenPonk should open now. If there is a window asking to receive keystrokes, you may Deny it
Next time opening:
	1) Double click $PROJECT_NAME (Unix executable)

EOF

cat "ci-scripts/.github/scripts/readmecommon.txt" >> "$package_dir/README.txt"

$vm_dir/Pharo.app/Contents/MacOS/Pharo --headless $package_dir/image/$PROJECT_NAME.image eval --save "OPVersion currentWithRunId: $RUN_ID projectName: '$REPOSITORY_NAME'"

ditto -ck --keepParent --rsrc $package_dir $PROJECT_NAME-$PLATFORM-$VERSION.zip
