import { router } from '@kit.ArkUI';
import Logger from '../../common/utils/Logger';
import { CommonConstants } from '../../common/constants/CommonConstants';

@Entry
@Component
struct FirstPage {


  build() {
    Stack() {
      Image($r('app.media.ic_first_page_background'))
        .width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.FULL_HEIGHT)

      Column(){
      }
      .backgroundColor($r('app.color.text_backgroud_color'))
      .opacity(0.3)
      .width('100%')
      .height('50%')
      .margin({top:'140%'})
      .borderRadius(30)
      // .margin({top:300})

      Column() {
        Text($r('app.string.first_page_text1'))
          .fontSize($r('app.float.home_page_text_size'))
          .fontColor($r('app.color.first_page_text_color'))
          .opacity(1)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .margin({top:'13%'})

          // .height(CommonConstants.FULL_HEIGHT)
          // .width(CommonConstants.FULL_WIDTH)
        Text($r('app.string.first_page_text2'))
          .fontSize(18)
          .width('90%')
          .fontColor($r('app.color.first_page_text_color'))
          .opacity(1)
          .fontWeight(200)
          .textAlign(TextAlign.Center)
          .padding({top:20,
                    left:5,
                    right:5})
          .lineHeight(25)
          // .height(CommonConstants.FULL_HEIGHT)
          // .width(CommonConstants.FULL_WIDTH)

      }
      .width('100%')
      .height('25%')
      .margin({top:300})


        Button('下一步')
          .fontSize(18)
          .width(300)
          .height(55)
          .backgroundColor($r('app.color.button_color'))
          .margin({ top: 600})
          .onClick(() => {
            router.pushUrl({
              url: CommonConstants.Second_PAGE_URL
            }).catch((error: Error) => {
              Logger.error(CommonConstants.FIRST_PAGE_TAG, 'FirstPage pushUrl error ' + JSON.stringify(error));
            });
          })

    }
  }
}