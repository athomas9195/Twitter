//
//  ComposeViewController.m
//  twitter
//
//  Created by Anna Thomas on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()

@end 

@implementation ComposeViewController
//closes the compose view
- (IBAction)closeBarButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//opens the modal compose view
- (IBAction)tweetBarButton:(id)sender {
    
    NSString *text = self.textView.text;
    
    // post tweet
    [[APIManager shared] postStatusWithText:text completion:^(Tweet *tweet, NSError *error) {
        if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else{
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
            }  
       
    }]; 
    
    [self closeBarButton:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 2.0f;
    

}

@end
