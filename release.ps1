#when uploading to curse:
    #DisplayName - NoTalk-2.0.0
    #Changelog - 10.0.0 release
    #Change release type to release

$version = "2.0.0"

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
New-Item -ItemType Directory -Force -Path "$PSScriptRoot\NoTalk"

$dest = "$PSScriptRoot\NoTalk"

Copy-Item "$PSScriptRoot\NoTalk.lua" -Destination $dest
Copy-Item "$PSScriptRoot\NoTalk.toc" -Destination $dest
Copy-Item "$PSScriptRoot\LICENSE" -Destination $dest
Copy-Item "$PSScriptRoot\README.md" -Destination $dest

Compress-Archive -Path $dest -DestinationPath "$PSScriptRoot\NoTalk-$version.zip"
