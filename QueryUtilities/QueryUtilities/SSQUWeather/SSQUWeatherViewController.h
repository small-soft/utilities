//
//  SSQUWeatherViewController.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-27.
//
//

#import <UIKit/UIKit.h>

@interface SSQUWeatherViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (retain, nonatomic) IBOutlet UIPickerView *locationPicker;

@end

