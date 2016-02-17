//
//  ContactUsTableViewCell.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/16/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ContactButton){
    Facebook,
    Twitter,
    Instagram
};
typedef void (^selectButton)(ContactButton buttonindex);
@protocol ContactUsDelegate <NSObject>


@optional
/**
 *  the delegate to tell user whitch button is clicked
 *
 *  @param button button
 */
- (void)didClickButtonAnIndex:(ContactButton )button;
@end

@interface ContactUsTableViewCell : UITableViewCell
@property (nonatomic, weak) id<ContactUsDelegate> delegate;
@end
