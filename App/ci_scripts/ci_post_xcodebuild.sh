# #!/bin/zsh

# # Uploads debug informatino to Sentry
# # The following variables should be set in the xcode workflow
# # SENTRY_ORG
# # SENTRY_PROJECT
# # SENTRY_AUTH_TOKEN
# function upload_sentry_debug_files() {
#   # This is necessary in order to have sentry-cli
#   # install locally into the current directory
#   export INSTALL_DIR=$PWD

#   if [[ $(command -v sentry-cli) == "" ]]; then
#     echo "Installing Sentry CLI"
#     curl -sL https://sentry.io/get-cli/ | bash
#   fi

#   echo "Uploading dSYM to Sentry"

#   sentry-cli debug-files upload --include-sources $CI_ARCHIVE_PATH
# }

# # Creates a tag in github with the current app version and build number
# # The following variables should be set in the xcode workflow
# # GITHUB_TOKEN
# function tag_commit_with_version() {
#   GITHUB_ORG=majrdotapp
#   GITHUB_REPO=majr-ios

#   echo Starting SSH agent
#   eval "$(ssh-agent -s)"

#   echo Saving Github Deploy Key
#   echo "$GITHUB_DEPLOY_KEY" | base64 -d >./github-deploy-key.pem

#   chmod 600 ./github-deploy-key.pem

#   echo Adding Github Deploy Key to SSH Agent
#   ssh-add ./github-deploy-key.pem

#   #   if [[ -n $CI_APP_STORE_SIGNED_APP_PATCFBundleVersionH ]]; then # checks if there is an AppStore signed archive after running xcodebuild
#   BUILD_TAG=${CI_BUILD_NUMBER}
#   VERSION=$(cat ../project.yml | grep -m1 'CFBundleShortVersionString' | cut -d':' -f2 | tr -d "'" | tr -d ' ')

#   git tag v$VERSION-$BUILD_TAG -m "Version $VERSION Build $BUILD_TAG"
#   git push --tags git@github.com:$GITHUB_ORG/$GITHUB_REPO.git
#   #   fi
# }

# upload_sentry_debug_files
# # tag_commit_with_version
