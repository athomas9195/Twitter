//
//  User.h
//  twitter
//
//  Created by Anna Thomas on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject


@property (nonatomic, strong) NSString *name; //user name
@property (nonatomic, strong) NSString *screenName; //user screen name
@property (nonatomic, strong) NSString *profilePicture; //user profile pic

// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
