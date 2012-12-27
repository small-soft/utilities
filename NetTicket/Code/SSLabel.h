//
//  SSLabel.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import <Foundation/Foundation.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface SSLabel : UILabel
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat r;
@property (nonatomic) CGFloat g;
@property (nonatomic) CGFloat b;
@property (nonatomic) BOOL bold;
@property (nonatomic) VerticalAlignment verticalAlignment;
-(void)setupView;
@end
