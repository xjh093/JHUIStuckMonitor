//
//  ViewController.m
//  JHUIStuckMonitor
//
//  Created by HaoCold on 2021/6/9.
//

#import "ViewController.h"
#import "JHUIStuckMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[JHUIStuckMonitor share] startMonitor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSInteger n = 10000;
    for (NSInteger i = 0; i < n; i++) {
        NSLog(@"busy...\n");
    }
}

@end
