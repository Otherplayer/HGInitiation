# HGInitiation


### 0. 运行 
> pod install

### 1. 代码规范 【 逻辑清晰，代码整洁，零警告 】

总则

```

1.Don’t repeat your self.

2.代码自注释，依靠代码本身来表达你的设计意图，不要依赖注释。

3.单一指责，无论是类、函数、模块、包尽可能令其指责纯净且单一。

4.死程序不说谎，不要因为防止Crash写奇葩的代码。程序Crash了，反而更容易查找错误。

5.借用美国童子军军规：让营地比你来时更干净。

```
详细参阅

[StyleGuide](https://github.com/google/styleguide/blob/gh-pages/objcguide.md)


### 2. 工程结构 Project Structure

```

.
├── Vendors/                                # Third-party libraries and file
│   ├── CNPPopupController/                 # a simple and versatile class for presenting a custom popup in a variety of fashions.
│   ├── CHTCollectionViewWaterfallLayout/   # the waterfall layout for UICollectionView.
│   └── ...
├── Resources/                              # Main project resources
│   └── ...
├── General/                                # General functions    
│   ├── Core/                               # some general configuration. eg: theme
│   ├── Theme/                              # theme
│   ├── Categories/                         # categories
│   │   └── ...
│   ├── Compontents/                        # UI components
│   │   ├── HUD/                            # 
│   │   ├── Popover/                        # 
│   │   ├── PagesScroll/                    # 
│   │   ├── Popup/                          # 
│   │   ├── PageController/                 # 
│   │   ├── ViewUtils/                      # 
│   │   ├── PhotoBrowser/                   # 
│   │   ├── ImagePicker/                    # 
│   │   ├── ScrollView/                     # 
│   │   ├── WebView/                        # 
│   │   ├── TextField/                      # 
│   │   ├── TextView/                       # 
│   │   ├── Picker/                         # 
│   │   ├── AvatarClipper/                  # 
│   │   └── ...
│   └── Base/                               # Base class
│   │   ├── HGBASEViewController                     
│   │   ├── HGBASETabBarController                        
│   │   ├── HGBASENavigationController                
│   │   └── ...
├── Helpers/
│   ├── HGHelperFPS                     
│   └── ...
├── Macro/
│   └── ...
├── Network/                                # Network
│   ├── service/                            
│   │   └── ...
│   └── HGHTTPClient                        # client
├── Sections/                               # Project Sections
│   └── Login/                              # login
│   │   ├── HGLoginController.swift         
│   │   └── HGRegisterController.swift      
│   └── Settings/                           # Settings
│   │   ├── HGSettingsController           
│   │   └── ...            
├── AppDelegate                             
├── Main.storyboard                         # not use
├── Login.storyboard                         
├── LaunchScreen.storyboard                  
├── Assets.xcassets                         
├── Info.plist                              
├── PrefixHeader.pch                        # app global pch file
├── main.m                                  
└── HGInitiation-Bridging-Header.h          # swift bridging header


```


### System colors

![SystemColors](https://github.com/Otherplayer/HNAGithubEmojis/raw/master/HGInitiation/Resources/system-colors.jpeg "System Colors")








