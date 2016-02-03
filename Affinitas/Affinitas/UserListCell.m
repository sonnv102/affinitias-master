//
//  UserListCell.m
//  Affinitas
//
//  Created by OnurMac on 11/11/15.
//  Copyright © 2015 Onur Unal. All rights reserved.
//

#import "UserListCell.h"
#import "AFUsers.h"
#import "MBProgressHUD.h"

#define K_CELL  @"UserListCell"

@implementation UserListCell{
    UITableViewController *_viewController;
}

- (void)awakeFromNib {
    // Initialization code
    self.kUserImage.contentMode = UIViewContentModeScaleAspectFill;
    self.kUserImage.layer.cornerRadius =self.kUserImage.frame.size.height/2;
    self.kUserImage.layer.masksToBounds = YES;
    self.kUserImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.kUserImage.layer.borderWidth=1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithCustomNibAndController:(UITableViewController *)controller _user:(AFUsers*)user{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:K_CELL];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:K_CELL owner:self options:nil];
        self = nib[0];
        _viewController = controller;
        
        [self setUserTitle:user];
        [self setLocationTitle:user];
        [self setUserImage:user];
        [self setUserImagesCountTitle:user];
        
        DKLog(K_VERBOSE_MOBILE_API_JSON, @"User List --> {%@}",user);
    }
    return  self;
}

-(void)setUserTitle:(AFUsers*)userInfo{
    self.kUserHeader.text = [NSString stringWithFormat:@"%@, %@",[userInfo valueForKey:JSON_FIRSTNAME],[userInfo valueForKey:JSON_AGE]];
}

-(void)setLocationTitle:(AFUsers*)userInfo{
    self.kUserLocation.text = [NSString stringWithFormat:@"searching in  %@",[userInfo valueForKey:JSON_CITY]];
}

-(void)setUserImagesCountTitle:(AFUsers*)userInfo{
    self.kUserImagesCountLabel.text = [(NSNumber*)[userInfo valueForKey:JSON_TOTAL_IMAGES] stringValue];
}

-(void)setUserImage:(AFUsers*)userInfo{
    NSURL *imageURL = [[NSURL alloc] initWithString:[self replaceURL:userInfo]];
    if (imageURL != nil) {
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        [downloader downloadImageWithURL:imageURL
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                    // progression tracking code
                                }
                               completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                   if (image && finished) {
                                       // do something with image
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.kUserImage.image = image;
                                       });
                                       
                                   }else{
                                       NSLog(@"%@",error.description);
                                   }
                                       
                               }];
    }
}

-(NSString*)replaceURL:(AFUsers*)url{
    return [[url valueForKey:@"image_url"] stringByReplacingOccurrencesOfString:@"/profiles.php" withString:@""];
}


@end
