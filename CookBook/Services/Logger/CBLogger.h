//
//  CBLogger.h
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

#import <Foundation/Foundation.h>
#import "NSLogInitializationNumber.h"
//#import "CookBook-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FetchAllInitializationsDelegate <NSObject>

@required
- (void)printNumberOfInitialization;

@end

@interface CBLogger : NSObject

@property (weak, nonatomic, nullable) id<FetchAllInitializationsDelegate> delegate;
@property (nonatomic, copy, nullable) void (^testBlock)(void);

- (void)printLog:(NSString *)text;
- (void)printAllInitialization;
- (void)saveNewInitialization;

@end

NS_ASSUME_NONNULL_END
