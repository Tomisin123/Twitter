//
//  TweetCell.m
//  twitter
//
//  Created by tomisin on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation TweetCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
