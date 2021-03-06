#!/bin/sh

function set_env() { echo "$1=$2" >> $GITHUB_ENV; }
function debug() { echo "::debug::$1"; }

#开始构建
function app_build()
{
    debug "build with gradle"
    cd $APP_WORKSPACE
    chmod +x gradlew
    ./gradlew assembleAppRelease || ./gradlew clean && ./gradlew assembleAppRelease
    APP_BUILD_APK=$(find $APP_WORKSPACE/app/build -regex .*/release/.*.apk)
    debug "build apk $APP_BUILD_APK"
    if [ -f $APP_BUILD_APK ]; then
        set_env APP_UPLOAD ${APP_BUILD_APK%/*}
        debug "upload apk dir ${APP_BUILD_APK%/*}"
    fi
}
