//
//  DetailsViewController.m
//  twitter
//
//  Created by Anna Thomas on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Tweet *tweet = self.tweet;
    
    self.authorNameLabel.text = tweet.user.name;
    
    
    NSString *userhandle = @"@";
    NSString *fullUserScreenName = [userhandle stringByAppendingString:tweet.user.screenName];
    
    self.usernameLabel.text = fullUserScreenName;
    
    self.dateLabel.text = tweet.createdAtString;
    self.tweetTextLabel.text = tweet.text;
    
 
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount ];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
 
    self.tweet = tweet;
 
    //profile image
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];

    if (urlData.length != 0) {


        self.userImageView.image = nil;
        self.userImageView.image = [UIImage imageWithData: urlData];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
