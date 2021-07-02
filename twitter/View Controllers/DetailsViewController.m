//
//  DetailsViewController.m
//  twitter
//
//  Created by tomisin on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *tweetAuthor;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UILabel *numReplies;
@property (weak, nonatomic) IBOutlet UILabel *numLikes;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *numRetweets;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tweetText.text = self.tweet.text;
    self.username.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetAuthor.text = self.tweet.user.name;
    self.tweetDate.text = self.tweet.createdAtString;
    
    //TODO: profile image, replies, retweets, likes
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    self.profilePic.image = nil;
    [self.profilePic setImageWithURL:url];
    
    self.numLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    //cell.numReplies.text = [NSString stringWithFormat:@"@%d", tweet.];
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    [self refreshData];
}
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited == YES) {
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                //Update the local tweet model
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                //Update cell UI
                [self refreshData];
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                     
            }
        }];
    }
    else{
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                //Update the local tweet model
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                //Update cell UI
                [self refreshData];
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            
            }
        }];
        
    }
    
}
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == YES) {
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                //Update the local tweet model
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                //Update cell UI
                [self refreshData];
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                     
            }
        }];
    }
    else{
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                //Update the local tweet model
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                //Update cell UI
                [self refreshData];
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            
            }
        }];
        
    }
}

-(void)refreshData {
    
    if(self.tweet.favorited){
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    self.numLikes.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    
    
    
    
    if(self.tweet.retweeted){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    self.numRetweets.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    
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
