//
//  ContactUsTableViewCell.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/16/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "ContactUsTableViewCell.h"
static selectButton buttonBlock;

@implementation ContactUsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)facebookLink:(id)sender {
    [self.delegate didClickButtonAnIndex:Facebook];
}
- (IBAction)instagramLink:(id)sender {
    [self.delegate didClickButtonAnIndex:Instagram];
}
- (IBAction)twitterLink:(id)sender {
    [self.delegate didClickButtonAnIndex:Twitter];
}

@end
