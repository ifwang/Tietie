## 二维码礼物 ##
能够将音频，图片等信息加在二维码中，作为礼物送给他人

## 所用技术 ##

 1. EZAudio  音频录制播放与界面化的解决方案，录制音频格式与lame冲突，未采用
 2. lame  音频格式转换静态库，将caf格式转为MP3
 2. ZBar  二维码扫描sdk，有硬插入个人的宣传网站，可考虑替换
 3. AFNetworking  网络请求sdk
 4. QiniuSDK  七牛上传sdk，官网sdk不靠谱，建议使用github上网友自己优化的[七牛sdk][1]

## 存在问题 ##

界面仍需继续调整

  [1]: https://github.com/qiniu/ios-sdk/releases