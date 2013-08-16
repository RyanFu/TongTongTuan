//
//  CommentListController.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-16.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "CommentListController.h"
#import "CommentListView.h"

@implementation CommentListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"用户评论";
    }
    return self;
}

- (void)setCommentListArray:(NSArray *)commentListArray
{
    _commentListArray = commentListArray;
    CommentListView *listView = (CommentListView *)self.view;
    listView.commentListArray = commentListArray;
}
@end
