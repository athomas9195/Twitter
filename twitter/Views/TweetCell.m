//
//  TweetCell.m
//  twitter
//
//  Created by Anna Thomas on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "TimelineViewController.h"
#import "APIManager.h"


@implementation TweetCell


//when user clicks on retweet button
- (IBAction)didTapRetweet:(id)sender {
    
    //if it has not already been retweeted
    if(self.retweetButton.selected ==NO) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount +=1;
        
        [self refreshDataRetweet];
        
        //api call to retweet
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error!=nil){
                
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
                
                //a network error popup
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Retweet" message:@"The Internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
                 
                // create a cancel action
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                         // handle cancel response here. Doing nothing will dismiss the view.
                                                                  }];
                // add the cancel action to the alertController
                [alert addAction:cancelAction];

                // create an OK action
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                         // handle response here.
                                                                 }];
                // add the OK action to the alert controller
                [alert addAction:okAction];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert
                                                                                             animated:YES
                                                                                           completion:^{
                                                                                                   // optional code for what happens after the alert controller has finished presenting
                                                                                           }];
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
        
    //if the user already retweeted it and wants to unretweet
    } else if  (self.retweetButton.selected ==YES) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -=1;
        
        [self refreshDataRetweetUnretweet];
        
        //api call to unretweet
       [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error!=nil){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
        
    }
    

}



//when user clicks on favorite button
- (IBAction)didTapFavorite:(id)sender {
    
    //favorite
    if(self.favoriteButton.selected ==NO) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
      
        [self refreshDataFavorite];
        
         //api call to favorite
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error!=nil){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
               
               //a network error popup
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Favorite" message:@"The Internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
                
               // create a cancel action
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                        // handle cancel response here. Doing nothing will dismiss the view.
                                                                 }];
               // add the cancel action to the alertController
               [alert addAction:cancelAction];

               // create an OK action
               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                        // handle response here.
                                                                }];
               // add the OK action to the alert controller
               [alert addAction:okAction];
               
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert
                                                                                             animated:YES
                                                                                           completion:^{
                                                                                                   // optional code for what happens after the alert controller has finished presenting
                                                                                           }];
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        
        //unfavorite
    } else if (self.favoriteButton.selected ==YES) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
      
        [self refreshDataFavoriteUnfavorite];
        
         //api call to unfavorite
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error!=nil){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        
    }
    
    

}

//reloads cell view
-(void) refreshDataFavorite {
   
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteButton.selected = YES;
     
}

//reloads cell view
-(void) refreshDataFavoriteUnfavorite {
   
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteButton.selected = NO;
     
}

//reloads cell view
-(void) refreshDataRetweet{
   
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetButton.selected = YES;
     
}

//reloads cell view
-(void) refreshDataRetweetUnretweet{
   
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetButton.selected = NO;
     
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
