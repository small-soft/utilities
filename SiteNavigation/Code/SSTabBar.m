//
//  SSTabBar.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import "SSTabBar.h"

@interface SSTabBar()
@property (nonatomic) BOOL isSetuped;
@property (nonatomic,retain)UIImageView *focusView;
@property (nonatomic,retain)UIImageView *backgroundView;
@end

@implementation SSTabBar

@synthesize isSetuped = _isSetuped;
@synthesize delegate =_delegate;
@synthesize selectedItem = _selectedItem;
@synthesize focusView = _focusView;
@synthesize reload = _reload;
@synthesize backgroundView = _backgroundView;
@synthesize reloadItemContent = _reloadItemContent;

-(UIImageView*)focusView
{
    if (!_focusView) {
        _focusView = [[UIImageView alloc] initWithImage:[self.delegate tabBarSelectedItemImage:self]];
    }
    return _focusView;
}

-(UIImageView*)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[self.delegate tabBarBackgroundImage:self]];
        _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return _backgroundView;
}

/*
 - (UIImage*) selectedItemImage
 {
 CGFloat tabItemWidth = (self.frame.size.width) / [self.delegate tabBarItemCount:self];
 CGSize tabBarItemSize = CGSizeMake(tabItemWidth, self.frame.size.height);
 UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
 // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
 [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(4, 4.0, tabItemWidth-8.0, self.frame.size.height-8.0)];
 
 // Generate a new image
 UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 return selectedItemImage;
 } */

-(void)setReload:(BOOL)reload
{
    if (reload) {
        _reload = reload;
        self.isSetuped = NO;
        
        for(UIView *subView in self.subviews){
            [subView removeFromSuperview];
        }
        [self setupData];
        [self setNeedsDisplay];
    }
}

-(void)setDelegate:(NSObject<CustomTabBarDelegate> *)delegate
{
    _delegate = delegate;
    [self setupData];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    // A single tab item's width is the entire width of the tab bar divided by number of items
    CGFloat tabItemWidth = (self.frame.size.width) / [self.delegate tabBarItemCount:self];
    // A half width is tabItemWidth divided by 2 minus half the width of the arrow
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (self.focusView.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

-(void)setNewSelectedItem:(NSInteger)itemIdx {
    if (self.reloadItemContent || !self.isSetuped || itemIdx!=_selectedItem) {
        
        BOOL change = YES;
        if ([self.delegate respondsToSelector:@selector(tabBarItemViewShouldDidSelected:atIndex:)]) {
            change = [self.delegate tabBarItemViewShouldDidSelected:self atIndex:itemIdx];
        }
        
        if (change) {
            if ([self.delegate respondsToSelector:@selector(tabBarItemViewUnHighlighted:atIndex:)]) {
                [self.delegate tabBarItemViewUnHighlighted:self atIndex:_selectedItem];
            }
            
            if ([self.delegate respondsToSelector:@selector(tabBarItemViewHighlighted:atIndex:)]) {
                [self.delegate tabBarItemViewHighlighted:self atIndex:itemIdx];
            }
            
            if ([self.delegate respondsToSelector:@selector(tabBarSelectedItemImage:)]) {
                self.focusView.frame = CGRectMake([self horizontalLocationFor:itemIdx], 0, self.frame.size.width / [self.delegate tabBarItemCount:self], self.frame.size.height);
            }
            
            if ([self.delegate respondsToSelector:@selector(tabBarItemViewDidSelected:atIndex:)]) {
                [self.delegate tabBarItemViewDidSelected:self atIndex:itemIdx];
            }
            
            _selectedItem = itemIdx;
        }
        self.reloadItemContent = NO;
    }
}

-(void)dealloc {
    [_focusView release];
    [super dealloc];
}

-(void)setupData
{
    if (self.isSetuped)
    {
        return ;
    }
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(tabBarBackgroundImage:)])
        {
            [self addSubview:self.backgroundView];
            //            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home_tab.png"]];
        }
        
        if ([self.delegate respondsToSelector:@selector(tabBarSelectedItemImage:)])
        {
            [self addSubview:self.focusView];
        }
        
        CGFloat horizontalOffset = 0;
        NSUInteger itemCount = [self.delegate tabBarItemCount:self];
        
        for (NSUInteger i = 0 ; i < itemCount ; i++)
        {
            UIControl *item = [self.delegate tabBarItemView:self atIndex:i];
            item.frame = CGRectMake(horizontalOffset, 2.0, item.frame.size.width, item.frame.size.height);
            item.tag = i;
            item.backgroundColor = [UIColor clearColor];
            [self addSubview:item];
            horizontalOffset = horizontalOffset + item.frame.size.width;
            // Register for touch events
            [item addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        }
        
        if (!self.reload||self.selectedItem >= itemCount)
        {
            [self setNewSelectedItem:0];
        }
    }
    
    self.isSetuped = YES;
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)touchDownAction:(UIControl*)control {
    [self setNewSelectedItem:control.tag];
}

@end
