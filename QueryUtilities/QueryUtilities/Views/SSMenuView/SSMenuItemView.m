//
//  SSMenuItemView.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-25.
//
//

#import "SSMenuItemView.h"

@implementation SSMenuItemView
@synthesize imageView = _imageView;
@synthesize label = _label;
@synthesize button = _button;
@synthesize maskImageView = _maskImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc{
    self.imageView = nil;
    self.label = nil;
    self.button = nil;
    self.maskImageView = nil;
    [super dealloc];
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setTag:(NSInteger)tag {
	self.button.tag = tag;
}

- (NSInteger)tag {
	return self.button.tag;
}
@end
