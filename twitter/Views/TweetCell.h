//
//  TweetCell.h
//  twitter
//
//  Created by Anna Thomas on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
 
NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage; //user profile pic
@property (weak, nonatomic) IBOutlet UILabel *authorLabel; //user's name
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel; //user's screen name
@property (weak, nonatomic) IBOutlet UILabel *dateLabel; //how long ago it was posted
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel; //the tweet text
@property (weak, nonatomic) IBOutlet UIButton *replyButton; //reply button
@property (weak, nonatomic) IBOutlet UIButton *retweetButton; //retweet button
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton; //favorite button
@property (weak, nonatomic) IBOutlet UIView *userRetweetedView;
@property (weak, nonatomic) IBOutlet UIImageView *userRetweetedImage;
@property (weak, nonatomic) IBOutlet UILabel *authorNameRetweetedLabel;
@property (weak, nonatomic) IBOutlet UILabel *userRetweetedLabel;
@property (weak, nonatomic) IBOutlet UIStackView *userRetweetedStackView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *isNotRetweetedConstraintLabels;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *isRetweetedConstraintLabels;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *isRetweetedConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *isNotRetweetedConstraint;



@property (nonatomic, strong) Tweet *tweet;  //stores the reference to the current tweet
@property (weak, nonatomic) IBOutlet UILabel *replyLabel; //reply count (static)
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel; //retweet count
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel; //favorite count

@end

NS_ASSUME_NONNULL_END
