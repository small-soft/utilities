//
//  SSTextFieldCell.h
//  NetTicket
//
//  Created by 神逸 on 13-1-8.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTextFieldCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UITextView *textView;

-(void)setupView;

+(CGFloat)cellHeight;
+(CGFloat)cellWidth;
+(NSString*)cellIdentifer;
+(id)createCell;

@end
