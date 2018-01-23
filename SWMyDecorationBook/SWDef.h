//
//  SWDef.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/8/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#ifndef SWDef_h
#define SWDef_h

//weak-strong.
#define WeakObj(obj) __weak typeof(obj) obj##Weak = obj;
#define StrongObj(obj) __strong typeof(obj) obj = obj##Weak;


// Notification
#define SW_HOME_PAGE_DISAPPEAR_NOTIFICATION @"SW_HOME_PAGE_DISAPPEAR_NOTIFICATION"
#define SW_HOME_PAGE_APPEAR_NOTIFICATION @"SW_HOME_PAGE_APPEAR_NOTIFICATION"

// default
#define SW_DEFAULT_UNIT @"块"
#endif /* SWDef_h */
