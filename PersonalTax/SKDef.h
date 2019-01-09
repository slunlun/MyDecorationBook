//
//  SKDef.h
//  SKIncomeTaxCalculator
//
//  Created by Eren on 2018/12/25.
//  Copyright © 2018 skyline. All rights reserved.
//

#ifndef SKDef_h
#define SKDef_h

#define kMargin 8
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth_Scale    ([UIScreen mainScreen].bounds.size.width/375.0f)
#define MainScreenHeight_Scale   ([UIScreen mainScreen].bounds.size.height/667.0f)

#define GAD_APPID @"ca-app-pub-5362427100976726~4213614978"

#ifdef DEBUG
    #define GAD_TOPBANNER_ID    @"ca-app-pub-3940256099942544/2934735716"
    #define GAD_BOTTOMBANNER_ID @"ca-app-pub-3940256099942544/2934735716"
#else
    #define GAD_TOPBANNER_ID    @"ca-app-pub-5362427100976726/1105155774"
    #define GAD_BOTTOMBANNER_ID @"ca-app-pub-5362427100976726/2773460661"
#endif

#endif /* SKDef_h */
