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
#define SW_ORDER_INFO_UPDATE_NOTIFICATION @"SW_ORDER_INFO_UPDATE_NOTIFICATION"

// default
#define SW_DEFAULT_UNIT @"块"

// iOS User Default KEY
#define SW_BUDGET_KEY @"SW_BUDGET_KEY"
#define SW_SYNC_CONTACT_TO_SYS_KEY @"SW_SYNC_CONTACT_TO_SYS_KEY"
//      For user guide
#define SW_MARKET_HOMEPAGE_LOADED_KEY @"SW_MARKET_HOMEPAGE_LOADED_KEY"
#define SW_ORDER_INFO_VC_EVER_LOADED_KEY @"SW_ORDER_INFO_VC_EVER_LOADED_KEY"

// for AD
#define SW_AD_FIRST_INIT_KEY @"SW_AD_FIRST_INIT_KEY"
#define SW_AD_LAST_DISPLAY_TIME_KEY @"SW_AD_LAST_DISPLAY_TIME_KEY"
#define SW_AD_FIRST_ELAPSE 2*60
#define SW_AD_ELAPSE 30*60
#define SW_SHOW_AD_NOTIFICATION @"SW_SHOW_AD_NOTIFICATION"

// user comment
#define SW_USER_COMMENT_INTERVAL_KEY @"SW_USER_COMMENT_INTERVAL_KEY"
#define SW_USER_LAST_COMMENT_TIME_KEY @"SW_USER_LAST_COMMENT_TIME_KEY"
#define SW_USER_COMMENT_TIME_UNIT 60*60
#endif /* SWDef_h */
