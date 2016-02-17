//
//  MyTableViewCell.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/20/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectionButton){
    Confirmation,
    Message
};
typedef void (^chooseButton)(SelectionButton buttonIndex);
@protocol MyTableViewCellDelegate <NSObject>


@optional
/**
 *  the delegate to tell user whitch button is clicked
 *
 *  @param button button
 */
- (void)didClickButtonAtIndex:(SelectionButton)button;
@end

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellPrice;
@property (weak, nonatomic) IBOutlet UILabel *cellDescription;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *badge;
@property (weak, nonatomic) IBOutlet UIView *subbar;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonWidth;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak,nonatomic) id <MyTableViewCellDelegate> delegate;
@end
