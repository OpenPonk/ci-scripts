#!/bin/bash

set -euxo pipefail

ci_build_dir=$SMALLTALK_CI_BUILD
package_dir="$PROJECT_NAME-$PLATFORM"
vm_dir=`cat $SMALLTALK_CI_VM | sed 's|\(.*\)/.*|\1|'`/pharo-vm

mkdir -p "$package_dir/image"
mkdir -p "$package_dir/pharo"

cp $ci_build_dir/TravisCI.image $package_dir/image/$PROJECT_NAME.image
cp $ci_build_dir/TravisCI.changes $package_dir/image/$PROJECT_NAME.changes
cp $ci_build_dir/*.sources $package_dir/image

cp -r $vm_dir/bin $package_dir/pharo/bin
cp -r $vm_dir/lib $package_dir/pharo/lib

cat << EOF > $package_dir/$PROJECT_NAME
#!/bin/bash
\`dirname "\$0"\`/pharo/bin/pharo \`dirname "\$0"\`/image/$PROJECT_NAME.image
EOF

cat << EOF > $package_dir/$PROJECT_NAME-pharo-ui
#!/bin/bash
pharo-ui \`dirname "\$0"\`/image/$PROJECT_NAME.image
EOF

cat << EOF > $package_dir/README.txt
# Installation and Opening

To run OpenPonk on Debian-based, Ubuntu-based and possibly other Linux distros, simply use $PROJECT_NAME executable.

## In case of errors/exceptions

OpenPonk might encounter some error when used with some Linux distros. In that case, installation of Pharo programming language is required (sudo privileges needed).

	1. Open Pharo builds website: https://software.opensuse.org//download.html?project=devel:languages:pharo:stable&package=pharo-ui
	2. Select your Linux distribution.
	3. Select "Add repository and install manually".
	4. Follow shown instructions and execute each bash command in terminal - one line at a time.
 		You might need to prepend "sudo" before each line.
 		If your distro version does not match the given options, try manually updating the version number/name in the code.

After Pharo is installed, you may run OpenPonk using $PROJECT_NAME-pharo-ui executable.

EOF

cat "ci-scripts/.github/scripts/readmecommon.txt" >> "$package_dir/README.txt"

chmod a+rx $package_dir/$PROJECT_NAME $package_dir/$PROJECT_NAME-pharo-ui

"$vm_dir/bin/pharo" --headless $package_dir/image/$PROJECT_NAME.image eval --save "PharoCommandLineHandler forcePreferencesOmission: true. OPVersion currentWithRunId: $RUN_ID projectName: '$REPOSITORY_NAME'"

zip -qr $PROJECT_NAME-$PLATFORM-$VERSION.zip $package_dir
