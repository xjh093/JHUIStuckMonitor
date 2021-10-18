//
//  JHUIStuckMonitor.m
//  JHUIStuckMonitor
//
//  Created by HaoCold on 2021/6/9.
//

#ifdef DEBUG
#import "JHUIStuckMonitor.h"
#import "SMCallStack.h"

@interface JHUIStuckMonitor()
@property (nonatomic,  assign) CFRunLoopObserverRef observer;
@property (nonatomic,  assign) CFRunLoopActivity  activity;
@property (nonatomic,  strong) dispatch_semaphore_t semaphore;
@property (nonatomic,  assign) NSInteger  timeoutCount;
@end

@implementation JHUIStuckMonitor

static void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    JHUIStuckMonitor *monitor = (__bridge JHUIStuckMonitor *)info;
    
    //
    monitor.activity = activity;
    
    //
    dispatch_semaphore_t semaphore = monitor.semaphore;
    dispatch_semaphore_signal(semaphore);
}

+ (instancetype)share
{
    static JHUIStuckMonitor *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[JHUIStuckMonitor alloc] init];
    });
    return share;
}

- (void)registerObserver
{
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            0,
                                                            &runLoopObserverCallback,
                                                            &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    _observer = observer;
    
    _semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            long t = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_MSEC));
            //NSLog(@"t = %@", @(t));
            if (t != 0) {
                if (!self.observer) {
                    self.timeoutCount = 0;
                    self.semaphore = 0;
                    self.activity = 0;
                    return;
                }
                
                if (self.activity == kCFRunLoopBeforeSources ||
                    self.activity == kCFRunLoopAfterWaiting) {
                    if (++self.timeoutCount < 5) {
                        continue;
                    }
                    
                    NSLog(@"出现卡顿");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        NSString *callStack = [SMCallStack callStackWithType:SMCallStackTypeMain];
                        NSLog(@"callStack:%@",callStack);
                    });
                }
            }
            self.timeoutCount = 0;
        }
    });
}

- (void)startMonitor
{
    if (_observer) {
        return;
    }
    
    [self registerObserver];
}

- (void)endMonitor
{
    if (!_observer) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
    _observer = nil;
}

@end
#endif
