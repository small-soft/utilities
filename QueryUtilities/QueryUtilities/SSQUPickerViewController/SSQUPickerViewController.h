//
//  SSQUPickerViewController.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-4.
//
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "SSViewController.h"
@interface SSQUPickerViewController : SSViewController<UIPickerViewDataSource,UIPickerViewDelegate,RKRequestDelegate>
@property (nonatomic,retain) IBOutlet UIPickerView * pickerView;
@property (nonatomic, retain) RKRequest * request;
@property (nonatomic, retain) IBOutlet UIButton * selectButton;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;
-(void)loadObjectsFromRemote;
@end
