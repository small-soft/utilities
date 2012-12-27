//
//  SSButton.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-15.
//
//

#import "SSButton.h"

@implementation SSButton

@synthesize params = _params;

-(void)dealloc {
    self.params = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
