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

static const CGFloat lMargin = 10.0,            
                     rMargin = lMargin,
                     tMargin = 8;

static CGFloat photoAlbumHeight,                      // 商品相册封面高
               floatViewHeight,                       // 浮动视图高
               descViewHeight,                        // 商品描述视图高
               merchantInfoViewHeight,                // 商家信息视图高
               detailAboutPurchaseViewOriginaHeight,  // 团购详情视图初始高
               importTipsViewOriginalHeight,          // 购买提示视图初始高
               webViewOriginalHeight,                 // 团购详情和购买提示中webView视图初始高
               commentListViewOriginalHeight;         // 评论列表初始高


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

// 购买必知
@property (weak, nonatomic) IBOutlet UIView *importTipsView;
@property (weak, nonatomic) IBOutlet UIWebView *importTipsWebView;

// 评论列表
@property (weak, nonatomic) IBOutlet UIView *commentListView;

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
    
    // 获取各视图的初始高度
    photoAlbumHeight = self.photoAlbumImageView.bounds.size.height;
    floatViewHeight = self.floatView.bounds.size.height;
    descViewHeight = self.descView.bounds.size.height;
    merchantInfoViewHeight = self.merchantInfoView.bounds.size.height;
    detailAboutPurchaseViewOriginaHeight = self.detailAboutPurchaseView.bounds.size.height;
    importTipsViewOriginalHeight = self.importTipsView.bounds.size.height;
    webViewOriginalHeight = self.detailAboutPurchaseWebView.bounds.size.height;
    commentListViewOriginalHeight = self.commentListView.bounds.size.height;
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
    
//    self.merchantNameLabel.text = 
//    self.merchantAddressLabel.text =
//    self.merchantDistanceLabel.text =
    
    [self.detailAboutPurchaseWebView loadHTMLString:self.product.promemo baseURL:nil];
    [self.importTipsWebView loadHTMLString:self.product.buyprompt baseURL:nil];
}

- (void)layoutViews
{
    CGFloat h = photoAlbumHeight + floatViewHeight + descViewHeight + merchantInfoViewHeight  + (3 * tMargin);
    CGFloat h1 = self.detailAboutPurchaseWebView.scrollView.contentSize.height;
    CGFloat h2 = self.importTipsWebView.scrollView.contentSize.height;
    CGFloat h3 = h1 > webViewOriginalHeight ? (detailAboutPurchaseViewOriginaHeight + h1 - webViewOriginalHeight) : detailAboutPurchaseViewOriginaHeight;
    CGFloat h4 = h2 > webViewOriginalHeight ? (importTipsViewOriginalHeight + h2 - webViewOriginalHeight) : importTipsViewOriginalHeight;
    
    CGRect f1 = self.detailAboutPurchaseView.frame;
    f1.size.height = h3;
    f1.origin.y = h;
    self.detailAboutPurchaseView.frame = f1;
    
    h += (h3 + tMargin);
    
    CGRect f2 = self.importTipsView.frame;
    f2.size.height = h4;
    f2.origin.y = h;
    self.importTipsView.frame = f2;
    
    h += (h4 + tMargin);
    
    CGRect f3 = self.commentListView.frame;
    f3.origin.y = h;
    self.commentListView.frame = f3;
    
    h += commentListViewOriginalHeight + 80;
    
    self.scrollView.contentSize = CGSizeMake(320, h);
    
}

#pragma mark - Action
// 立即抢购
- (IBAction)buyNow:(id)sender
{
    [SIAlertView showWithTitle:@"👩👩👩👩" andMessage:@"🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫" text1:@"👨👨" text2:@"🐶🐶" okBlock:^{
        [self buyNow:nil];
    } cancelBlock:^{}];
}


#pragma mark - UIScrollViewDelegate
 // any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= photoAlbumHeight){
        CGRect f = self.floatView.frame;
        f.origin.y = scrollView.contentOffset.y;
        self.floatView.frame = f;
    }else{
        CGRect f = self.floatView.frame;
        f.origin.y = photoAlbumHeight;
        self.floatView.frame = f;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    static NSUInteger count = 0;
    count++;
    if(count >= 2){
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
    [super viewDidUnload];
}
@end
