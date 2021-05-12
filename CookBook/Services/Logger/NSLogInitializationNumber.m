//
//  NSLogInitializationNumber.m
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

#import "NSLogInitializationNumber.h"
#import "CookBook-Swift.h"
#import "CBLogger.h"

@implementation NSLogInitializationNumber

- (void) initWith:(CBLogger *)delegator {
    delegator.delegate = self;
}

- (void)printNumberOfInitialization {
    CoreDataService *service = [[CoreDataService alloc] init];
    InitializationHandler *initHandler = [[InitializationHandler alloc] initWithService: service];
    NSLog(@"Number of initialization %ld", (long)[initHandler fetchNumberOfInitialization]);
}

@end
