//
//  SSSNHostSitesCell.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-10.
//
//

#import "SSSNHostSitesCell.h"
#import "SSLinkLabel.h"
#import "SSFullWebViewController.h"
#import "SSSNHotSitesMoreViewController.h"

@interface SSSNHostSitesCell()

@property(nonatomic,retain) IBOutlet UILabel *catTitle;
@property(nonatomic,retain) NSMutableArray *links;
@property(nonatomic,retain) IBOutlet UIImageView *icon;
@property(nonatomic,retain) IBOutlet UIControl *mask;
@end

@implementation SSSNHostSitesCell
@synthesize parentViewController = _parentViewController;
@synthesize data = _data;
@synthesize catTitle = _catTitle;
@synthesize links = _links;
@synthesize icon = _icon;
@synthesize mask = _mask;

- (void)dealloc {
    self.data = nil;
    self.parentViewController = nil;
    self.catTitle = nil;
    self.links = nil;
    self.icon = nil;
    self.mask = nil;
    
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
    
    
    if (self.links == nil || self.links.count <= 0) {
        self.links = [NSMutableArray arrayWithCapacity:9];
        for (int i=0; i<9; i++) {
            
            int x = i%3;
            int y = i/3;
            
            SSLinkLabel *link = [[SSLinkLabel alloc]initWithFrame:CGRectMake(79 + x*76, 12+y*31, 68, 16)];
            link.font = [UIFont systemFontOfSize:16];
            link.textAlignment = UITextAlignmentCenter;
            [self.links addObject:link];
            [self.contentView addSubview:link];
        }
    }
    
    int count = self.data.sites.count;
    for (int i=0; i<9; i++) {
        SSLinkLabel *link = [self.links objectAtIndex:i];
        
        if (i == count || i == 8) {
            link.text = @"更多";
            link.delegate = self;
            link.hidden = NO;
        }else if(i > count){
            link.hidden = YES;
        }else{
            SSSNSites *site =  [self.data.sites objectAtIndex:i];
            
            link.url = [NSURL URLWithString:site.url];
            link.text = site.title;
            link.delegate = self;
            link.hidden = NO;
        }
        
        
    }
    
    
    
    if (self.data == nil) {
        return;
    }
    
    self.catTitle.text = self.data.title;
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"siteCat%d",self.data.id]];
    
    [self.mask addTarget:self action:@selector(jumpToMore) forControlEvents:UIControlEventTouchUpInside];
    [self.mask addTarget:self action:@selector(iconDown) forControlEvents:UIControlEventTouchDown];
    [self.mask addTarget:self action:@selector(iconUp) forControlEvents:UIControlEventTouchUpOutside];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}
+(CGFloat)cellHeight
{
    return 103.0;
}
+(CGFloat)cellWidth
{
    return SCREEN_WIDTH;
}
+(NSString*)cellIdentifer
{
    return @"SSSNHSC";
}
+(id)createCell
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSSNHostSitesCell"
                                                 owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[SSSNHostSitesCell class]])
        {
            SSSNHostSitesCell *obj = (SSSNHostSitesCell *)oneObject;
            obj.frame = CGRectMake(0.0, 0.0, [SSSNHostSitesCell cellWidth], [SSSNHostSitesCell cellHeight]);
            [obj setupView];
            
            return  obj;
        }
    }
    return nil;
}

-(void)myLabel:(SSLinkLabel *)myLabel touchesWtihTag:(NSInteger)tag{
    
    
    if ([myLabel.text isEqualToString:@"更多"]) {
        [self jumpToMore];
    }
    
    SSFullWebViewController *controller = [[[SSFullWebViewController alloc]init]autorelease];
    controller.url = myLabel.url;
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

-(void)jumpToMore {
    [self iconUp];
    
    SSSNHotSitesMoreViewController *more = [[[SSSNHotSitesMoreViewController alloc]init]autorelease];
    more.data = self.data;
    
    SET_GRAY_BG(more);
    [self.parentViewController.navigationController pushViewController:more animated:YES];
}

-(void)iconDown{
    self.mask.backgroundColor = [UIColor lightGrayColor];
    self.mask.alpha = 0.3;
}

-(void)iconUp{
    self.mask.backgroundColor = [UIColor clearColor];
    self.mask.alpha = 1;
}
@end
