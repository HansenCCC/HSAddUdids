#!/bin/bash


#######################################################

# addUdids.sh
# 脚本添加udid
# Created by 程恒盛 on 2019/12/3.
# Copyright © 2019 力王工作室. All rights reserved.
# QQ:2534550460@qq.com  GitHub:https://github.com/HansenCCC  tel:13767141841

# 参考文档
# https://docs.fastlane.tools/  fastlane官方文档
# https://www.jianshu.com/p/1d63bfef1738 关于spaceship工具的简单了解
# https://www.jianshu.com/p/19ae8cc865b0 fastlane使用说明书和处理关于开启两步验证如何全自动化问题
# https://www.jianshu.com/p/2defceba2761 使用fastlane创建profile、添加设备、创建推送证书 以及上传蒲公英
# https://blog.csdn.net/LiaoQuesg/article/details/101219984 搭建 超级签 详细攻略
# https://www.jianshu.com/p/16e0d9b8e7ca Fastlane自动化打包---打包上传App Store Connect
# https://github.com/fastlane/fastlane/blob/master/spaceship/docs/DeveloperPortal.md#example-data fastlane/spaceship/docs/DeveloperPortal.md
# https://www.jianshu.com/p/db52889f20d0 Fastlane - 从创建证书到上传到App Store
# https://www.jianshu.com/p/665efd203259 记一次设置Fastlane支持苹果双重认证的过程


# 编译系统：苹果Mac
# 编译系统版本：MacOS Catalina 10.15.1
# 需要终端环境：：fastlane、spaceship、lane、ruby、cocoapods 需要安装APP：Xcode

#######################################################
#安装fastlane
#sudo gem install fastlane -n /usr/local/bin
#安装pry
#sudo gem install -n /usr/local/bin sigh --pre

starttime=$(date +%Y-%m-%d\ %H:%M:%S)
echo "🚀 开始时间 $starttime 🚀"

#bundleid
export FASTLANE_BUNDLEID=''
#mac开机密码
export FASTLANE_MAC_PASSWORD=''
#提供需要添加udid的账号
export FASTLANE_APPLEID=''
#关闭双重认证 需要手动添加 APP-SPECIFIC和session cookie 进入苹果官网生成的特殊密码APP-SPECIFIC https://appleid.apple.com/account/manage
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=''
#appleid密码
export FASTLANE_PASSWORD=''
#执行fastlane spaceauth -u user@email.com，生成session cookie
export FASTLANE_SESSION=''


function findSuffixFile(){
    for i in `ls -a *.$1`
    do
        echo "$1为后缀的文件存在"
        return 0
    done
    echo "$1为后缀的文件不存在"
    return 1
}
#判断是否存在后缀名为cer的文件
CerSuffixFile=1
if findSuffixFile 'cer'
then
    CerSuffixFile=0
fi
#判断是否存在后缀名为mobileprovision的文件
MobileprovisionSuffixFile=1
if findSuffixFile 'mobileprovision'
then
    MobileprovisionSuffixFile=0
fi

#code
#解锁keychain，是其它工具可以访问证书
security unlock-keychain -p ${FASTLANE_MAC_PASSWORD} ~/Library/Keychains/login.keychain
#更新cocoapods
#/usr/local/bin/pod update --verbose --no-repo-update

#获取输入的所有的udid
udids=$*
#echo $udids
udidsStr=""
for udid in ${udids}
do
    echo "正在添加的udid:${udid}"
    udidsStr+="${udid},"
done
echo "需要添加的udid集合${udidsStr}"
#添加udid 测试案例fastlane addUdids udids:"123,123" appleid:"2534550460@qq.com"
echo "fastlane addUdids udids:${udidsStr} appleid:${FASTLANE_APPLEID}"
fastlane addUdids udids:${udidsStr} appleid:${FASTLANE_APPLEID}

#添加udid成功，下载mobileprovision和certificates。当应用、mobileprovision、certificates、bundleid和不存在时，自动创建 0已经表示存在 1表示不存在
echo "fastlane downloadsProfile bundleid:${FASTLANE_BUNDLEID} appleid:${FASTLANE_APPLEID} name:${FASTLANE_BUNDLEID} cer:${CerSuffixFile} mobileprovision:${MobileprovisionSuffixFile}"
fastlane downloadsProfile bundleid:${FASTLANE_BUNDLEID} appleid:${FASTLANE_APPLEID} name:${FASTLANE_BUNDLEID} cer:${CerSuffixFile} mobileprovision:${MobileprovisionSuffixFile}

endtime=$(date +%Y-%m-%d\ %H:%M:%S)
echo "🚀 开始时间 $starttime 🚀"
echo "🚀 结束时间 $endtime 🚀"
#脚本过度文档
#desc "注册手机udid到指定AppId账号"
#lane :addUdids do |option|
#    #接收到的所有参数
#    puts "接收到的所有参数 #{option}"
#    udidsStr = option[:udids]
#    if option.keys.size>0
#       #字符串 -> 数组
#       udidsArray = udidsStr.split(",")
#       puts "需要添加的udid集合 #{udidsArray}"
#       #数组 -> 字典（hash）
#       udidsDic = {}
#       for tmpUdid in udidsArray do
#          tmpDic = {tmpUdid => tmpUdid}
#          udidsDic = udidsDic.merge tmpDic
#       end
#       puts udidsDic
#       #添加udid
#       register_devices(
#         devices:udidsDic,
#         username: "zhishi188@sina.cn"
#          #username: "2534550460@qq.com"
#       )
#    elsif
#       puts "⚠️ ⚠️ ⚠️  udids集合为空  ⚠️ ⚠️ ⚠️"
#    end
#end
#
# before_all  do |options|
#    puts "🚀🚀🚀 fastlane 初始化准备执行 🚀🚀🚀"
# end
# 
# before_each  do |options|
#    puts "🚀🚀🚀 lane #{options}初始化准备执行 🚀🚀🚀"
# end
# 
# after_each  do |options|
#    puts "🚀🚀🚀 lane #{options}执行完成 🚀🚀🚀"
# end
# 
# after_each  do |options|
#    puts "🚀🚀🚀 fastlane 完成执行 🚀🚀🚀"
# end
# 
# error  do |options|
#    puts "⚠️ ⚠️ ⚠️  lane #{options}出现错误  ⚠️ ⚠️ ⚠️"
# end




####################################################################

#desc "注册设备"
#lane :add_devices do
#    register_devices(
#      #devices_file: "./devices.txt",  # 指定包含设备信息的文件路径，文件具体格式参考https://devimages.apple.com.edgekey.net/downloads/devices/Multiple-Upload-Samples.zip
#      devices: {
#        "Luka iPhone 6" => "1234567890123456789012345678901234567890",
#        "Felix iPad Air 2" => "abcdefghijklmnopqrstvuwxyzabcdefghijklmn"
#      },  # 指定要注册的设备列表，格式为：设备名称 => UDID
#      username: "xx@apple.com"  # 设置Apple ID
#    )
#end

#Appfile: 存储有关开发者账号相关信息
#
#Fastfile: 核心文件，主要用于 命令行调用和处理具体的流程，lane相对于一个方法或者函数
#
#Deliverfile: deliver工具的配置文件
#metadata: 元数据文件夹
#
#Matchfile: Match操作对应的配置文件
#
#screenshots: 截图文件夹




#关于开启两步验证如何全自动化问题
#1.访问 https://appleid.apple.com/account/manage
#2.生成一个 APP-SPECIFIC PASSWORDS，保留生成的特殊密码
#3.使用环境变量提供这个密码给fastlane：  FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
#4.执行fastlane spaceauth -u user@email.com，生成session cookie。
#5.通过环境变量FASTLANE_SESSION 提供session cookies。
#
#配置地方：
#
#打包机：~/.bash_profile 中，配置 FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD 和 FASTLANE_SESSION
#
#例如：
#export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD='edwq-upll-vtpt-mkil'
#export FASTLANE_SESSION='—\n- !ruby/object:HTTP::Cookie\n  name: DES5612c57fe9305b07801a04a701978047c\n  value: HSARMTKNSRVXWFlayJcyPJz1OsFDHeKrQRWoZIIItWMLqqur7wwChn2OFd5JKkjTlGs3FXQxc5Dh94xDMpd35T96YDp34rWOuQX04NnxBDmPdAOOi3fkVlOKkOFzlS7gOJG9r0B7SRVX\n  domain: idmsa.apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires: \n  max_age: 2592000\n  created_at: 2019-11-28 16:05:18.278616000 +08:00\n  accessed_at: 2019-12-03 10:38:39.970422000 +08:00\n- !ruby/object:HTTP::Cookie\n  name: myacinfo\n  value: DAWTKNV2d60f519deb048710b61ff5ad231d487f5a542260a0036cc8ec44abb26dd218fa03fb71d4bfef0da574e3f2bb9d566183e1e6ca390593230258ba06ce84eaf399f07d6eda6ef5682bee77ffb78448543ca11ea41e43336e5243d255199e5e1b03c719f3918f0075c1399b120d9e7d12bd10a117f0ee7df1bbc5936993f54322a9b0abed258e30d3c9a69a582d2406d373ca360ac618cf1bc3bd1f1d7b3ea6ddc74ec6d637a24893f9851819fe8d40dc94fd47b82752829ebea292fc5830c29f6cbbdc64f3de575f405712e9d78ef58c6e6fd098c89453228bb22f0f4d657c14f4f49b4dbc99307c6ccfb680374b7298f50e3cb58bde7f3b18e2650afdf6b5b12e35653835393865613666363931646235306332373564666362663161343438636563633536633965MVRYV2\n  domain: apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires: \n  max_age: \n  created_at: 2019-12-03 10:38:40.883705000 +08:00\n  accessed_at: 2019-12-03 10:38:40.884364000 +08:00\n- !ruby/object:HTTP::Cookie\n  name: dqsid\n  value: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1NzUzNDA3MzIsImp0aSI6Im1HNU1Wc0hYWENkQ2FzVmxCcm1qVkEifQ.NOFMQJjY4gZXAAhfRSDWHbKPyERqDte7boJL9Kx_XCM\n  domain: appstoreconnect.apple.com\n  for_domain: false\n  path: "/"\n  secure: true\n  httponly: true\n  expires: \n  max_age: 1799\n  created_at: &1 2019-12-03 10:38:41.912579000 +08:00\n  accessed_at: *1\n'


#fastlane sigh manage #列表出所有provisioning profiles
#fastlane sigh manage -e #删除无效provisioning profiles

#添加凭证
#fastlane fastlane-credentials add --username zhishi188@sina.cn
#删除凭证
#fastlane fastlane-credentials remove --username zhishi188@sina.cn
