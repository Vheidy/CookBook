//
//  CBLogger.m
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

#import "CBLogger.h"
#import "CookBook-Swift.h"

@class InitializationHandler;

@implementation CBLogger

@synthesize delegate;

- (void)printLog:(NSString *) text {
    NSLog(@"Some interaction: %@", text);
}

@synthesize testBlock;

- (void)saveNewInitialization {
    CoreDataService *service = [[CoreDataService alloc] init];
    InitializationHandler *initHandler = [[InitializationHandler alloc] initWithService: service];
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
