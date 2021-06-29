//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.


#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
 
@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    //table view delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            // inside your loadTweets() function
            self.arrayOfTweets = tweets;
            
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (NSDictionary *dictionary in tweets) {
                NSString *text = dictionary[@"text"];
                NSLog(@"%@", text);
            }
         
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.authorLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    
    cell.dateLabel.text = tweet.createdAtString;
    cell.tweetTextLabel.text = tweet.text;
    

    
    NSString *retweetCount = [NSString stringWithFormat:@"%d", tweet.retweetCount ];
    
    NSString *favoriteCount = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    [cell.retweetButton setTitle: retweetCount forState:UIControlStateNormal];
    
    [cell.favoriteButton setTitle: favoriteCount forState:UIControlStateNormal];


    //profile image
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    if (urlData.length != 0) {


        cell.userImage.image = nil;
        [cell.userImage setImage:urlData];

    }
    
 
    return cell;
}













-(void)didLogOut {
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
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
