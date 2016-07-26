在已有iOS项目中加入React Native能力

React Native背景
What we really want is the user experience of the native mobile platforms, combined with the developer experience we have when building with React on the web.
上面的这段话摘自《Introducing React Native》，加粗的关键字传达了React Native的设计理念：既拥有Native的用户体验，又保留React的开发效率。这个理念迎合了业界普遍存在的痛点，开源不到一周github star过万

It's worth noting that we're not chasing “write once, run anywhere.” Different platforms have different looks, feels, and capabilities, and as such, we should still be developing discrete apps for each platform, but the same set of engineers should be able to build applications for whatever platform they choose, without needing to learn a fundamentally different set of technologies for each. We call this approach “learn once, write anywhere.”
上面的这段话也是摘自《Introducing React Native》，在软件开发中最理想的情况是像Java这样“write once, run anywhere”，但是不同的平台有不同的用户体验(looks, feels, and capabilities)，过分要求应用在不同的平台上的一致性是不太合适的。React Native提出了一种理念，learn once, write anywhere， 可以在不同平台上编写基于React的代码。

开发环境配置
1.需要一台Mac(OSX)，上面要安装Xcode(建议Xcode7及以上的版本)，Xcode可以在Mac App Store下载

2.安装Homebrew，后面安装Watchman和Flow推荐使用Homebrew安装

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

如果之前安装过Homebrew，可以先更新下：

brew update && brew upgrade

3.安装node.js

(1)安装nvm(Node Version Manager)

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash

(2)安装最新版本的Node.js

nvm install node && nvm alias default node

当然可以直接到Node.js官网下载dmg文件直接安装，下载地址是https://nodejs.org/download/

4.建议安装watchman：

brew install watchman

5.安装flow：

brew install flow

ok，按照以上步骤，你应该已经配置好了环境。

在现有项目中集成
1.CocoaPods
推荐使用CocoaPods的方式进行集成，如果没有使用过，可以参考《使用CocoaPods管理iOS项目中的依赖库》这篇文章安装配置。

2.安装react-native package
react native现在使用npm的方式进行安装

(1)如果没有安装Node.js,需要按照前面的方式进行安装

(2)安装完Node.js之后再项目根目录(.xcodeproj文件所在目录)下执行npm install react-native的命令，执行完成之后会创建一个node_modules的文件夹。

3.修改Podfile配置
在项目根目录下的Podfile（如果没有该文件可以使用pod init命令生成）文件中加入如下代码：
pod 'React', '~> 0.13.0-rc'
pod 'React/Core', '~> 0.13.0-rc'
pod 'React/ART', '~> 0.13.0-rc'
pod 'React/RCTActionSheet', '~> 0.13.0-rc'
pod 'React/RCTAdSupport', '~> 0.13.0-rc'
pod 'React/RCTGeolocation', '~> 0.13.0-rc'
pod 'React/RCTImage', '~> 0.13.0-rc'
pod 'React/RCTNetwork', '~> 0.13.0-rc'
pod 'React/RCTPushNotification', '~> 0.13.0-rc'
pod 'React/RCTSettings', '~> 0.13.0-rc'
pod 'React/RCTText', '~> 0.13.0-rc'
pod 'React/RCTVibration', '~> 0.13.0-rc'
pod 'React/RCTWebSocket', '~> 0.13.0-rc'
pod 'React/RCTLinkingIOS', '~> 0.13.0-rc'

如果你在项目中使用了<Text>的组件，那么你必须添加RCTText的subspecs。配置完成之后执行pod install即可。

4.编写React Native代码
(1)在项目的根目录创建存放React Native代码的目录：

mkdir ReactComponent
(2)新建一个示例的index.ios.js的代码

touch ReactComponent/home.ios.js

home.ios.js文件内容，示例如下：
'use strict';

import React, {
  AppRegistry,
  Component,
  StyleSheet,
  Text,
  TextInput,
  View,
  ListView,
  Image,
} from 'react-native'

var BASE_URL = 'https://api.github.com/search/repositories?q='

export default class RNDemo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      dataSource: new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2,
      })
    };
  }

  render() {
    return (
      <View style={styles.container}>
        <TextInput
          autoCapitalize='none'
          autoCorrect={false}
          placeholder='Search for a projext...'
          style={styles.searchBarInput}
          onEndEditing={e=>this.handleSearchChange(e)}>
        </TextInput>
        {this.renderListView()}
      </View>
    );
  }

  renderListView() {
    var content
    if (this.state.dataSource.getRowCount() === 0) {
      content = (
        <Text style={styles.blankText}>Please enter a search term to see results.</Text>
      )
    } else {
      content = (
        <ListView
          style={styles.listView}
          ref='listView'
          dataSource={this.state.dataSource}
          renderRow={this.renderRow}></ListView>
      )
    }
    return content
  }
  renderRow(repo) {
    return (
      <View>
        <View style={styles.row}>
          <Image
            source={{uri: repo.owner.avatar_url}}
            style={styles.profpic}></Image>
          <View style={styles.textContainer}>
            <Text style={styles.title}>{repo.name}</Text>
            <Text style={styles.subTile}>{repo.owner.login}</Text>
          </View>
        </View>
        <View style={styles.cellBorder} />
      </View>
    )
  }

  // action
  handleSearchChange(e) {
    var searchTerm = e.nativeEvent.text.toLowerCase()
    var queryURL = BASE_URL + encodeURIComponent(searchTerm)
    fetch(queryURL)
      .then((response) => response.json())
      .then((responseData) => {
        if (responseData.items) {
          console.log(responseData)
          this.setState({
            dataSource: this.state.dataSource.cloneWithRows(responseData.items),
          })
        }
    })
    .done()
  }
}

var styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  listView: {
    // flex: 1,
  },
  searchBarInput: {
    marginTop: 30,
    padding: 10,
    fontSize: 12,
    height: 30,
    backgroundColor: '#EAEAEA',
  },
  row: {
    width: 200,
    alignItems: 'center',
    backgroundColor: 'white',
    flexDirection: 'row',
    padding: 5,
  },
  // cell
  profpic: {
    width: 50,
    height: 50,
  },
  title: {
    fontSize: 20,
    marginBottom: 8,
    fontWeight: 'bold',
  },
  subTile: {
    fontSize: 16,
    marginBottom: 8,
  },
  textContainer: {
    paddingLeft: 10,
  },
  cellBorder: {
    backgroundColor: 'rgba(0, 0, 0, 0.1)',
    height: 1,
    marginLeft: 4,
  },
  blankText: {
    padding: 10,
    fontSize: 20,
  },
})

React.AppRegistry.registerComponent('RNDemo', () => RNDemo);

RNDemo即为你的Module Name,在后面会使用到。

5.在项目中加载React Native代码
React Native不是通过UIWebView的方式进行代码的加载，而是使用了RCTRootView自定义的组件。RCTRootView提供了一个初始化的方法，支持在初始化视图组件的时候加载React的代码。

- (instancetype)initWithBundleURL:(NSURL *)bundleURL
                       moduleName:(NSString *)moduleName
                initialProperties:(NSDictionary *)initialProperties
                    launchOptions:(NSDictionary *)launchOptions;

使用方式如下：
    NSURL *jsCodeLocation = [ NSURL URLWithString:@"http://localhost:8081/ReactComponent/home.ios.bundle?platform=ios&dev=true"];
                              
    RCTRootView  *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                         moduleName:@"RNDemo" initialProperties:nil launchOptions:nil];
    rootView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-49);
    [self.view addSubview:rootView];

需要指出的是在初始化的时候支持通过URL的方式进行加载，上面的方法是在线的服务器地址使用在发布环境下替换localhost为正式服务器的地址，另外一个是Bundle的路径地址,示例如下：

NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
为了生成jsbundle文件，可以通过下面的命令：

curl http://localhost:8081/ReactComponent/home.ios.bundle -o main.jsbundle

6.启动Development Server
终端进入项目所在根目录，执行下面的代码

(JS_DIR=`pwd`/ReactComponent; cd Pods/React; npm run start -- --root $JS_DIR)
启动完成之后可以通过：http://localhost:8081/ReactComponent/home.ios.bundle进行调用



