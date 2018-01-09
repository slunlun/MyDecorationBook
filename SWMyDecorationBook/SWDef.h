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

#endif /* SWDef_h */
