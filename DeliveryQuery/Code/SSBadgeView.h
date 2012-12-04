//
//  SSBadgeView.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-12-4.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    AMBadgeViewAlignmentTopLeft,
    AMBadgeViewAlignmentTopRight,
    AMBadgeViewAlignmentTopCenter,
    AMBadgeViewAlignmentCenterLeft,
    AMBadgeViewAlignmentCenterRight,
    AMBadgeViewAlignmentBottomLeft,
    AMBadgeViewAlignmentBottomRight,
    AMBadgeViewAlignmentBottomCenter,
    AMBadgeViewAlignmentCenter,
    AMBadgeViewAlignmentNull
} AMBadgeViewAlignment;

@interface SSBadgeView : UIView

@property (nonatomic, copy) NSString *badgeText;

#pragma mark - Customization

@property (nonatomic, assign) AMBadgeViewAlignment badgeAlignment;

@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, assign) CGSize badgeTextShadowOffset;
@property (nonatomic, strong) UIColor *badgeTextShadowColor;

@property (nonatomic, strong) UIFont *badgeTextFont;

@property (nonatomic, strong) UIColor *badgeBackgroundColor;

/**
 * @discussion color of the overlay circle at the top. Default is semi-transparent white.
 */
@property (nonatomic, strong) UIColor *badgeOverlayColor;

/**
 * @discussion allows to shift the badge by x and y points.
 */
@property (nonatomic, assign) CGPoint badgePositionAdjustment;

/**
 * @discussion (optional) If not provided, the superview frame is used.
 * You can use this to position the view if you're drawing it using drawRect instead of `-addSubview:`
 */
@property (nonatomic, assign) CGRect frameToPositionInRelationWith;

/**
 * @discussion optionally init using this method to have the badge automatically added to another view.
 */
- (id)initWithParentView:(UIView *)parentView alignment:(AMBadgeViewAlignment)alignment;

@end

