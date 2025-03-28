$ci_build_dir="$home\.smalltalkCI\_builds"

$REPOSITORY_NAME=$Env:REPOSITORY_NAME
$PROJECT_NAME=$Env:PROJECT_NAME
$PLATFORM=$Env:PLATFORM
$VERSION=$Env:VERSION
$RUN_ID=$Env:RUN_ID

$package_dir="$PROJECT_NAME-$PLATFORM"
$vm_file_content=Get-Content $ci_build_dir/vm | Out-String
$vm_dir=(($vm_file_content -replace '/[^/]*$','/pharo-vm') -replace '/c/','C:\') -replace '/','\'

echo "Preparing files and directories..."

mkdir $package_dir
mkdir $package_dir/image
mkdir $package_dir/Pharo

cp $ci_build_dir/TravisCI.image $package_dir/image/$PROJECT_NAME.image
cp $ci_build_dir/TravisCI.changes $package_dir/image/$PROJECT_NAME.changes
cp $ci_build_dir/*.sources $package_dir/image

cp $vm_dir/*.dll $package_dir/Pharo
cp $vm_dir/Pharo.exe $package_dir/Pharo
cp $vm_dir/PharoConsole.exe $package_dir/Pharo

echo "Building README..."

"@echo off
start `"`" `"%~dp0Pharo\Pharo.exe`" `"%~dp0image\$PROJECT_NAME.image`"" | set-content "$package_dir/$PROJECT_NAME.bat"

". `"`$PSScriptRoot\Pharo\Pharo.exe`" `"`$PSScriptRoot\image\openponk-plugins.image`"" | set-content "$package_dir/$PROJECT_NAME.ps1"

"# Installation and Opening

Open using $PROJECT_NAME.bat.

Opening may take several seconds. If OpenPonk becomes unresponsive almost immediately and keeps increasing memory usage quickly, try opening by right-clicking $PROJECT_NAME.ps1 and `"Run with powershell`"

" | Set-Content "$package_dir/README.txt"

Get-Content -Path "ci-scripts\.github\scripts\readmecommon.txt" | Add-Content -Path "$package_dir/README.txt"

echo "Saving OPVersion..."

& $vm_dir/PharoConsole.exe --headless $package_dir/image/$PROJECT_NAME.image eval --save "OPVersion currentWithRunId: $RUN_ID projectName: '$REPOSITORY_NAME'"

echo "Packaging zip archive..."

Compress-Archive -Path $package_dir -DestinationPath "$PROJECT_NAME-$PLATFORM-$VERSION.zip"
