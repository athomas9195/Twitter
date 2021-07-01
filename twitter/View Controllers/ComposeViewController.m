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
- (IBAction)closeBarButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetBarButton:(id)sender {
    
    NSString *text = self.textView.text;
    
    // post tweet
    [[APIManager shared] postStatusWithText:text completion:^(Tweet *tweet, NSError *error) {
        if(error) {
            NSLog(@"DID NOT WORK");
        }
       
    }]; 
    
    [self closeBarButton:self];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
