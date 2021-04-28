//
//  CBLogger.m
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

#import "CBLogger.h"
#import "CookBook-Swift.h"

@implementation CBLogger

@synthesize delegate;

- (void)printLog:(NSString *) text {
    NSLog(@"Some interaction: %@", text);
}

@synthesize testBlock;

- (void)saveNewInitialization {
    InitializationHandler *initHandler = [[InitializationHandler alloc] init];
    [initHandler saveInitialization];
}

- (void)printAllInitialization {
    if ([self.delegate respondsToSelector:@selector(printNumberOfInitialization)]) {
        [self.delegate printNumberOfInitialization];
    } else {
        testBlock();
    }
}

@end
