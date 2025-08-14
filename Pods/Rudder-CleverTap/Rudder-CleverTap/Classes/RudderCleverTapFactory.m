//
//  RudderCleverTapFactory.h
//  Rudder-CleverTap
//
//  Created by Desu Sai Venkat on 31/03/21.
//

#import "RudderCleverTapFactory.h"
#import "RudderCleverTapIntegration.h"

@implementation RudderCleverTapFactory

static RudderCleverTapFactory *sharedInstance;

+ (instancetype)instance 
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)key 
{
    return @"CleverTap";
}

-(id<RSIntegration>)initiate:(NSDictionary *)config client:(RSClient *)client rudderConfig:(RSConfig *)rudderConfig
{
    [RSLogger logDebug:@"Creating RudderIntegrationFactory: CleverTap"];
    return [[RudderCleverTapIntegration alloc] initWithConfig:config
                                                withAnalytics:client
                                             withRudderConfig:rudderConfig];
}
@end
