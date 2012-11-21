//
//  SSDQDeliveryQueryViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
// http://api.ickd.cn/?id=EAB9372F87E8CCF9570F4F759E255CE6&com=shunfeng&nu=102494116867&type=xml&order=DESC

#import "SSDQDeliveryQueryViewController.h"
#import "SSMapping4RestKitUtils.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSDQAllDeliveryCompanyListViewController.h"
#import "SSDQDeliveryQueryResultViewController.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"

@interface SSDQDeliveryQueryViewController ()
@property (nonatomic,retain) IBOutlet UILabel *resultText;
@property (nonatomic,retain) IBOutlet UILabel *companyName;
@property (nonatomic,retain) IBOutlet UITextField *deliveryNumber;
@property (nonatomic,retain) IBOutlet UIImageView *resultImage;
@property (nonatomic,retain) RKRequest *request;

@property (nonatomic,copy) NSString *code;

@end

@implementation SSDQDeliveryQueryViewController
@synthesize resultText = _resultText;
@synthesize resultImage = _resultImage;
@synthesize company = _company;
@synthesize companyName = _companyName;
@synthesize deliveryNumber = _deliveryNumber;
@synthesize request = _request;
@synthesize code = _code;

-(void)dealloc{
    [_resultImage release];
    [_resultText release];
    [_company release];
    [_companyName release];
    [_deliveryNumber release];
    [_request cancel];
    [_request release];
    [_code release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(void)viewDidUnload {
    [_resultImage release];
    [_resultText release];
    [_company release];
    [_companyName release];
    [_deliveryNumber release];
    [_request release];
    [_code release];
    
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.company) {
        self.companyName.text = self.company.name;
    }
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
    
    [self.loadingView showLoadingView];
    if (self.company == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://api.ickd.cn/?id=EAB9372F87E8CCF9570F4F759E255CE6&com=%@&nu=%@&type=json&order=DESC",self.company.code, self.deliveryNumber.text];
    
    self.request = [RKRequest requestWithURL:[NSURL URLWithString:url]];
    
    if (self.request!=nil) {
        self.request.delegate = self;
//        [self.loadingView showLoadingView];
        [self.request send];
    }
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
    
    SSDQDeliveryResult * result = [SSMapping4RestKitUtils performMappingWithMapping:[SSDQDeliveryResult sharedObjectMapping] forJsonString:[response bodyAsString]] ;

    
    if (result==nil)
    {
        self.resultText.text = @"抱歉！查无结果";
    }else{
//        self.resultText.text = result.expSpellName;
        if (result.status == SSDQDeliveryResultStatusFailed && result.errCode!=SSDQDeliveryResultErrorCodeNoError) {
            NSString *msg = [NSString stringWithFormat:@"%@！要保存查询记录吗？",[result getErrorDescription]];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查询失败" message:msg delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            
            [alert show];
            [self.loadingView hideLoadingView];
            return;
        }
        
        [self addDelivery:result];
        
        [self enterDetail];
    }
    self.resultText.numberOfLines = 0;
    CGSize constraint = CGSizeMake(260, 20000.0f);
    CGSize labelSize = [self.resultText.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//
    self.resultText.frame = CGRectMake(self.resultText.frame.origin.x, self.resultText.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
}

#pragma mark –
#pragma mark onClickButton
-(IBAction)onButton:(id)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSLog(@"===%@",symbol.data);
    self.deliveryNumber.text= symbol.data;
    _resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    [reader dismissModalViewControllerAnimated: YES];
}

-(IBAction)selectDeliveryCompany:(id)sender {
    SSDQAllDeliveryCompanyListViewController *dcl = [[SSDQAllDeliveryCompanyListViewController alloc]init];
    dcl.displayMode = DeliverCompanyListDisplayModeSelect;
    dcl.contentMode = DeliverCompanyListContentModeAll;
    [self.navigationController pushViewController:dcl animated:YES];
    [dcl release];
}

-(IBAction)query:(id)sender {
    
    if (self.company.code.length <=0 || self.deliveryNumber.text.length <=0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请完整输入快递公司和快递单号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    // 如果已经签收了，就不查询了
    if (![self isFinished]) {
        [self loadObjectsFromRemote];
    }else{
        [self enterDetail];
    }
    
    [self.deliveryNumber resignFirstResponder];
    
}

-(void)addDelivery:(SSDQDeliveryResult *) result {
    
    if (result == nil) {
        return;
    }
    
    result.id = [[self isQueryed] id];
    
    FMDatabase *db = GETDB;
    
    if ([db open]) {
        NSString *str;
        NSString *sendTime = @"";
        NSString *latestContext = @"";
        NSString *signTime = @"";
        
        if (result.data && [result.data count] > 0) {
            SSDQDeliveryItem *earliestItem = [result.data lastObject];
            sendTime = earliestItem.time;
            
            SSDQDeliveryItem *latestItem = [result.data objectAtIndex:0];
            latestContext = latestItem.context;
            
            if (result.status == SSDQDeliveryResultStatusSigned) {
                signTime = latestItem.time;
            }
            
        }
        
        if (result.id == 0) {
            str = [NSString stringWithFormat:@"insert into DeliveryQueryHistoryMain (companyCode,companyName,deliveryNumber,status,sendTime,signTime,latestContext,companyPhone) values('%@','%@','%@',%d,'%@','%@','%@','%@')",result.expSpellName,result.expTextName,result.mailNo,result.status,sendTime,signTime,latestContext,self.company.phone];
        } else {
            str = [NSString stringWithFormat:@"update DeliveryQueryHistoryMain set status=%d,errCode=%d,sendTime='%@',signTime='%@',latestContext='%@' where id = %d",result.status,result.errCode,sendTime,signTime,latestContext, result.id];
            
            // 删除
            NSString *delItemsSql = [NSString stringWithFormat:@"delete from  DeliveryQueryHistoryItems where mainId = %d",result.id];
            [db executeUpdate:delItemsSql];
        }
        
        
        BOOL success = [db executeUpdate:str];
        NSLog(@"result is %d",success);
        
        
        if (result.id == 0) {
            NSString *sql = [NSString stringWithFormat: @"SELECT * from DeliveryQueryHistoryMain where companyCode = '%@' and deliveryNumber = '%@'",result.expSpellName,result.mailNo];
            
            NSLog(@"execute sql:%@",sql);
            FMResultSet *rs = [db executeQuery:sql];
            
            if ([rs next]) {
                result.id = [rs intForColumn:@"id"];
            }
            
        }
        
        
        for (int i=0; i < [result.data count]; i++) {
            SSDQDeliveryItem *item = [result.data objectAtIndex:i];
            
            NSString *itemSql = [NSString stringWithFormat:@"insert into DeliveryQueryHistoryItems (time,context,mainId) values('%@','%@',%d)",item.time,item.context,result.id];
            
            [db executeUpdate:itemSql];
        }
        
    }
    
    [db close];
}

-(SSDQDeliveryResult*)isQueryed{
    FMDatabase *db = GETDB;
    
    if (self.deliveryNumber.text.length <=0 && self.company.code.length <=0) {
        return nil;
    }
    
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat: @"SELECT * from DeliveryQueryHistoryMain where companyCode = '%@' and deliveryNumber = '%@'",self.company.code,self.deliveryNumber.text];
        
        NSLog(@"execute sql:%@",sql);
        FMResultSet *rs = [db executeQuery:sql];
        
        if ([rs next]) {
            NSLog(@"isQueryed:%d",[rs intForColumn:@"id"]);
            SSDQDeliveryResult *result = [[[SSDQDeliveryResult alloc]init]autorelease];
            result.id = [rs intForColumn:@"id"];
            result.status = [rs intForColumn:@"status"];
            
            return result;
        }
    }
    
    [db close];
    
    return nil;
}

-(BOOL)isFinished {
    SSDQDeliveryResult *result = [self isQueryed];
    
    return result && result.id > 0 && result.status == SSDQDeliveryResultStatusSigned;
}

-(void)enterDetail {
    SSDQDeliveryQueryResultViewController *dqr = [[SSDQDeliveryQueryResultViewController alloc]init];
    dqr.title = @"快递详情";
    dqr.companyCode = self.company.code;
    dqr.deliveryNumber = self.deliveryNumber.text;
    
    [self.navigationController pushViewController:dqr animated:YES];
    [dqr release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            SSDQDeliveryResult *result = [[SSDQDeliveryResult alloc]init];
            result.mailNo = self.deliveryNumber.text;
            result.expSpellName = self.company.code;
            result.expTextName = self.company.name;
            result.status = SSDQDeliveryResultStatusFailed;
            result.errCode = SSDQDeliveryResultErrorCodeNumberNotExist;
            
            [self addDelivery:result];
            [self enterDetail];
        }
            
            break;
            
        default:
            break;
    }
}
@end
