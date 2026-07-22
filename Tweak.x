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

// 判断是否为底栏「福利」Tab 对应的控制器
static BOOL FQIsWelfareTabVC(UIViewController *vc) {
    if (!vc) return NO;
    UIViewController *root = vc;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        root = nav.viewControllers.firstObject ?: nav.topViewController;
    }
    NSString *cls = NSStringFromClass([vc class]);
    NSString *rootCls = NSStringFromClass([root class]);
    if ([cls containsString:@"WelfareTab"] || [rootCls containsString:@"WelfareTab"]) {
        return YES;
    }
    if ([cls isEqualToString:@"SSFQDCWelfareTabViewController"] ||
        [rootCls isEqualToString:@"SSFQDCWelfareTabViewController"]) {
        return YES;
    }
    // 按标题兜底
    NSString *title = vc.tabBarItem.title ?: root.tabBarItem.title;
    if ([title isEqualToString:@"福利"]) {
        return YES;
    }
    return NO;
}

static NSArray *FQFilterWelfareTabs(NSArray *viewControllers) {
    if (!viewControllers.count) return viewControllers;
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:viewControllers.count];
    for (UIViewController *vc in viewControllers) {
        if (!FQIsWelfareTabVC(vc)) {
            [filtered addObject:vc];
        }
    }
    return filtered.count ? filtered : viewControllers;
}

// 去掉底栏「福利」按钮
%hook SSTabBarController
- (void)setViewControllers:(NSArray *)viewControllers {
    %orig(FQFilterWelfareTabs(viewControllers));
}
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    %orig(FQFilterWelfareTabs(viewControllers), animated);
}
%end
