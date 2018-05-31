# iOSPrinciple_AVFoundation
Principle AVFoundation

# AVFoundation

AVFoundation是苹果在iOS和OS X系统中用于处理基于时间的媒体数据的框架. 

![](http://og1yl0w9z.bkt.clouddn.com/18-5-31/8140547.jpg)

下面简单介绍下AVFoundation内最主要的支撑框架和其提供的功能.

* CoreAudio : 处理所有音频事件.是由多个框架整合在一起的总称,为音频和MIDI内容的录制,播放和处理提供相应接口.甚至可以针对音频信号进行完全控制,并通过Audio Units来构建一些复杂的音频处理.有兴趣的可以单独了解一下这个框架.
* CoreMedia: 是AVFoundation所用到低层级媒体管道的一部分.提供音频样本和视频帧处理所需的低层级数据类型和接口.
* CoreAnimation: 动画相关框架, 封装了支持OpenGL和OpenGL ES功能的ObjC各种类. AVFoundation可以利用CoreAnimation让开发者能够在视频的编辑和播放过程中添加动画和图片效果.

在深入了解学习[AVFoundation](https://www.jianshu.com/p/ff6814722e20)前,最好还要了解下相关现代数字媒体的采样和处理知识.

数字媒体采样: 其实就是对媒体内容进行数字化,主要有两种方式:

①时间采样：用来捕捉一个信号在一个周期内的变化.如录音时的音高和声调变化. 

②空间采样：一般用在可视化内容的数字化过程中,对一幅图片在一定分辨率下捕捉其亮度和色度.

## 音频处理部分

现实生活中，我们听到的声音都是时间连续的，我们称为这种信号叫模拟信号。模拟信号需要进行数字化以后才能在计算机中使用。数字化的过程如下：

![](http://og1yl0w9z.bkt.clouddn.com/18-5-31/96097173.jpg)

采样 -> 量化 -> 编码

通过获取间隔相同时间的某个模拟信号的值，然后对这些采样以后得到的值进行量化，然后使用一定的bit进行编码存储，整个过程结束后就会输出PCM数据。

在iOS的Core Audio Services中使用的音频数据只能是线性PCM格式的音频数据，这是一种未进过压缩的音频数据格式。要理解整个过程就需要理解多个重要概念：采样频率和采样位数，比特率等。

### 采样频率

采样频率是指单位时间内对声音模拟信号的采样次数。采样率类似于视频的帧数，比如电影的采样率是24Hz。

当我们把采样到的一个个静止画面再以采样率同样的速度回放时，看到的就是连续的画面。同样的道理，把以44.1kHZ采样率记录的CD以同样的速率播放时，就能听到连续的声音。

显然，这个采样率越高，听到的声音和看到的图像就越连贯。当然，人的听觉和视觉器官能分辨的采样率是有限的。对同一段声音，用20kHz和44.1kHz来采样，重放时，可能可以听出其中的差别，而基本上高于44.1kHZ采样的声音，比如说96kHz采样，绝大部分人已经觉察不到两种采样出来的声音的分别了。

之所以使用44.1kHZ这个数值是因为经过了反复实验，人们发现这个采样精度最合适，低于这个值就会有较明显的损失，而高于这个值人的耳朵已经很难分辨，而且增大了数字音频所占用的空间。我们所使用的CD的采样标准就是44.1k。

### 采样位数

采样位数可以理解为采集卡处理声音的解析度。这个数值越大，解析度就越高，录制和回放的声音就越真实。我们首先要知道：电脑中的声音文件是用数字0和1来表示的。连续的模拟信号按一定的采样频率经数码脉冲取样后，每一个离散的脉冲信号被以一定的量化精度量化成一串二进制编码流，这串编码流的位数即为采样位数，也称为量化精度。

在电脑上录音的本质就是把模拟声音信号转换成数字信号。反之，在播放时则是把数字信号还原成模拟声音信号输出。采集卡的位数是指采集卡在采集和播放声音文件时所使用数字声音信号的二进制位数。采集卡的位数客观地反映了数字声音信号对输入声音信号描述的准确程度。

例如，同一段音频信息，使用8bit描述单个采样信息，那么采样量化的范围就是0~255,如果使用16bit表示单个采样值,那么相应的采样量化的范围为0~64k。与8位采样位数相比，16位采样的动态范围的宽度更小，动态范围更宽广，声音的被记录的更加精细。一般CD使用的采样位数为16位。

16位二进制数的最小值是0000000000000000，最大值是1111111111111111，对应的十进制数就是0和65535，也就是最大和最小值之间的差值是65535，也就是说，它量化的模拟量的动态范围可以差65535，也就是96.32分贝（20 * lg65535）），所以，量化精度只和动态范围有关，和频率响应没关系。动态范围定在96分贝也是有道理的，人耳的无痛苦极限声压是90分贝，96分贝的动态范围在普通应用中足够使用，所以96分贝动态范围内的模拟波，经量化后，不会产生削波失真的。

所谓分贝是指两个相同的物理量（例A1和A0）之比取以10为底的对数并乘以10（或20）。N = 10lg(A1/A0) 分贝符号为”dB”，它是无量纲的。式中A0是基准量（或参考量），A是被量度量。被量度量和基准量之比取对数，这对数值称为被量度量的”级”。亦即用对数标度时，所得到的是比值，它代表被量度量比基准量高出多少“级”。

### 比特率（位速、码率）

位速/比特率/码率描述的都是一个东西，是指在一个数据流中每秒钟能通过的信息量。我们可能看到过音频文件用 “128–Kbps MP3” 或 “64–Kbps WMA” 进行描述的情形。Kbps 表示 “每秒千位数”，因此数值越大表示数据越多：128–Kbps MP3 音频文件包含的数据量是 64–Kbps WMA 文件的两倍，并占用两倍的空间。需要了解的重要一点是，位速越高，信息量越大，对这些信息进行解码的处理量就越大，文件需要占用的空间也就越多。

不过在这种情况下，这两种文件听起来没什么两样。原因是什么呢？有些文件格式比其他文件能够更有效地利用数据， 64–Kbps WMA 文件的音质与 128–Kbps MP3 的音质相同。

从码率的计算公式中可以清楚的看出码率和采样位数的关系:

码率 = 取样频率 × 量化精度 × 声道数

一张CD,双声道,采样率44.1kHz，每个采样位数13bit，时长74分钟(4440秒)，则CD的容量为13*2*44100*4440约等于640MB。

### 压缩编码模式

* VBR(Variable Bitrate)动态比特率
动态比特率就是没有固定的比特率，压缩软件在压缩时根据音频数据即时确定使用什么比特率。这是新发展的算法，他们将一首歌的复杂部分用高Bitrate编码，简单部分用低Bitrate编码。主意虽然不错，可惜新编码器的VBR算法很差，音质与CBR相去甚远。幸运的是， Lame完美地优化了VBR算法，使之成为MP3的最佳编码模式。这是以质量为前提兼顾文件大小的方式，推荐编码模式。

* ABR(Average Bitrate)平均比特率
平均比特率是VBR的一种插值参数。Lame针对CBR不佳的文件体积比和VBR生成文件大小不定的特点独创了这种编码模式。ABR也被称为“Safe VBR”，它是在指定的平均Bitrate内，以每50帧(30帧约1秒)为一段，低频和不敏感频率使用相对低的流量，高频和大动态表现时使用高流量。

举例来说，当指定用192kbps ABR对一段wav文件进行编码时，Lame会将该文件的85%用192kbps固定编码，然后对剩余15%进行动态优化：复杂部分用高于192kbps 来编码、简单部分用低于192kbps来编码。与192kbps CBR相比，192kbps ABR在文件大小上相差不多，音质却提高不少。ABR编码在速度上是VBR编码的2到3倍，在128-256kbps范围内质量要好于CBR。可以做为 VBR和CBR的一种折衷选择。

* CBR(Constant Bitrate)常数比特率
常数比特率指文件从头到尾都是一种位速率。相对于VBR和ABR来讲，它压缩出来的文件体积很大，但音质却不会有明显的提高。

### 数字信号编码方式

* PCM(Pulse Code Modulation)脉冲编码调制
脉冲编码调制是一种将模拟语音信号变换为数字信号的编码方式。主要经过3个过程：抽样、量化和编码。抽样过程将连续时间模拟信号变为离散时间、连续幅度的抽样信号，量化过程将抽样信号变为离散时间、离散幅度的数字信号，编码过程将量化后的信号编码成为一个二进制码组输出。

* LPCM(Line Pulse Code Modulation)线性脉冲编码调制
线性量化在整个量化范围内，量化间隔均相等，称为LPCM。非线性量化采用不等的量化间隔。量化间隔数由编码的二进制位数决定。例如，CD采用16bit线性量化，则量化间隔数L=65536。位数（n)越多，精度越高，信噪比SNR=6.02n+1.76(dB)也越高。但编码的二进制位数不是无限制的，需要根据所需的数据率确定。比如：CD可以达到的数据率为2×44.1×16=1411.2Kbit/s。

总而言之，LPCM格式中的音频数据是未压缩的线性量化后的音频数据。

用iOS的官方文档中对几个关键词的解释：
* A sample is single numerical value for a single channel.
* A frame is a collection of time-coincident samples. For instance, a stereo sound file has two samples per frame, one for the left channel and one for the right channel.
* A packet is a collection of one or more contiguous frames. In linear PCM audio, a packet is always a single frame. In compressed formats, it is typically more. A packet defines the smallest meaningful set of frames for a given audio data format.

### 压缩过的音频格式

在常见的音频格式对PCM原始帧进行封装时也是以frame帧为单位的，我们一般将压缩后的音频数据帧称为媒体帧，对应原始的PCM数据称为原始帧。每个媒体帧又分成head头，body数据体。

在帧头中，会存储这个媒体帧中body部分的码率，采样率等解码必须的信息，因此每一个媒体帧都可以独立于文件存在和播放。在body中存储着一个或者多个媒体帧，这些媒体真是若干个PCM原始帧经过特定的压缩算法压缩得到的。通常情况下，我们将单位时间的媒体帧的个数称为帧率。

上文的采样率和帧率这两个概念都描述了音频媒体的“连续”性，二者的区别在于每个音频的媒体帧中会包含多个音频采样(多个PCM data)，如1个AAC帧中包含1024个采样。

### iOS 支持的 sound file 格式

| Format name | Format filename extensions |
| ------------- | ------------- |
| AIFF | .aif, .aiff |
| CAF | .caf |
| MPEG-1, layer 3 | .mp3 |
| MPEG-2 or MPEG-4 ADTS | .aac |
| MPEG-4 | .m4a, .mp4 |
| WAV | .wav |

> iOS中的native format是CAF file format

### 文件格式和数据格式

如果要理解每一个音频文件,就需要了解它的两个部分的内容:文件格式和数据格式.文件格式又称为音频容器,数据格式又可以认为是编码格式.

* 文件格式(音频容器)

文件格式描述的是存储在文件系统的文件的本身,而存储在文件中的音频数据是可以被编码成各种各样的格式的.比如,我们常见的CAF文件是一个文件格式(音频容器),它可以用来存储音频编码格式为MP3,LPCM或者其他的音频编码格式.

* 数据格式(音频编码)

iPhone中支持的音频格式如下:

AAC: 被设计用来取代MP3音频编码的.它会压缩原来的声音,因此会减少存储空间.实际中ACC比MP3更好的压缩率.

AMR: AMR是一个编码格式用于压缩语音的音频编码格式.

linear PCM: 是标准的线性脉冲编码,一般是将模拟声音转化成数字信号,这是一个未压缩的音频格式.由于是未压缩的音频编码格式,因此播放时候用这种格式最是最好的选择,但是会占用过多的空间.

MP3: …

### Bit Rates比特率

比特率是一个和音频数据格式关系密切的概念.

音频文件的比特率就是只单位时间内传送的bit数,单位是bit/s,kbit/s.更高的比特率会导致更大的文件.我们在使用有些音频数据格式例如AAC或者MP3时,需要我们去设置比特率,这个参数与音频格式在压缩过程的压缩率有关.当我们让比特率变低,那么音频质量就会更差.

> 注释: 1kbit/s = 1000bit/s,而不是1024bit/s

我们需要权衡比特率的大小和声音文件的质量,选择合适的比特率.如果我们使用的是语音声音,那么比特率可以适当低一点.

下面是常见的比特率:

* 32kbit/s: AM 无限电广播的质量
* 48kbit/s: 很长的语音对话
* 64kbit/s: 正常长度的语音对话的比特率
* 96kbit/s: FM广播
* 128kbit/s: MP3音乐
* 329kbit/s: CD的比特率
* 500kbit/s~1411kbit/s: 无损音频编码格式,比如LPCM

### 使用建议
首先明确自己有哪些需求:

* 如果用于播放的音频,选用LPCM,IMA4等其他的未压缩或者轻度压缩的音频格式.
* 如果使用压缩率较高的AAC,MP3等这些iPhone直接硬件支持快速解码(解压缩).但是,硬件解码时候每次只支持一个文件.因此,如果需要同时播放多个需要解码(解压缩)的文件,就需要通过代码进行软件解码,非常慢.

所以如何选择数据音频格式,这里有些建议:

* 如果空间足够,那么最好使用的音频编码格式使用LPCM.不仅播放最快,而且可以同时播放多个音乐而不太占用CPU的资源.
* 如果对空间有要求,最好使用ACC音频编码来进行音乐的播放,IMA4音频编码进行系统声音的编码.


## 常用的音视频处理
通过代码实现常用的音视频处理示例，包括AVAudioPlayer 和 AVAudioPlayer 的剪辑、合成和压缩转码处理，AVPlayer 和 AVQueuePlayer 的演示等。

### AVAudioPlayer
#### 概述
AVAudioPlayer 是一个属于 AVFoundation.framework 的一个类，它的功能类似于一个功能强大的播放器，AVAudioPlayer 支持广泛的音频格式，主要是以下这些格式。

* AAC
* AMR (Adaptive multi-Rate，一种语音格式)
* ALAC (Apple lossless Audio Codec)
* iLBC (internet Low Bitrate Codec，另一种语音格式)
* IMA4 (IMA/ADPCM)
* linearPCM (uncompressed)
* u-law 和 a-law
* MP3 (MPEG-Laudio Layer 3)

#### AVAudioPlayer 的使用

首先，引入框架 AVFoundation 和 MediaPlayer

```objc
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
```

介绍一下常用方法：

1）AVAudioPlayer 初始化
```objc
initWithContentsOfURL: error: 
```
从URL加载音频，返回 AVAudioPlayer 对象

```objc
initWithData: error: 
```
加载NSdata对象的音频文件，返回 AVAudioPlayer 对象

2）AVAudioPlayer 方法调用
```objc
- (BOOL)play 
```
开始或恢复播放，调用该方法时，如果该音频还没有准备好，程序会转为执行 - (BOOL)prepareToPlay 方法

```objc
- (void)pause 
```
暂停

```objc
- (void)stop 
```
停止

```objc
- (BOOL)playAtTime:(NSTimeInterval)time NS_AVAILABLE(10_7, 4_0) 
```
在某个时间点播放

```objc
- (BOOL)prepareToPlay 
```
准备开始播放

```objc
- (void)updateMeters 
```
更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息

```objc
- (float)averagePowerForChannel:(NSUInteger)channelNumber 
```
获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法

3）使用 AVAudioPlayer 读取音频信息

```objc
volume 
```
播放器的音频增益，值：0.0～1.0

```objc
pan NS_AVAILABLE(10_7, 4_0) 
```
立体声设置 设为 －1.0 则左边播放 设为 0.0 则中央播放 设为 1.0 则右边播放

```objc
enableRate 
```
是否允许改变播放速率

```objc
rate NS_AVAILABLE(10_8, 5_0) 
```
播放速率 0.5 (半速播放) ～ 2.0(倍速播放) 注1.0 是正常速度

```objc
playing 
```
是否正在播放音频

```objc
numberOfLoops 
```
循环次数，如果要单曲循环，设置为负数

```objc
numberOfChannels 
```
该音频的声道次数 (只读)

```objc
duration 
```
该音频时长

```objc
currentTime 
```
该音频的播放点

```objc
deviceCurrentTime 
```
输出设备播放音频的时间，注意如果播放中被暂停此时间也会继续累加

```objc
url 
```
音频文件路径，只读

```objc
data 
```
音频数据，只读

```objc
channelAssignments 
```
获得或设置播放声道

4）代理方法

```objc
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag; 
```
音频播放完成

```objc
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error 
```
音频解码发生错误

```objc
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player 
```
如果音频被中断，比如有电话呼入，该方法就会被回调，该方法可以保存当前播放信息，以便恢复继续播放的进度

#### AVAudioPlayer 示例

1）素材资源
* 两个音频文件
* 两张专辑图片

2）代码实现
导入架包

```objc
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
```

必须持有一个 AVAudioPlayer 对象，若此对象不是属性，则无法播放

```objc
@property (nonatomic , strong) AVAudioPlayer *player;
```

获取制定 url 对象

```objc
NSURL *url = [[NSBundle mainBundle] URLForResource:@“dog" withExtension:@“wav"];
```

初始化 AVAudioPlayer 对象

```objc
self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
```

设置代理

```objc
self.player.delegate = self;
```

这样就播放器就初始化完成了

开始播放按钮事件

```objc
    if ([self.player isPlaying]) {
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:0];
        [self.player pause];
    } else {
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:0];
        [self.player play];
    }
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
```

定义了一个 NSTimer 变量，因为播放器没有播放进程的委托，所以只能自定义NSTimer变量对播放器进行监控，用于显示播放进度

```objc
- (void)updateProgress {
    //进度条显示播放进度
    self.progress.progress = self.player.currentTime/self.player.duration;
    self.info1.text = [NSString stringWithFormat:@"当前播放时间%f",self.player.currentTime];
}
```

停止播放按钮事件

```objc
    [self.player stop];
    //计时器停止
    [_timer invalidate];
    //释放定时器
    _timer = nil;
```

AVAudioPlayer 代理方法实现

```objc
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == _player && flag) {
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:0];
    }
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    if (player == _player) {
        NSLog(@"播放被中断");
    }
}
```

在播放完成时响应回调和播放中被系统高优先级事件打断时响应回调。

3）其他功能

* 后台播放

在项目里 info.plist 中设置权限

```
<key>UIBackgroundModes</key>
    <array>
        <string>audio</string>
    </array>
```

代码里面也要添加后台播放支持

```objc 
//设置锁屏仍能继续播放
[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
[[AVAudioSession sharedInstance] setActive: YES error: nil];
``` 

这样音乐在后台就可以播放了！

* 监听播放设备

那么很多播放器都有一个功能，那就是在用户拔掉耳机的时候，暂停播放

```objc 
//添加通知，拔出耳机后暂停播放
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self.player pause];
        }
    }
}
```
这样就能在拔掉耳机的时候，暂停播放了！

* 定制锁屏界面

设置后台播放时显示的东西，例如歌曲名字，图片等

要用到 <MediaPlayer/MediaPlayer.h> 这个库，刚才已经导入过

```objc 
- (void)setPlayingInfo {
    //    设置后台播放时显示的东西，例如歌曲名字，图片等
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"吴亦凡.jpg"]];
    
    NSDictionary *dic = @{MPMediaItemPropertyTitle:@"时间煮雨",
                          MPMediaItemPropertyArtist:@"吴亦凡",
                          MPMediaItemPropertyArtwork:artWork
                          };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}
```

这样，图片就在锁屏界面显示了

要响应锁屏界面上面的三个按钮，需要在一个继承 UIResponder 类里面接收远程控制，添加如下代码，接受远程控制和取消远程控制：

```objc 
- (void)viewDidAppear:(BOOL)animated {
    //    接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    //    取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
```

接收方法设置

```objc 
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
                if (![_player isPlaying]) {
                    [_player play];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                if ([_player isPlaying]) {
                    [_player pause];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                break;
            default:
                break;
        }
    }
}
```

### AVAudioPlayer 的剪辑、合成和压缩转码

#### 剪辑

场景：将路径 filePath 下的音频文件从 time 截取到 time2 后在 resultPath 中输出

AVURLAsset 是 AVAsset 的子类,AVAsset 类专门用于获取多媒体的相关信息,包括获取多媒体的画面、声音等信息.

这里通过 AVURLAsset 子类来根据 NSURL 来初始化 AVAsset 对象.

```objc
AVURLAsset *videoAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
```

通过 AVAssetExportSession 的 exportSessionWithAsset 方法进行剪辑，需要配置输出路径、文件类型和截取时间段参数

```objc
//音频输出会话并且是.m4a格式
AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:videoAsset presetName:AVAssetExportPresetAppleM4A];
// 设置输出路径
exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
// 文件类型 
exportSession.outputFileType = AVFileTypeAppleM4A;
// 截取时间段
exportSession.timeRange = CMTimeRangeFromTimeToTime(CMTimeMake(time1, 1), CMTimeMake(time2, 1));
[exportSession exportAsynchronouslyWithCompletionHandler:^{
    //exporeSession.status
}];
```

#### 合成

场景：将路径 filePath1 和路径 filePath2 下的音频合成

先来根据 URL 初始化两个 AVAsset 对象，我们将要合成这两段音频

```objc
AVURLAsset *videoAsset1 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath1] options:nil];
AVURLAsset *videoAsset2 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath2] options:nil];
```

创建对应的音频轨迹

```objc
AVAssetTrack *assetTrack1 = [[videoAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
AVAssetTrack *assetTrack2 = [[videoAsset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
```

> 一般视频至少有2个轨道,一个播放声音,一个播放画面。音频只有声音通道

通过 AVMutableComposition 来进行合成处理

```objc
AVMutableComposition *composition = [AVMutableComposition composition];
AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
// 把第二段录音添加到第一段后面
[compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset1.duration) ofTrack:assetTrack1 atTime:kCMTimeZero error:nil];
[compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset2.duration) ofTrack:assetTrack2 atTime:videoAsset1.duration error:nil];
```

最后将合成的音频（视频）输出

```objc
AVAssetExportSession *exporeSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
exporeSession.outputFileType = AVFileTypeAppleM4A;
exporeSession.outputURL = [NSURL fileURLWithPath:resultPath];
[exporeSession exportAsynchronouslyWithCompletionHandler:^{
    //exporeSession.status
}];
```

#### 压缩转码

压缩转码需要用到 LAME (Lame Aint an MP3 Encoder)，下载链接：https://sourceforge.net/projects/lame/files/lame/

![](http://og1yl0w9z.bkt.clouddn.com/18-5-31/3758149.jpg)

下载解压后将文件夹命名为 lame，否则无法生成.h和.m文件

控制台进入文件目录，运行命令

```
$:cd cd /Users/mac/Desktop/lame
//创建build_lame.sh
$:touch build_lame.sh
//打开build_lame.sh,粘贴脚本代码
$:open build_lame.sh
//编译执行脚本,生成静态库,需要输入本机密码
$:sudo sh build_lame.sh
```

![](http://og1yl0w9z.bkt.clouddn.com/18-5-31/78735245.jpg)

将fat-lame文件夹下的include文件夹和lib文件夹放入工程,再写一个OC的类调用lame.h

```objc
@try {
    int read, write;
    FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");//被转换的音频文件位置
    fseek(pcm, 4*1024, SEEK_CUR);
    FILE *mp3 = fopen([resultPath cStringUsingEncoding:1], "wb");//生成的Mp3文件位置

    const int PCM_SIZE = 8192;
    const int MP3_SIZE = 8192;
    short int pcm_buffer[PCM_SIZE*2];
    unsigned char mp3_buffer[MP3_SIZE];

    // 初始化lame编码器
    lame_t lame = lame_init();
    // 设置lame mp3编码的采样率 / 声道数 / 比特率
    lame_set_in_samplerate(lame, 8000);
    lame_set_num_channels(lame,2);
    lame_set_out_samplerate(lame, 8000);
    lame_set_brate(lame, 8);
    // MP3音频质量.0~9.其中0是最好,非常慢,9是最差.
    lame_set_quality(lame, 7);

    // 设置mp3的编码方式
    lame_set_VBR(lame, vbr_default);
    lame_init_params(lame);

    do {
        size_t size = (size_t)(2 * sizeof(short int));
        read = fread(pcm_buffer, size, PCM_SIZE, pcm);
        if (read == 0) {
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        } else {
            write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
        }
        fwrite(mp3_buffer, write, 1, mp3);

    } while (read != 0);

    lame_close(lame);
    fclose(mp3);
    fclose(pcm);
}
@catch (NSException *exception) {
    NSLog(@"%@",[exception description]);
}
@finally {
    // 转码完成
    return resultPath;
}
```

基本上可以将100K左右的录音文件压缩到10K以下

![](http://og1yl0w9z.bkt.clouddn.com/18-5-31/66705749.jpg)

### AVPlayer

AVPlayer支持播放本地、分步下载、或在线流媒体音视频，不仅可以播放音频，配合AVPlayerLayer类可实现视频播放。另外支持播放进度监听。

使用AVPlayer需导入AVFoundation.h

```objc
#import <AVFoundation/AVFoundation.h>
```

支持视频格式： WMV，AVI，MKV，RMVB，RM，XVID，MP4，3GP，MPG等。

支持音频格式：MP3，WMA，RM，ACC，OGG，APE，FLAC，FLV等。

> 在开发中，单纯使用AVPlayer类是无法显示视频的，要将视频层添加至AVPlayerLayer中，这样才能将视频显示出来

介绍一下常用方法：

1）AVPlayer 初始化

```objc
+ (instancetype)playerWithURL:(NSURL *)URL;

+ (instancetype)playerWithPlayerItem:(AVPlayerItem *)item;

- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)initWithPlayerItem:(AVPlayerItem *)item;
```

2）AVPlayer 方法调用
AVPlayer需要通过AVPlayerItem来关联需要播放的媒体。

```objc
AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
```

准备播放前，通过KVO添加播放状态改变监听

```objc
[self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
```

处理KVO回调事件：

```objc
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown: {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay: {
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:  {
                NSLog(@"加载失败");
            }
                break;
            default:
                break;
        }
    }
}
```

KVO监听音乐缓冲状态：

```objc
[self.player.currentItem addObserver:self
                          forKeyPath:@"loadedTimeRanges"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
```

监听事件处理

```objc
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //...
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {

        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
        //        self.loadTimeProgress.progress = scale;
    }
}
```

开始播放后，通过KVO添加播放结束事件监听

```objc
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(playFinished:)
                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                           object:_player.currentItem];
```

开始播放时，通过AVPlayer的方法监听播放进度，并更新进度条（定期监听的方法）：

```objc
__weak typeof(self) weakSelf = self;
[self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    //当前播放的时间
    float current = CMTimeGetSeconds(time);
    //总时间
    float total = CMTimeGetSeconds(item.duration);
    if (current) {
        float progress = current / total;
        //更新播放进度条
        weakSelf.playSlider.value = progress;
    }
}];
```

用户拖动进度条，修改播放进度

```objc
- (void)playSliderValueChange:(UISlider *)sender {
    //根据值计算时间
    float time = sender.value * CMTimeGetSeconds(self.player.currentItem.duration);
    //跳转到当前指定时间
    [self.player seekToTime:CMTimeMake(time, 1)];
}
```

3）其他用法

* 控制视频的进度
使用懒加载的方式，将进度条添加到View上面

```objc
- (UISlider *)avSlider{
    if (!_avSlider) {
        _avSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 55, self.view.bounds.size.width, 30)];
        [self.view addSubview:_avSlider];
    }return _avSlider;
}
```

在viewDidLoad中个slider（进度条）添加一个回调

```objc
[self.avSlider addTarget:self action:@selector(avSliderAction) forControlEvents:
UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
```

回调方法

```objc
- (void)avSliderAction {
    //slider的value值为视频的时间
    float seconds = self.avSlider.value;
    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.item.currentTime.timescale);
    //让视频从指定处播放
    [self.myPlayer seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self playAction];
        }
    }];
}
```

* 后台播放
首先 info.plist 文件中设置权限

```
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

在AppDelegate.m的- (BOOL)application:didFinishLaunchingWithOptions:方法中添加代码：

```objc
AVAudioSession *session = [AVAudioSession sharedInstance];
[session setCategory:AVAudioSessionCategoryPlayback error:nil];
[session setActive:YES error:nil];
```

* 锁屏信息
Now Playing Center并不需要每一秒都去刷新（设置），它是根据你设置的PlaybackRate来计算进度条展示的进度，比如你PlaybackRate传1，那就是1秒刷新一次进度显示，当然暂停播放的时候它也会自动暂停。

```objc
- (void)configNowPlayingCenter {    
    BASE_INFO_FUN(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //音乐的标题
    [info setObject:_player.currentSong.title forKey:MPMediaItemPropertyTitle];
     //音乐的艺术家
    [info setObject:_player.currentSong.artist forKey:MPMediaItemPropertyArtist];
     //音乐的播放时间
    [info setObject:@(self.player.playTime.intValue) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
     //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
     //音乐的总时间
    [info setObject:@(self.player.playDuration.intValue) forKey:MPMediaItemPropertyPlaybackDuration];
     //音乐的封面
    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:_player.coverImg];
    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
     //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
}
```
那什么时候设置Now Playing Center比较合适呢？对于播放网络音乐来说，需要刷新的有几个时间点：当前播放的歌曲变化时（如切换到下一首）、当前歌曲信息变化时（如从Unknown到ReadyToPlay）、当前歌曲拖动进度时。

* 耳机线控或者锁屏界面控制
先引入头文件

```objc
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>
```

在需要处理远程控制事件的具体控制器或其它类中调用下面这个方法

```objc
- (void)remoteControlEventHandler {
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];

// 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
commandCenter.playCommand.enabled = YES;
// 为播放命令添加响应事件, 在点击后触发
[commandCenter.playCommand addTarget:self action:@selector(playAction:)];

// 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
// 为暂停, 上一曲, 下一曲分别添加对应的响应事件
[commandCenter.pauseCommand addTarget:self action:@selector(pauseAction:)];
[commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction:)];
[commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction:)];

// 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
commandCenter.togglePlayPauseCommand.enabled = YES;
// 为耳机的按钮操作添加相关的响应事件
[commandCenter.togglePlayPauseCommand addTarget:self action:@selector(playOrPauseAction:)];
}

-(void)playAction:(id)obj {
    [[HYPlayerTool sharePlayerTool] play];
}
-(void)pauseAction:(id)obj {
    [[HYPlayerTool sharePlayerTool] pause];
}
-(void)nextTrackAction:(id)obj {
    [[HYPlayerTool sharePlayerTool] playNext];
}
-(void)previousTrackAction:(id)obj {
    [[HYPlayerTool sharePlayerTool] playPre];
}
-(void)playOrPauseAction:(id)obj {
    if ([[HYPlayerTool sharePlayerTool] isPlaying]) {
        [[HYPlayerTool sharePlayerTool] pause];
    }else{
        [[HYPlayerTool sharePlayerTool] play];
    }
}
```

### AVQueuePlayer

AVPlayer只支持单个媒体资源的播放，我们可以使用AVPlayer的子类AVQueuePlayer实现列表播放。

在AVPlayer的基础上，增加以下方法：

```objc
//通过给定的AVPlayerItem数组创建一个AVQueuePlayer实例
+ (instancetype)queuePlayerWithItems:(NSArray<AVPlayerItem *> *)items;

//通过给定的AVPlayerItem数组初始化AVQueuePlayer实例
- (AVQueuePlayer *)initWithItems:(NSArray<AVPlayerItem *> *)items;

//获得当前的播放队列数组
- (NSArray<AVPlayerItem *> *)items;

//停止播放当前音乐，并播放队列中的下一首
- (void)advanceToNextItem;

//往播放队列中插入新的AVPlayerItem
- (void)insertItem:(AVPlayerItem *)item afterItem:(nullable AVPlayerItem *)afterItem;

//从播放队列中移除指定AVPlayerItem
- (void)removeItem:(AVPlayerItem *)item;

//清空播放队列
- (void)removeAllItems;
```

官方API中没找到播放上一首的方法，所以其实直接用AVPlayer做列表播放也是可以的，通过维护一个播放列表数组，监听用户点击上一首和下一首按钮，并监听播放结束事件，调用 AVPlayer 实例的replaceCurrentItemWithPlayerItem:方法传入播放列表中的上一首或下一首。

### AVPlayer 的缓存实现

这里主要展示通过AVAssetResourceLoader实现AVPlayer的缓存。

没有任何工具能适用于所有的场景，在使用AVPlayer的过程中，我们会发现它有很多局限性，比如播放网络音乐时，往往不能控制其内部播放逻辑，比如我们会发现播放时seek会失败，数据加载完毕后不能获取到数据文件进行其他操作，因此我们需要寻找弥补其不足之处的方法，这里我们选择了AVAssetResourceLoader。

#### AVAssetResourceLoader

AVAssetResourceLoader 可以让我们自行掌握AVPlayer数据的加载，包括获取AVPlayer需要的数据的信息，以及可以决定传递多少数据给AVPlayer。

![](http://og1yl0w9z.bkt.clouddn.com/18-5-31/46572521.jpg)

实现原理：

AVAssetResourceLoader 通过对 loadingRequest 的控制，间接控制 AVPlayer 数据的加载等操作。

使用AVAssetResourceLoader需要实现AVAssetResourceLoaderDelegate的方法：

```objc
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest;
```

要求加载资源的代理方法，这时我们需要保存loadingRequest并对其所指定的数据进行读取或下载操作，当数据读取或下载完成，我们可以对loadingRequest进行完成操作。

```objc
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;
```

实现策略：

通过AVAssetResourceLoader实现缓存的策略有多种，没有绝对的优与劣，只要符合我们的实际需求就可以了。

下面我们以模仿企鹅音乐的来演示AVAssetResourceLoader实现缓存的过程为例子。

![](http://og1yl0w9z.bkt.clouddn.com/18-5-31/89977843.jpg)

先观察并猜测企鹅音乐的缓存策略（当然它不是用AVPlayer播放）：

1、开始播放，同时开始下载完整的文件，当文件下载完成时，保存到缓存文件夹中；

2、当seek时

（1）如果seek到已下载到的部分，直接seek成功；（如下载进度60%，seek进度50%）

（2）如果seek到未下载到的部分，则开始新的下载（如下载进度60%，seek进度70%）

PS1：此时文件下载的范围是70%-100%

PS2：之前已下载的部分就被删除了

PS3：如果有别的seek操作则重复步骤2，如果此时再seek到进度40%，则会开始新的下载（范围40%-100%）

3、当开始新的下载之后，由于文件不完整，下载完成之后不会保存到缓存文件夹中；

4、下次再播放同一歌曲时，如果在缓存文件夹中存在，则直接播放缓存文件；

代码实现：

通过自定义scheme来创建avplayer，并给AVURLAsset指定代理（SUPlayer对象）

```objc
AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[self.url customSchemeURL] options:nil];
[asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
self.currentItem = [AVPlayerItem playerItemWithAsset:asset];
self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
```

代理实现AVAssetResourceLoader的代理方法（SUResourceLoader对象）

```objc
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self addLoadingRequest:loadingRequest];
    return YES;
}
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self removeLoadingRequest:loadingRequest];
}
```

对loadingRequest的处理（addLoadingRequest方法）:

1）将其加入到requestList中

```objc
[self.requestList addObject:loadingRequest];
```

2）如果还没开始下载，则开始请求数据，否则静待数据的下载

```objc
[self newTaskWithLoadingRequest:loadingRequest cache:YES];
```

3）如果是seek之后的loadingRequest，判断请求开始的位置，如果已经缓冲到，则直接读取数据

```objc
if (loadingRequest.dataRequest.requestedOffset >= self.requestTask.requestOffset &&
    loadingRequest.dataRequest.requestedOffset <= self.requestTask.requestOffset + self.requestTask.cacheLength) {
    [self processRequestList];
}
```

4）如果还没缓冲到，则重新请求

```objc
if (self.seekRequired) {
    [self newTaskWithLoadingRequest:loadingRequest cache:NO];
}
```

4、数据请求的处理（newTaskWithLoadingRequest方法）

1）先判断是否已经有下载任务，如果有，则先取消该任务

```objc
if (self.requestTask) {
    fileLength = self.requestTask.fileLength;
    self.requestTask.cancel = YES;
}
```

2）建立新的请求，设置代理

```objc
self.requestTask = [[SURequestTask alloc]init];
self.requestTask.requestURL = loadingRequest.request.URL;
self.requestTask.requestOffset = loadingRequest.dataRequest.requestedOffset;
self.requestTask.cache = cache;
if (fileLength > 0) {
    self.requestTask.fileLength = fileLength;
}
self.requestTask.delegate = self;
[self.requestTask start];
self.seekRequired = NO;
```

5、数据响应的处理（processRequestList方法）

对requestList里面的loadingRequest填充响应数据，如果已完全响应，则将其从requestList中移除

```objc
- (void)processRequestList {
NSMutableArray * finishRequestList = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest * loadingRequest in self.requestList) {
    if ([self finishLoadingWithLoadingRequest:loadingRequest]) {
        [finishRequestList addObject:loadingRequest];
        }
    }
    [self.requestList removeObjectsInArray:finishRequestList];
}
```

填充响应数据的过程如下：

1）填写 contentInformationRequest的信息，注意contentLength需要填写下载的文件的总长度，contentType需要转换

```objc
CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(MimeType), NULL);
loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
loadingRequest.contentInformationRequest.contentLength = self.requestTask.fileLength;
```

2）计算可以响应的数据长度，注意数据读取的起始位置是当前avplayer当前播放的位置，结束位置是loadingRequest的结束位置或者目前文件下载到的位置

```objc
NSUInteger cacheLength = self.requestTask.cacheLength;
NSUInteger requestedOffset = loadingRequest.dataRequest.requestedOffset;
if (loadingRequest.dataRequest.currentOffset != 0) {
    requestedOffset = loadingRequest.dataRequest.currentOffset;
}
NSUInteger canReadLength = cacheLength - (requestedOffset - self.requestTask.requestOffset);
NSUInteger respondLength = MIN(canReadLength, loadingRequest.dataRequest.requestedLength);
```

3）读取数据并填充到loadingRequest

```objc
[loadingRequest.dataRequest respondWithData:[SUFileHandle readTempFileDataWithOffset:requestedOffset - self.requestTask.requestOffset length:respondLength]];
```

4） 如果完全响应了所需要的数据，则完成loadingRequest，注意判断的依据是 响应数据结束的位置 >= loadingRequest结束的位置

```objc
NSUInteger nowendOffset = requestedOffset + canReadLength;
NSUInteger reqEndOffset = loadingRequest.dataRequest.requestedOffset + loadingRequest.dataRequest.requestedLength;
if (nowendOffset >= reqEndOffset) {
    [loadingRequest finishLoading];
    return YES;
}
return NO;
```

6、处理requestList的时机

当有新的loadingRequest或者文件下载进度更新时，都需要处理requestList

7、新的请求任务实现的过程（SURequestTask对象）

1）初始化时，需要删除旧的临时文件，并创建新的空白临时文件

```objc
- (instancetype)init {
if (self = [super init]) {
        [SUFileHandle createTempFile];
    }
    return self;
}
```

2）建立新的连接，如果是seek后的请求，则指定其请求内容的范围

```objc
- (void)start {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[self.requestURL originalSchemeURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeout];
    if (self.requestOffset > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld", self.requestOffset, self.fileLength - 1] forHTTPHeaderField:@"Range"];
    }
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}
```

3）当收到数据时，将数据写入临时文件，更新下载进度，同时通知代理处理requestList

```objc
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (self.cancel) return;
    [SUFileHandle writeTempFileData:data];
    self.cacheLength += data.length;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidUpdateCache)]) {
        [self.delegate requestTaskDidUpdateCache];
    }
}
```

4）当下载完成时，如果满足缓存的条件，则将临时文件拷贝到缓存文件夹中

```objc
if (self.cache) {
    [SUFileHandle cacheTempFileWithFileName:[NSString fileNameWithURL:self.requestURL]];
}
if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidFinishLoadingWithCache:)]) {
    [self.delegate requestTaskDidFinishLoadingWithCache:self.cache];
}
```

缓存功能优化点：

* 1.对缓存格式支持的处理：并不是所有文件格式都支持的哦，对于不支持的格式，你应该不使用缓存功能；

* 2.对缓存过程中各种错误的处理：比如下载超时、连接失败、读取数据错误等等的处理；

* 3.缓存文件的命名处理，如果缓存文件没有后缀（如.mp4），可能会导致播放失败；

### 发掘 AVPlayer 的潜力

音频播放的实现级别：
* 离线播放：这里并不是指应用不联网，而是指播放本地音频文件，包括先下完完成音频文件再进行播放的情况，这种使用AVFoundation里的AVAudioPlayer可以满足
* 在线播放：使用AVFoundation的AVPlayer可以满足
* 在线播放同时存储文件：使用AudioFileStreamer ＋ AudioQueue 可以满足
* 在线播放且带有音效处理：使用 AudioFileStreamer ＋ AudioQueue ＋ 音效模块（系统自带或者自行开发）来满足

未完待续，AVFoundation 体系太大，慢慢整理 🤣

> 以上文章整理自：https://www.jianshu.com/p/589999e53461、https://blog.csdn.net/zahuopuboss/article/details/54862749、https://blog.csdn.net/feng2qing/article/details/67655175、https://blog.csdn.net/dolacmeng/article/details/77430108、https://www.jianshu.com/p/746cec2c3759、http://www.cocoachina.com/ios/20160726/17194.html、https://www.jianshu.com/p/c48195126040
