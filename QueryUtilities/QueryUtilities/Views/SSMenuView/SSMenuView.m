//
//  SSMenuView.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-25.
//
//

#import "SSMenuView.h"

@interface SSMenuView()
@property (nonatomic, retain) NSMutableArray *itemViews;
- (void)setupItemViews;
- (void)itemPressed:(id)sender;
@end

@implementation SSMenuView
@synthesize menuDelegate = _menuDelegate;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize itemViews = _itemViews;
@synthesize columnCount = _columnCount;
@synthesize itemSize = _itemSize;
@synthesize topPadding = _topPadding;
@synthesize leftPadding = _leftPadding;
@synthesize bottomPadding = _bottomPadding;
@synthesize yPadding = _yPadding;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemViews = [[NSMutableArray alloc] init];
		_backgroundImageView = [[UIImageView alloc]init];
		// set some defaults
		_columnCount = 4;
		_itemSize = CGSizeMake(80, 80);
        _yPadding = -1;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	
	if (self = [super initWithCoder:aDecoder]) {
		_itemViews = [[NSMutableArray alloc] init];
		_backgroundImageView = [[UIImageView alloc]init];
		// set some defaults
		_columnCount = 4;
		_itemSize = CGSizeMake(80, 80);
        _yPadding = -1;
	}
	
	return self;
}
-(void)dealloc{
    self.itemViews = nil;
    self.backgroundImageView = nil;
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
