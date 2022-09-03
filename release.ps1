$version = "1.0.2"

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
New-Item -ItemType Directory -Force -Path "$PSScriptRoot\NoTalk"

$dest = "$PSScriptRoot\NoTalk"

Copy-Item "$PSScriptRoot\NoTalk.lua" -Destination $dest
Copy-Item "$PSScriptRoot\NoTalk.toc" -Destination $dest
Copy-Item "$PSScriptRoot\LICENSE" -Destination $dest
Copy-Item "$PSScriptRoot\README.md" -Destination $dest

Compress-Archive -Path $dest -DestinationPath "$PSScriptRoot\NoTalk-$version.zip"
