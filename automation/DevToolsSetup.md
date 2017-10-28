# Development tools setup

Parts of this are already in [WindowsSetup.md] (like Git/bash, ...) or [BashSetup.md]
(support for multiple Javas, ...)

## Gradle wrapper from anywhere inside project

Download: https://raw.githubusercontent.com/dougborg/gdub/master/bin/gw

Put it on path (e.g. `c:\work\tools\bin`). Now anywhere inside the project `gw` finds first
Gradle Wrapper, if it can't, it finds local Gradle.