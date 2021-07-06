//
//  ChatCell.h
//  ParseChat
//
//  Created by Elizabeth Ke on 7/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

NS_ASSUME_NONNULL_END
