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
#define SW_BUY_NOTIFICATION @"SW_BUY_NOTIFICATION"
#define SW_UNBUY_NOTIFICATION @"SW_UNBUY_NOTIFICATION"
#define SW_NOTIFICATION_PRODUCT_KEY @"SW_NOTIFICATION_PRODUCT_KEY"
#define SW_UPDATE_CATEGORY_NOTIFICATION @"SW_UPDATE_CATEGORY_NOTIFICATION"
#define SW_DELETE_CATEGORY_NOTIFICATION @"SW_UPDATE_CATEGORY_NOTIFICATION"
#define SW_UPDATE_CATEGORY_CATEGORY_ID_KEY @"SW_UPDATE_CATEGORY_CATEGORY_ID_KEY"

// default
#define SW_DEFAULT_UNIT @"块"
#endif /* SWDef_h */
