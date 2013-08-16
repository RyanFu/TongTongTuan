//
//  ProductDetailController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-14.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductDetailController.h"
#import "RESTFulEngine.h"
#import "SIAlertView.h"
#import "CommentListView.h"
#import "CommentListController.h"
#import "ProductRichTextInfoController.h"

static const CGFloat lMargin = 10.0,            
                     rMargin = lMargin,
                     tMargin = 8;

@interface ProductDetailController()<UIScrollViewDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoAlbumImageView;

// 浮动视图区
@property (weak, nonatomic) IBOutlet UIView *floatView;
@property (weak, nonatomic) IBOutlet UILabel *costPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *notVIPPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *VIPPriceLabel;

// 简介区
@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *consumerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *refundIcon1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *refundIcon2ImageView;

// 商家信息
@property (weak, nonatomic) IBOutlet UIView *merchantInfoView;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantDistanceLabel;

// 团购详情
@property (weak, nonatomic) IBOutlet UIView *detailAboutPurchaseView;
@property (weak, nonatomic) IBOutlet UIWebView *detailAboutPurchaseWebView;
@property (weak, nonatomic) IBOutlet UIImageView *dottedLineImageView;

// 购买必知
@property (weak, nonatomic) IBOutlet UIView *importTipsView;
@property (weak, nonatomic) IBOutlet UIWebView *importTipsWebView;

// 评论列表
@property (weak, nonatomic) IBOutlet UIView *commentListView;
@property (weak, nonatomic) IBOutlet CommentListView *commentTableView;
@property (weak, nonatomic) IBOutlet UIButton *viewAllCommentButton;

@end


@implementation ProductDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.commentTableView.rowHeight = 60;
}

- (void)setProduct:(Product *)product
{
    _product = product;
    if(product.isLoadedDetail){
        [self updateViewContext];
    }else{
        [self getProductDetail];
    }
}

- (void)getProductDetail
{
    [RESTFulEngine getProductDetail:self.product onSuccess:^(JSONModel *aModelBaseObject) {
        Product *p = (Product *)aModelBaseObject;
        [self.product copyDetailInfoToSelf:p];
        [self updateViewContext];
    } onError:^(NSError *engineError) {
        NSString *reason = [NSString stringWithFormat:@"获取产品详情失败,原因:%@",[engineError localizedDescription]];
        [SIAlertView showWithTitle:@"提示" andMessage:reason text1:@"重试" text2:@"关闭" okBlock:^{
            [self getProductDetail];
        } cancelBlock:^{}];
    }];
}

#pragma makr - 

- (void)updateViewContext
{
    self.consumerCountLabel.text = [NSString stringWithFormat:@"%.1f元",self.product.price];
    self.notVIPPriceLable.text = [NSString stringWithFormat:@"%.1f元",self.product.price_nomember];
    self.VIPPriceLabel.text = [NSString stringWithFormat:@"%.1f元",self.product.price_member];
    
    self.consumerCountLabel.text = [NSString stringWithFormat:@"已有%d人购买", self.product.virtualbuy];
    //self.remainingTimeLabel.text = [
    self.productNameLabel.text = self.product.protitle;
    self.descLabel.text = self.product.briefdescription;
    
    self.merchantNameLabel.text = self.product.shopname;
    self.merchantAddressLabel.text = self.product.address;
    self.merchantDistanceLabel.text = [NSString stringWithFormat:@"%.1fkm",self.product.distance.floatValue];
    
    [self.detailAboutPurchaseWebView loadHTMLString:self.product.promemo baseURL:nil];
    [self.importTipsWebView loadHTMLString:self.product.buyprompt baseURL:nil];
    
    if(self.product.commentList.count == 0){
        self.viewAllCommentButton.hidden = YES;
        self.commentTableView.commentListArray = [NSArray new];
    }else{
        // 在详情界面只显示一条评论
        self.commentTableView.commentListArray = [NSArray arrayWithObject:[self.product.commentList objectAtIndex:0]];
        [self.viewAllCommentButton setTitle:[NSString stringWithFormat:@"查看全部%d条评论",self.product.commentList.count]
                                   forState:UIControlStateNormal];
    }
}

//需在WebView的代理方法-(void)webViewDidFinishLoad:中调用此方法，因为只有在WebView加载完内容后才能计算出最终WebView的高度
- (void)layoutViews
{
    // 计算团购详情况的Origin.y的值
    CGFloat topMargin = self.photoAlbumImageView.bounds.size.height
                        + self.floatView.bounds.size.height
                        + self.descView.bounds.size.height
                        + self.merchantInfoView.bounds.size.height
                        + (tMargin * 2);
    CGFloat y = self.dottedLineImageView.frame.origin.y + 2; // 团购详情中用来展示内容的WebView的Origin.y的值
    CGFloat h;     // 经计算后WebView的高度
    if(self.detailAboutPurchaseWebView.scrollView.contentSize.height > self.detailAboutPurchaseWebView.bounds.size.height){
        h = self.detailAboutPurchaseWebView.scrollView.contentSize.height;
    }else{
        h = self.detailAboutPurchaseWebView.bounds.size.height;
    }
    CGRect f = self.detailAboutPurchaseView.frame;
    f.origin.y = topMargin;
    f.size.height = y + h;    // 将WebView的Origin.y的值y加上WebView本身的高度h就等于团购详情视图的高度
    self.detailAboutPurchaseView.frame = f;
    
    // 以下计算逻辑跟上面一样
    topMargin += (f.size.height + tMargin);
    if(self.importTipsWebView.scrollView.contentSize.height > self.importTipsWebView.bounds.size.height){
        h = self.importTipsWebView.scrollView.contentSize.height;
    }else{
        h = self.importTipsWebView.bounds.size.height;
    }
    f = self.importTipsView.frame;
    f.origin.y = topMargin;
    f.size.height = y + h;
    self.importTipsView.frame = f;
    
    topMargin += (f.size.height + tMargin);
    f = self.commentListView.frame;
    f.origin.y = topMargin;
    self.commentListView.frame = f;
    
    // 如果不加74,ScrollView.contentSize.height的值会过小，导致无法显示ScrollView中的所有子视图
    topMargin += (f.size.height + tMargin + 74);
    self.scrollView.contentSize = CGSizeMake(320, topMargin);
}

#pragma mark - Action
// 立即抢购
- (IBAction)buyNow:(id)sender
{
    [SIAlertView showWithTitle:@"👩👩👩👩" andMessage:@"🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫" text1:@"👨👨" text2:@"🐶🐶" okBlock:^{
        [self buyNow:nil];
    } cancelBlock:^{}];
}

// 查看所有评论
- (IBAction)viewAllComments:(id)sender
{
    CommentListController *CLC = [[CommentListController alloc] initWithNibName:@"CommentListController" bundle:nil];
    [self.navigationController pushViewController:CLC animated:YES];
    CLC.commentListArray = self.product.commentList;
}

// 查看图文详情
- (IBAction)viewRichTextInfo:(id)sender
{
    ProductRichTextInfoController *PDC = [[ProductRichTextInfoController  alloc] initWithNibName:@"ProductRichTextInfoController" bundle:nil];
    [self.navigationController pushViewController:PDC animated:YES];
}

//查看分店
- (IBAction)viewSubbranch:(id)sender
{
    
}

// 查看地图
- (IBAction)viewProductOnMap:(id)sender
{
    
}

#pragma mark - UIScrollViewDelegate
 // any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= self.photoAlbumImageView.bounds.size.height){
        CGRect f = self.floatView.frame;
        f.origin.y = scrollView.contentOffset.y;
        self.floatView.frame = f;
    }else{
        CGRect f = self.floatView.frame;
        f.origin.y = self.photoAlbumImageView.bounds.size.height;
        self.floatView.frame = f;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    static NSUInteger count = 0;
    count++;
    if(count >= 2){ // 等待2个WebView加载完内容才重新布局子视图
        [self layoutViews];
    }
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPhotoAlbumImageView:nil];
    [self setFloatView:nil];
    [self setCostPriceLabel:nil];
    [self setNotVIPPriceLable:nil];
    [self setVIPPriceLabel:nil];
    [self setDescView:nil];
    [self setConsumerCountLabel:nil];
    [self setRemainingTimeLabel:nil];
    [self setProductNameLabel:nil];
    [self setDescLabel:nil];
    [self setRefundIcon1ImageView:nil];
    [self setRefundIcon2ImageView:nil];
    [self setMerchantInfoView:nil];
    [self setMerchantNameLabel:nil];
    [self setMerchantAddressLabel:nil];
    [self setMerchantDistanceLabel:nil];
    [self setDetailAboutPurchaseView:nil];
    [self setImportTipsView:nil];
    [self setCommentListView:nil];
    [self setDetailAboutPurchaseWebView:nil];
    [self setImportTipsWebView:nil];
    [self setDottedLineImageView:nil];
    [self setCommentTableView:nil];
    [self setViewAllCommentButton:nil];
    [super viewDidUnload];
}
@end
