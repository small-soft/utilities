//
//  SSKeyboardToolBar.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

typedef NS_ENUM(NSInteger, SSKeyboardToolBarType)
{
    //0：默认类型，只有隐藏按钮,1：url键盘，2：搜索键盘
    SSKeyboardToolBarTypeDefault = 0,
    SSKeyboardToolBarTypeURL,
    SSKeyboardToolBarTypeSearch,
};

#import <Foundation/Foundation.h>


@interface SSKeyboardToolBar : NSObject

@property(nonatomic) BOOL            allowShowPreAndNext;         //是否显示上一项、下一项
@property(nonatomic) BOOL            isInNavigationController;    //是否在导航视图中
@property(nonatomic,retain) UIBarButtonItem *prevButtonItem;             //上一项按钮
@property(nonatomic,retain) UIBarButtonItem *nextButtonItem;             //下一项按钮
@property(nonatomic,retain) UIBarButtonItem *hiddenButtonItem;           //隐藏按钮
@property(nonatomic,retain) UIBarButtonItem *spaceButtonItem;            //空白按钮
@property(nonatomic,retain) UIView     *currentTextField;           //当前输入框
@property(nonatomic,retain) UIToolbar *view;
@property(nonatomic,retain) NSMutableArray *btnItems;
@property(nonatomic,retain) UITextField *urlTextField;
@property(nonatomic,retain) UISearchBar *searchBar;
@property(nonatomic) SSKeyboardToolBarType type;
@property(nonatomic,retain) UIControl *mask;
//@property(nonatomic,retain) NSArray textFields;

-(id)init;

-(void)setAllowShowPreAndNext:(BOOL)isShow;

-(void)setIsInNavigationController:(BOOL)isbool;

//-(void)setTextFieldsArray:(NSArray *)array;

//-(void)showPrevious;
//
//-(void)showNext;

-(void)showBar:(UIView *)textField;

-(void)HiddenKeyBoard;

-(NSString*)getSearchString;

@end
