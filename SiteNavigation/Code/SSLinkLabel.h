//
//  SSLinkLabel.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-10.
//
//

#import <Foundation/Foundation.h>
@class SSLinkLabel;
@protocol SSLinkLabelDelegate <NSObject>
@required
- (void)myLabel:(SSLinkLabel *)myLabel touchesWtihTag:(NSInteger)tag;
@end

@interface SSLinkLabel : UILabel {
    id <SSLinkLabelDelegate> delegate;
}
@property (nonatomic, assign) id <SSLinkLabelDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
- (void)initWithLink:(NSURL *)url;
@property (nonatomic,retain) NSURL *url;
@end
