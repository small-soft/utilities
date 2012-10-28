//
//  SSQULoadingView.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-28.
//
//

#import "SSLoadingView.h"

@implementation SSLoadingView
@synthesize activityIndicatorView = _activityIndicatorView;

-(void)dealloc{
    self.activityIndicatorView = nil;
    [super dealloc];
}

-(id)init{
    if (self = [super init]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSLoadingView" owner:self options:nil];
        for (id oneObject in nib){
            if ([oneObject isKindOfClass:[SSLoadingView class]]){
                self = [(SSLoadingView *)oneObject retain];
                break;
            }
        }
            
    
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
-(void)showLoadingView{
    self.hidden = NO;
}

-(void)hideLoadingView{
    self.hidden = YES;
}
@end
