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
@property (weak, nonatomic) IBOutlet UIImageView *userImageView; //user profile pic
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel; //user name
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel; //user screen name
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel; //the actual tweet text
@property (weak, nonatomic) IBOutlet UILabel *dateLabel; //how long ago it was posted
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel; //retweet count
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel; //favorite count
@property (weak, nonatomic) IBOutlet UIButton *replyButton; //reply button
@property (weak, nonatomic) IBOutlet UIButton *retweetButton; //retweet button
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton; //favorite button


@end

@implementation DetailsViewController

//when user clicks on retweet
- (IBAction)didTapRetweet:(id)sender {
    self.tweet.retweeted = YES;
    self.tweet.retweetCount +=1;
    
    [self refreshDataRetweet];
    
    //call api to retweet
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
    
}


//when user clicks on favorite button
- (IBAction)didTapFavorite:(id)sender {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
  
    [self refreshDataFavorite];
    
    //tells api to favorite that tweet
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    
}

//reloads the views for details view
-(void) refreshDataFavorite {
   
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteButton.selected = YES;
}

//reloads the views for details view
-(void) refreshDataRetweet{
   
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetButton.selected = YES;
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Tweet *tweet = self.tweet;
    
    //set custom details display
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

@end
