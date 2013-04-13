//
//  ULLog.h
//  UberLife
//
//  Created by Luigi Colucci on 13/01/2012.
//  Copyright (c) 2012 CitySocialising Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef SHOW_LOG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...);
#endif

#ifdef SHOW_LOG
#   define WLog(fmt, ...) NSLog((@"UL-WARNING %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define WLog(...);
#endif

// ELog always displays Warning output regardless of the DEBUG setting
#define ELog(fmt, ...) NSLog((@"UL-ERROR %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
