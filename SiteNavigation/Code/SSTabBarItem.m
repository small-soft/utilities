//
//  SSTabBarItem.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import "SSTabBarItem.h"
#import "SSBadgeView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface SSTabBarItem(){
}

@property (retain, nonatomic) UIImageView * badgeView;
@end


@implementation SSTabBarItem

@synthesize itemIcon = _itemIcon;
@synthesize itemTitle = _itemTitle;
@synthesize itemHighlighted = _itemHighlighted;
@synthesize showBadge = _showBadge;
//@synthesize badgeText = _badgeText;
@synthesize badgeView = _badgeView;

- (void)dealloc {
    [_itemIcon release];
    [_itemTitle release];
    //    [_badgeText release];
    [_badgeView release];
    [super dealloc];
}

-(void)setupView
{
    self.itemTitle.fontSize = 11.0;
    self.itemTitle.r = 0xac;
    self.itemTitle.g = 0xac;
    self.itemTitle.b = 0xac;
    self.itemTitle.textAlignment = UITextAlignmentCenter;
    //    self.showBadge = YES;
    
    //    CGRect bvFrame = CGRectMake(35.0, 1.0, 0, 0);
    self.badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-11, 1, 11, 11)];
    self.badgeView.image = [UIImage imageNamed:@"message_icon_new.png"];
    self.badgeView.userInteractionEnabled = NO;
    self.showBadge = NO;
    [self addSubview:self.badgeView];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

+(id)createView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AliTabItemView"
                                                 owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[SSTabBarItem class]])
        {
            SSTabBarItem*obj =  (SSTabBarItem *)oneObject;
            [obj setupView];
            return  obj;
        }
    }
    return nil;
}

//-(void)setBadgeText:(NSString *)badgeText{
//    _badgeText = badgeText;
//    self.badgeView.badgeText = _badgeText;
//}

-(void)setShowBadge:(BOOL)showBadge
{
    _showBadge = showBadge;
    [self.badgeView setHidden:(!_showBadge)];
}

-(void)setItemHighlighted:(BOOL)itemHighlighted
{
    _itemHighlighted = itemHighlighted;
    if (itemHighlighted) {
        self.itemTitle.textColor =  RGB(0xff,0x73,0x00);
    }
    else {
        self.itemTitle.textColor =  RGB(0xac,0xac,0xac);
    }
}

@end

