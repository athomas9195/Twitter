//
//  DetailsViewController.m
//  twitter
//
//  Created by Anna Thomas on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "APIManager.h"
#import "TimelineViewController.h"

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
- (IBAction)didTapRetweet:(id)sender {
    self.tweet.retweeted = YES;
    self.tweet.retweetCount +=1;
    
    [self refreshDataRetweet];
    
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
    
}



- (IBAction)didTapFavorite:(id)sender {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
  
    [self refreshDataFavorite];
    
     
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    
}


-(void) refreshDataFavorite {
   
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteButton.selected = YES;
}

-(void) refreshDataRetweet{
   
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetButton.selected = YES;
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Tweet *tweet = self.tweet;
    
    self.userImageView.layer.cornerRadius = 20;
    self.userImageView.clipsToBounds = YES;
    
    self.authorNameLabel.text = tweet.user.name;
    
    
    NSString *userhandle = @"@";
    NSString *fullUserScreenName = [userhandle stringByAppendingString:tweet.user.screenName];
    
    self.usernameLabel.text = fullUserScreenName;
    
    self.dateLabel.text = tweet.createdAtString;
    self.tweetTextLabel.text = tweet.text;
    
 
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount ];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
 
    self.tweet = tweet;
    
    
    //button states
    if(self.tweet.favorited == YES) {
        self.favoriteButton.selected = YES;
    }
    
    if(self.tweet.retweeted == YES) {
        self.retweetButton.selected = YES;
    } 
    
 
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
