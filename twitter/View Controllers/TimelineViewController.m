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
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
 
@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
 
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end 

@implementation TimelineViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    // Initialize a UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
 
     
    //table view delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            // inside your loadTweets() function
            self.arrayOfTweets = tweets;
            [self.tableView reloadData]; 
            //NSLog(@"😎😎😎 Successfully loaded home timeline");
         
        } else {
            //NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Makes a network request to get updated data
 // Updates the tableView with the new data
 // Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            
            //NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
         
        } else {
            //NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
 
    
    // Reload the tableView now that there is new data
    [self.tableView reloadData];

    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];

}

 
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.userImage.layer.cornerRadius = 20;
    cell.userImage.clipsToBounds = YES; 
    
    cell.authorLabel.text = tweet.user.name;
    
    
    NSString *userhandle = @"@";
    NSString *fullUserScreenName = [userhandle stringByAppendingString:tweet.user.screenName];
    
    cell.usernameLabel.text = fullUserScreenName;
    
    cell.dateLabel.text = tweet.createdAtString;
    cell.tweetTextLabel.text = tweet.text;
    
 
    cell.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount ];
    cell.favoriteLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
 
    cell.tweet = tweet;
    

 
    //profile image
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];

    if (urlData.length != 0) {


        cell.userImage.image = nil;
        cell.userImage.image = [UIImage imageWithData: urlData];

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



 

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toCompose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
            ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
            composeController.delegate = self;
        
    
        
    } else if ([[segue identifier] isEqualToString:@"toDetails"]){
        //tweet details segue
         
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        
        detailsViewController.tweet = tweet;
        
    }
    
   
}



- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}


@end
