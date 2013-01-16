//
//  SSTextFieldCell.m
//  NetTicket
//
//  Created by 神逸 on 13-1-8.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import "SSTextFieldCell.h"

@implementation SSTextFieldCell
@synthesize textView = _textView;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management
-(void)dealloc {
    self.textView = nil;
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

-(void)setupView {
    
}

+(CGFloat)cellHeight
{
    return 66;
}

+(CGFloat)cellWidth
{
    return SCREEN_WIDTH;
}

+(NSString*)cellIdentifer
{
    return @"SSTFC";
}

+(id)createCell
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSTextFieldCell"
                                                 owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[SSTextFieldCell class]])
        {
            SSTextFieldCell *obj = (SSTextFieldCell *)oneObject;
            obj.frame = CGRectMake(0.0, 0.0, [SSTextFieldCell cellWidth], [SSTextFieldCell cellHeight]);
            [obj setupView];
            
            return  obj;
        }
    }
    return nil;
}


@end
