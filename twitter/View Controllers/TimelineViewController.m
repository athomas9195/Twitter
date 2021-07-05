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
 
@property (nonatomic, strong) NSMutableArray *arrayOfTweets; //stores a list with tweet info
@property (weak, nonatomic) IBOutlet UITableView *tableView; //table for the timeline 

@end 

//this view controller controls the home timline
@implementation TimelineViewController
- (IBAction)didTapLogout:(id)sender {
    [self didLogOut];
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    // Initialize a UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
 
     
    //table view delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //set cell height to automatic
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    //get the data to display and store it in local variable
    [self getData:@"timeline"];



}


//to make timelineviewcontroller generic so it can be reused
- (void)getData:(NSString*)apiCallName {
    
    if([apiCallName isEqualToString:@"timeline"]) {
        // Get timeline
        [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {

            if (tweets) {
                
                NSMutableArray* tweetsMutableArray = [tweets mutableCopy];
                self.arrayOfTweets = tweetsMutableArray;
                [self.tableView reloadData];
            
            } else {
                NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            }
        }];
    
    }
     
    //if([apiCallName isEqualToString:@"somethingOtherAPICall"])
    //call corresponding api and return results as a mutable array
    
}


    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


// Makes a network request to get updated data
 // Updates the tableView with the new data
 // Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {}];
 
    
    // Reload the tableView now that there is new data
    [self.tableView reloadData];

    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];

}

 
 
//set how many rows in timeline display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

//enables custom cell displays
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row]; 
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = tweet;
   
    
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
 
    
    //is this tweet a retweet?

    CGRect hiddenFrame = cell.userRetweetedView.frame;
    hiddenFrame.size.height = 0;
    cell.userRetweetedView.frame = hiddenFrame;
    cell.userRetweetedView.hidden = YES;
        
    if(cell.tweet.retweetedByUser != nil) {
    //        CGRect showFrame = self.userRetweetedView.frame;
    //        showFrame.size.height = 24;
    //        self.userRetweetedView.frame = showFrame;
            
        [cell.userRetweetedView setHidden:NO];
        cell.authorNameRetweetedLabel.text = tweet.retweetedByUser.name;

    }
    

 
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












//allows user to log out
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
    
    //if the user clicks on compose icon
    if ([[segue identifier] isEqualToString:@"toCompose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
            ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
            composeController.delegate = self;
        
    
    //if user clicks on a tweet
    } else if ([[segue identifier] isEqualToString:@"toDetails"]){
        //tweet details segue
         
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        
        detailsViewController.tweet = tweet;
        
    }
    
   
}


//when user clicks on Tweet after composing a tweet.
//adds the new tweet onto the tweet array (displays at the top of timeline)
- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}


@end
