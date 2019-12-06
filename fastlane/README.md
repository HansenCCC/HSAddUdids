fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios addUdids
```
fastlane ios addUdids
```
注册手机udid到指定AppId账号
### ios downloadsProfile
```
fastlane ios downloadsProfile
```
下载provisioning_profile，不存在的bundleid和certificates自动新建并下载
### ios adhoc_profile
```
fastlane ios adhoc_profile
```
单纯下载provisioning_profile，不存在的bundleid自动新建并下载（已废弃）
### ios test
```
fastlane ios test
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
