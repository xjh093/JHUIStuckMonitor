//
//  JHUIStuckMonitor.h
//  JHUIStuckMonitor
//
//  Created by HaoCold on 2021/6/9.
//

#ifdef DEBUG
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUIStuckMonitor : NSObject

+ (instancetype)share;

- (void)startMonitor;
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
#endif
