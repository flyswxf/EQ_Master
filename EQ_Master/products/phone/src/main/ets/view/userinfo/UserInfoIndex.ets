import { http } from '@kit.NetworkKit' // 向后端发送请求
import { BusinessError } from '@kit.BasicServicesKit';

// import {userInfo} from './User'
import { preferences } from '@kit.ArkData';
import PreferenceModel from '../../model/PreferenceModel';
// 使用与Server端相同的UserInfo格式
//TODO 改成userInfo
import {UserInfo} from '../../server/user/UserData';
import UserServer from '../../server/user/UserServer'
import Logger from '../../common/utils/Logger';
import ResponseResult from '../../server/ResponseResult';
import PromptUtil from '../../common/utils/PromptUtil';
import { CommonConstants } from '../../common/constants/CommonConstants';


// TODO ：页面完善（个性签名等等）【后面是AI自己提示的，说明任重道远呀朋友】这个页面需要修改，需要添加一个修改头像的功能，并且需要修改用户信息，并且需要修改用户名，并且需要修改用户签名，并且需要修改用户密码，并且需要修改用户邮箱，并且需要修改用户手机号，并且需要修改用户性别，并且需要修改用户生日，并且需要修改用户地址，并且需要修改用户简介，并且需要修改用户头像，并且需要修改用户签名，并且需要修改用户密码

// 主标题（Headline）
@Extend(Text) function Headline () {
  .fontWeight(FontWeight.Bold) // 粗体
  .fontSize(32) // 字体大小32px
}

// 副标题（Subheadline）
@Extend(Text) function Subheadline () {
  .fontWeight(FontWeight.Medium) // 中等粗细
  .fontSize(20) // 字体大小20px
}

// 正文文本（Body Text）
@Extend(Text) function BodyText () {
  .fontWeight(FontWeight.Normal) // 正常粗细
  .fontSize(16) // 字体大小16px
}

// 次要文本（Secondary Text）
@Extend(Text) function SecondaryText () {
  .fontWeight(FontWeight.Normal) // 正常粗细
  .fontSize(14) // 字体大小14px
}

// 辅助文本（Caption）
@Extend(Text) function Caption () {
  .fontWeight(FontWeight.Lighter) // 字体较细
  .fontSize(12) // 字体大小12px
}

// 强调文本（Emphasis Text）
@Extend(Text) function EmphasisText () {
  .fontWeight(FontWeight.Bold) // 强调使用粗体
  .fontSize(18) // 字体大小18px
}

// 加粗次要文本（Bold Secondary Text）
@Extend(Text) function BoldSecondaryText () {
  .fontWeight(FontWeight.Medium) // 中等粗细
  .fontSize(14) // 字体大小14px
}

// 小标题（Small Headline）
@Extend(Text) function SmallHeadline () {
  .fontWeight(FontWeight.Bold) // 粗体
  .fontSize(24) // 字体大小24px
}

@Component
struct userImage {//个人主页顶部部分
  @Prop UserInfo:UserInfo
  @Consume('pageInfos') pageInfos:NavPathStack
  @Consume nameList:string[]
  private fontColor:string = '#c4d2fa'

  build() {
    Column() {
      Column() {

        Text('个人主页')
          .Subheadline()
          .fontColor(this.fontColor)
          .height('30%')

        Image($r('app.media.login_logo'))
          .height('40%')
          .borderRadius(24)
            //这是为了设置边框
          .padding(3)
          .borderStyle(BorderStyle.Solid)
          .borderWidth(2)
          .borderColor('#FFFFFF')
            //
          .onError(() => {
            console.info('load image fail')
          })
          .onClick(()=>{
            this.pageInfos.pushPath({ name: this.nameList[1] })
            console.info('turn into next page')
          })

        Text(this.UserInfo.username)
          .Headline()
          .fontColor(this.fontColor)
          .height('30%')
      }
      .width('100%')
      .height('75%')
      .backgroundColor('#436eee')
      .borderRadius({ bottomLeft: 24, bottomRight: 24 })
      .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP])

      Column() {
        Text('Achieve higher emotional')
          .SecondaryText()
          .fontColor('#929292')
        Text('intelligence')
          .SecondaryText()
          .fontColor('#929292')
      }
      .height('25%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('50%')
    .backgroundColor('#181818')
    .borderRadius({ bottomLeft: 24, bottomRight: 24 })
  }
}

@Component
struct experience{
  @State comment:number = 1800
  @State likes:number = 10001
  @State EQ:number = 99
  build() {
    Column({space:5}){
      Text('Experience:')//粗体
        .fontSize(16)
        .fontWeight(700)
        .alignSelf(ItemAlign.Start)
        .padding({left:20,top:8})
      Row(){
        Column({space:3}){
          Text('评论')
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#ccd0d6')
          Text(this.comment.toString())
            .fontSize(14)
            .fontWeight(800)
        }
        Column({space:3}){
          Text('点赞')
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#ccd0d6')
          Text(this.likes.toString())
            .fontSize(14)
            .fontWeight(800)
        }
        Column({space:3}){
          Text('情商')
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#ccd0d6')
          Text(this.EQ.toString())
            .fontSize(14)
            .fontWeight(800)
        }

      }
      .backgroundColor('#f7f8fa')
      .borderRadius(24)
      .width('90%')
      .height('65%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    // .padding({top:20})
    .width("90%")
    .height('20%')
    .borderRadius(24)
    .backgroundColor('#ffffff')
  }
}

// PageOne.ets
@Component
export struct testResult {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("这是你的测试成绩")
      }.width('100%').height('100%')
    }.title("测试成绩")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// PageTwo.ets
@Component
export struct changeProfile {
  @Consume imageUrl: string
  @Prop UserInfo:UserInfo
  @Consume('pageInfos') pageInfos: NavPathStack;

  submit(){
    const req = http.createHttp()
    req.request('https://eqmaster.redamancyxun.fun:8080/user/updateUserInfo', {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'session': PreferenceModel.getPreference('session', ''),
      },
      extraData: {
        "username": this.UserInfo.username,
        "signature": this.UserInfo.signature
      }
    },(err:BusinessError,res:http.HttpResponse)=> {
      if (!err) {
        console.log("profile changed successfully")
        console.info('Result:' + JSON.stringify(res.result));
      } else {
        console.info('submit: error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        req.off('headersReceive');
        // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
        req.destroy();
      }
    })
  }


  build() {
    NavDestination() {
      Column() {

        Column({space:5}) { //头像上面
          Text("修改个人信息")
            .Headline()
            .fontColor('#c6d3fa')
          Text('分享一下下面的个人信息,让我们更好的认识你')
            .SecondaryText()
            .fontColor('#c6d3fa')
        }
        .alignItems(HorizontalAlign.Start)
        .height('10%')
        .margin({left:30,top:10})

        Image($r(this.imageUrl))
          .height('25%')
          .borderRadius(24)
            //设置边框
          .padding(3)
          .borderStyle(BorderStyle.Solid)
          .borderColor('#FFFFFF')
          .borderWidth(2)
            //
          .alignSelf(ItemAlign.Center)
          .margin(20)
          .onError(() => {
            console.info('load image fail')
          })

        Column() {
          TextInput({ placeholder: '用户名' ,text: $$this.UserInfo.username})
            .margin({ top: 10 })
            .placeholderColor('#c6d3fa')
            .showUnderline(true)
            .underlineColor('#FFFFFF')
            .onSubmit((EnterKeyType)=>{
              console.info(EnterKeyType+'输入法回车键的类型值')
            })
          TextInput({ placeholder: '个性签名', text: $$this.UserInfo.signature })
            .margin({ top: 20 })
            .placeholderColor('#c6d3fa')
            .showUnderline(true)
            .underlineColor('#FFFFFF')
            .onSubmit((EnterKeyType)=>{
              console.info(EnterKeyType+'输入法回车键的类型值')
            })
          Button('确认')
            .width('80%')
            .margin({top:100})
            .fontColor('#c6d3fa')
            .backgroundColor('#000000')
            .onClick(()=>{
              this.submit()
            })
        }
        .padding(20)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .backgroundColor('#436eee')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// PageThree.ets
@Component
export struct pageThreeTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent3")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle3")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// 个人主页主界面
@Entry
@Component
export struct UserInfoIndex {
  @State UserInfo:UserInfo = new UserInfo()
  @Provide imageUrl: string = 'app.media.login_logo'
  //TODO 改成从资源读取
  // @State userName: string = 'EQ_Master' // 缺省用户名
  // @State signature: string = "Achieve higher emotional\n" + "intelligence"
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Provide nameList:string[] = ["测试成绩","修改个人信息"]
  @State isLoggedIn: boolean = false; // 用户是否已登录

  private fontColor:string = '#c4d2fa'

  // 页面加载时检查登录状态并获取用户信息
  aboutToAppear(): void {
    console.log("加载登陆状态")
    // this.getUserInfo()
    UserServer.getCheckLogin().then((data: number) => {
      console.log("getUserInfo: success")
      if(data=0){
        Logger.info('用户未登录')
        //TODO
      }else{
        Logger.info('用户已登录')
        // UserServer.getUserInfo().then((data: UserInfo) => {
        //   console.log("getUserInfo: success")
        //   console.info('Result:' + JSON.stringify(data))
        //   this.UserInfo=data
        // }).catch((err: Resource | ResponseResult) => {
        //   console.info('getUserInfo: error:' + JSON.stringify(err));
        //   if (err instanceof ResponseResult) {
        //     if (err.message !== null) {
        //       PromptUtil.promptMessage(err.message, CommonConstants.PROMPT_DURATION);
        //     }
        //   }else {
        //     PromptUtil.promptMessage(err, CommonConstants.PROMPT_DURATION);
        //   }
        // })
      }
    }).catch((err: Resource | ResponseResult) => {
      console.info('getCheckLogin: error:' + JSON.stringify(err));
      if (err instanceof ResponseResult) {
        if (err.message !== null) {
          PromptUtil.promptMessage(err.message, CommonConstants.PROMPT_DURATION);
        }
      }else {
        PromptUtil.promptMessage(err, CommonConstants.PROMPT_DURATION);
      }
    })
    this.getUserInfo()
    // UserServer.getUserInfo().then((data: UserInfo) => {
    //   console.log("getUserInfo: success")
    //   console.info('Result:' + JSON.stringify(data))
    //   this.UserInfo=data
    // }).catch((err: Resource | ResponseResult) => {
    //   console.info('getUserInfo: error:' + JSON.stringify(err));
    //   if (err instanceof ResponseResult) {
    //     if (err.message !== null) {
    //       PromptUtil.promptMessage(err.message, CommonConstants.PROMPT_DURATION);
    //     }
    //   }else {
    //     PromptUtil.promptMessage(err, CommonConstants.PROMPT_DURATION);
    //   }
    // })

  }

  getUserInfo(){
    const req = http.createHttp()
    // 假设通过某个API接口检查用户登录状态
    req.request('https://eqmaster.redamancyxun.fun:8080/user/getUserInfo',{
      method: http.RequestMethod.GET,
      header: {
        'session': PreferenceModel.getPreference('session', '')
      },
    }, (err:BusinessError, res:http.HttpResponse)=>{
      if(!err){
        let data:ResponseResult = JSON.parse(res.result.toString());
        console.log("getUserInfo: success")
        console.log('HttpResponse'+JSON.stringify(res.result))
        console.log('ResponseResult:' + JSON.stringify(data.result));
        if(data.result!=null){
          let data_userinfo:UserInfo=JSON.parse(JSON.stringify(data.result))
          this.UserInfo=data_userinfo
        }
        console.log("getUserInfo: userName is", this.UserInfo.username)
        console.log("getUserInfo: signature is", this.UserInfo.signature)
      }
      else {
        console.info('getUserInfo: error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        req.off('headersReceive');
        // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
        req.destroy();
      }
    })
  }

  // 跳转逻辑
  @Builder
  PageMap(name: string) {
    if (name === this.nameList[0]) {
      testResult()
    } else if (name === this.nameList[1]) {
      changeProfile({UserInfo:this.UserInfo})
    } else if (name === "NavDestinationTitle3") {
      pageThreeTmp()
    }
  }
  //用于实现箭头标志
  @Builder OverlayNode() {
    Column() {
      Image('./image/ic_public_arrow_right.svg')
        .height('100%')
        .padding({right: 15})
    }.height('30%').alignItems(HorizontalAlign.End)
  }


  build() {
    Column() {
      Navigation(this.pageInfos) {

        Column({ space: 12 }) {
          userImage({UserInfo:this.UserInfo})
          //以上是用户头像昵称部分
          experience()

          Column() {
            List({ space: 12 }) {
              ListItem() {
                Text(this.nameList[0])
                  .width("100%")
                  .height(72)
                  .backgroundColor('#FFFFFF')
                  .borderRadius(24)
                  .fontSize(16)
                  .fontWeight(500)
                  .textAlign(TextAlign.Start)
                  .padding({ left: 20 })
                  .onClick(() => {
                    this.pageInfos.pushPath({ name: this.nameList[0] })
                  })
                  .overlay(this.OverlayNode(), { align: Alignment.End })
              }
            }
            .width("90%")
          }
          .width('100%')
          .height('30%')
          .margin({ top: 12 })
        }
        .height('100%')
        .width('100%')
        .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP])
      }
      .mode(NavigationMode.Stack)
      .navDestination(this.PageMap)
      .hideToolBar(true)
      .height('100%')
      // .toolbarConfiguration([this.TooTmp, this.TooTmp, this.TooTmp])
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f5fbf9')
  }
}