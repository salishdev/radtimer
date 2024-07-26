#!/bin/zsh

RELEASE_URL=https://github.com/yonaskolb/XcodeGen/releases/download/2.38.0/xcodegen.zip
XCODEGEN_DIR=$HOME/xcodegen
curl -L -f $RELEASE_URL -o /tmp/xcodegen.zip
unzip "/tmp/xcodegen.zip" -d $XCODEGEN_DIR

cd $CI_PRIMARY_REPOSITORY_PATH/App
$XCODEGEN_DIR/xcodegen/bin/xcodegen generate

# trust swift macro targets
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
