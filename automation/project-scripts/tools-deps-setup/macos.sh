#!/bin/bash
# Funny enough, I switched to curl for all project-scripts, so this is not necessary now.
# I'm keeping it for documentation purposes.

# Install brew first, this also fixes svn (in case we need export from GitHub or something)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install wget
