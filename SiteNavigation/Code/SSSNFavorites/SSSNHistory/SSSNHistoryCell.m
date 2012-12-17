//
//  SSSNHostSitesCell.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-10.
//
//

#import "SSSNHistoryCell.h"
#import "SSLinkLabel.h"
#import "SSFullWebViewController.h"
#import "NSDate+DateUtil.h"

@interface SSSNHistoryCell()

@property(nonatomic,retain) IBOutlet UILabel *title;
@property(nonatomic,retain) IBOutlet UILabel *time;
@property(nonatomic,retain) IBOutlet UILabel *url;
@end

@implementation SSSNHistoryCell
@synthesize title = _title;
@synthesize time = _time;
@synthesize url = _url;
@synthesize delBtn = _delBtn;

- (void)dealloc {
    self.time =nil;
    self.title = nil;
    self.url = nil;
    self.delBtn = nil;
    
    [super dealloc];
}

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

-(void)cellData:(SSFav *)data {
    self.time.text = [data.date getDateStringForTodayYesterday];
    self.title.text = data.title;
    self.url.text = data.url;
}

-(void)setupView
{
    //    self.bg.layer.borderWidth = 1;
    //    self.bg.layer.cornerRadius = 12;
    //    self.bg.layer.borderColor = [[UIColor grayColor] CGColor];
    //
    //    if (self.backgroundView == nil) {
    //        self.backgroundView = [[[UIView alloc]init]autorelease];
    //    }
    //
    //    self.call.layer.cornerRadius = 12;
    //
    //    self.comment.backgroundColor = [UIColor whiteColor];
    //
    //    _companyName.text = [NSString stringWithFormat:@"%@(%@)",self.result.expTextName,[self.result getStatusDescription]];
    //    _companyLogo.image = [UIImage imageNamed:self.result.expSpellName];
    //    _deliveryNumber.text = [NSString stringWithFormat:@"单号:%@", self.result.mailNo];
    //    self.comment.text = self.result.comment;
    //
    //    NSString *st = DEFAULT_CONTEXT;
    //    if (self.result.sendTime.length > 0) {
    //        st = self.result.sendTime;
    //    }
    //    _sendTime.text = [NSString stringWithFormat:@"发货时间：%@",st];
    //
    //    NSString *lc = DEFAULT_CONTEXT;
    //    if (self.result.latestContext.length>0) {
    //        lc = self.result.latestContext;
    //    }
    //    _latestContext.text = [NSString stringWithFormat:@"当前情况：%@",lc];
    //
    //    NSString *cp = DEFAULT_CONTEXT;
    //    if (self.result.companyPhone) {
    //        cp = self.result.companyPhone;
    //    }
    //    _companyPhone.text = [NSString stringWithFormat:@"%@：%@",self.result.expTextName ,cp];
    //
    //    NSString *sdt = DEFAULT_CONTEXT;
    //    if (self.result.signTime) {
    //        sdt = self.result.signTime;
    //    }
    //    _signedTime.text = [NSString stringWithFormat:@"签收时间：%@",sdt];
    //
    //    [self.call addTarget:self action:@selector(callTouchDown) forControlEvents:UIControlEventTouchDown];
    //    [self.call addTarget:self action:@selector(callTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    //    [self.call addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}
+(CGFloat)cellHeight
{
    return 44;
}
+(CGFloat)cellWidth
{
    return SCREEN_WIDTH;
}
+(NSString*)cellIdentifer
{
    return @"SSSNHC";
}
+(id)createCell
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSSNHistoryCell"
                                                 owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[SSSNHistoryCell class]])
        {
            SSSNHistoryCell *obj = (SSSNHistoryCell *)oneObject;
            obj.frame = CGRectMake(0.0, 0.0, [SSSNHistoryCell cellWidth], [SSSNHistoryCell cellHeight]);
            [obj setupView];
            
            return  obj;
        }
    }
    return nil;
}

-(void)myLabel:(SSLinkLabel *)myLabel touchesWtihTag:(NSInteger)tag{
    SSFullWebViewController *controller = [[[SSFullWebViewController alloc]init]autorelease];
    
    controller.url = myLabel.url;
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

@end
