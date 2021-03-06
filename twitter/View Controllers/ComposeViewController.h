//
//  ComposeViewController.h
//  twitter
//
//  Created by Anna Thomas on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate
 
- (void)didTweet:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView; //textbox for the tweet
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate; 

@end 

NS_ASSUME_NONNULL_END
