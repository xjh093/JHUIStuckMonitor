//
//  SMCallStack.h
//
//
//  Created by DaiMing on 2017/6/22.
//  Copyright © 2017年 Starming. All rights reserved.
//

#ifdef DEBUG
#import "SMCallLib.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SMCallStackType) {
    SMCallStackTypeAll,     //全部线程
    SMCallStackTypeMain,    //主线程
    SMCallStackTypeCurrent  //当前线程
};

@interface SMCallStack : NSObject

+ (NSString *)callStackWithType:(SMCallStackType)type;

extern NSString *smStackOfThread(thread_t thread);

@end
#endif
