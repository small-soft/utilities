//
//  SSLabel.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import "SSLabel.h"

@implementation SSLabel
@synthesize r = _r;
@synthesize g = _g;
@synthesize b = _b;
@synthesize fontSize = _fontSize;
@synthesize bold = _bold;
@synthesize verticalAlignment = _verticalAlignment;

-(void)setupView
{
    self.textColor = RGB(self.r,self.g,self.b);
    self.highlightedTextColor = RGB(self.r,self.g,self.b);
    if (self.bold) {
        self.font = [UIFont boldSystemFontOfSize:self.fontSize];
    }
    else {
        self.font = [UIFont systemFontOfSize:self.fontSize];
    }
    self.minimumFontSize = self.fontSize;
    self.contentMode= UIViewContentModeTopLeft;
    self.backgroundColor = [UIColor clearColor];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.verticalAlignment = VerticalAlignmentTop;
    [self setupView];
}



-(void) setVerticalAlignment:(VerticalAlignment)value
{
    _verticalAlignment = value;
    [self setNeedsDisplay];
}

// align text block according to vertical alignment settings
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    CGRect result;
    switch (_verticalAlignment)
    {
        case VerticalAlignmentTop:
            result = CGRectMake(rect.origin.x, bounds.origin.y, rect.size.width, rect.size.height);
            break;
        case VerticalAlignmentMiddle:
            result = CGRectMake(rect.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height) / 2, rect.size.width, rect.size.height);
            break;
        case VerticalAlignmentBottom:
            result = CGRectMake(rect.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height);
            break;
        default:
            result = bounds;
            break;
    }
    return result;
}

-(void)drawTextInRect:(CGRect)rect
{
    CGRect r = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    
    
    [super drawTextInRect:r];
}


@end

