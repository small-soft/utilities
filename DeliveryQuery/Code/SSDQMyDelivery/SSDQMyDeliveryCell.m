//
//  SSDQDeliveryCompanyListCell.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-12.
//
//

#define DEFAULT_CONTEXT @"暂无"

#import "SSDQMyDeliveryCell.h"
#import "SSDQDeliveryCompany.h"
#import "SSSystemUtils.h"

@interface SSDQMyDeliveryCell ()

@property(nonatomic,retain) IBOutlet UIImageView *companyLogo;
@property(nonatomic,retain) IBOutlet UILabel *companyName;
@property(nonatomic,retain) IBOutlet UILabel *sendTime;
@property(nonatomic,retain) IBOutlet UILabel *latestContext;
@property(nonatomic,retain) IBOutlet UILabel *deliveryNumber;
@property(nonatomic,retain) IBOutlet UILabel *companyPhone;
@property(nonatomic,retain) IBOutlet UIControl *call;

@end

@implementation SSDQMyDeliveryCell

@synthesize companyLogo = _companyLogo;
@synthesize companyName = _companyName;
@synthesize sendTime = _sendTime;
@synthesize latestContext = _latestContext;
@synthesize deliveryNumber = _deliveryNumber;
@synthesize companyPhone = _companyPhone;
@synthesize call = _call;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupView
{
    _companyName.text = [NSString stringWithFormat:@"%@(%@)",self.result.expTextName,[self.result getStatusDescription]];
    _companyLogo.image = [UIImage imageNamed:self.result.expSpellName];
    _deliveryNumber.text = [NSString stringWithFormat:@"单号:%@", self.result.mailNo];
    
    NSString *st = DEFAULT_CONTEXT;
    if (self.result.sendTime.length > 0) {
        st = self.result.sendTime;
    }
    _sendTime.text = [NSString stringWithFormat:@"发货时间：%@",st];
    
    NSString *lc = DEFAULT_CONTEXT;
    if (self.result.latestContext.length>0) {
        lc = self.result.latestContext;
    }    
    _latestContext.text = [NSString stringWithFormat:@"当前情况：%@",lc];
    
    NSString *cp = DEFAULT_CONTEXT;
    if (self.result.companyPhone) {
        cp = self.result.companyPhone;
    }
    _companyPhone.text = [NSString stringWithFormat:@"%@：%@",self.result.expTextName ,cp];
    
    [self.call addTarget:self action:@selector(callTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.call addTarget:self action:@selector(callTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    [self.call addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}
+(CGFloat)cellHeight
{
    return 170.0;
}
+(CGFloat)cellWidth
{
    return SCREEN_WIDTH;
}
+(NSString*)cellIdentifer
{
    return @"SSDQMD";
}
+(id)createCell:(SSDQDeliveryResult *)result
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSDQMyDeliverCell"
                                                 owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[SSDQMyDeliveryCell class]])
        {
            SSDQMyDeliveryCell *obj = (SSDQMyDeliveryCell *)oneObject;
            obj.frame = CGRectMake(0.0, 0.0, [SSDQMyDeliveryCell cellWidth], [SSDQMyDeliveryCell cellHeight]);
            obj.result = result;
            
            [obj setupView];
            
            return  obj;
        }
    }
    return nil;
}
- (void)dealloc {
    
    [super dealloc];
}

-(void)callPhone {
    
    [self callTouchUp];
    [SSSystemUtils makeCallWithNumber:self.result.companyPhone];
}

-(void)callTouchDown {
    self.call.alpha = 0.7;
}

-(void)callTouchUp {
    self.call.alpha = 1.0;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            [SSSystemUtils makeCallWithNumber:self.result.companyPhone];
        }
            
            break;
            
        default:
            break;
    }
}
@end
