#!/bin/bash

# Install brew first, this also fixes svn (in case we need export from GitHub or something)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install wget                          reading