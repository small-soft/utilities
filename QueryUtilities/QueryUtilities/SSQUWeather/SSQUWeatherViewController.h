//
//  SSQUWeatherViewController.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-27.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"
@interface SSQUWeatherViewController : SSViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (retain, nonatomic) IBOutlet UIPickerView *locationPicker;

@end

