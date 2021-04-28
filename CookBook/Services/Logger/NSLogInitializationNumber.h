//
//  NSLogInitializationNumber.h
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

#import <Foundation/Foundation.h>
#import "CBLogger.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FetchAllInitializationsDelegate;
@class CBLogger;

@interface NSLogInitializationNumber : NSObject <FetchAllInitializationsDelegate>



- (void) initWith:(CBLogger *)delegator;
- (void)printNumberOfInitialization;

@end

NS_ASSUME_NONNULL_END
