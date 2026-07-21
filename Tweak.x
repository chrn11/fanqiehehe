#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

%hook SSAccountInfo
- (_Bool)isVip {
    return YES;
}
%end

%hook SSVipInfo
// VIP剩余时间
- (id)leftTime {
    return [NSString stringWithFormat:@"%.0lf", 2534308005 - [[NSDate date] timeIntervalSince1970]];
}

// VIP到期时间,20990113
- (id)expireTime {
    return @"4071916800";
}

- (id)isVip {
    return @"1";
}
%end

// 顺便解锁番茄畅听等
%hook SSUser
- (bool)isVip {
    return 1;
}
%end

%hook BUSplashAdView
- (void)setSlot:(id)arg1 {
}
%end

// 新版开屏广告视图(7.x+ 取代 BUSplashAdView)
// 注意:方法签名需真机验证,若崩溃请删除对应 %hook 块
%hook BDASplashView
- (void)setSlot:(id)arg1 {
}
%end

// 移除阅读页面插入广告
%hook BDReaderViewController
- (id)tryGetInsertedVC:(id)arg1 fromPageContext:(id)arg2 toPageContext:(id)arg3 {
    return nil;
}
%end

%hook SSAdReaderCommonEntranceView
- (id)initWithFrame:(struct CGRect)arg1 {
    id view = %orig;
    [view setAlpha:0];
    [view setHidden:YES];
    return view;
}
%end

// 隐藏底栏"福利"按钮
// 番茄用 CYLTabBarController,福利 Tab 由 shouldShowWelfareTab 等方法控制
// 多个候选类,Logos 会自动跳过不存在的类/方法
%hook SSTabBarController
- (_Bool)shouldShowWelfareTab {
    return NO;
}
- (_Bool)isWelfareTabSwitchOpen {
    return NO;
}
%end

%hook SSWelfareTabGuideTipManager
- (_Bool)shouldShowWelfareTab {
    return NO;
}
%end

%hook SSWelfareABService
- (_Bool)isWelfareTabSwitchOpen {
    return NO;
}
%end
