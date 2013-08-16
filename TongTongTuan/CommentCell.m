//
//  CommentCell.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-16.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)updateUI:(Comment *)comment
{
    self.nicknameLabel.text = comment.username;
    self.publishDateLabel.text = comment.createdatestr;
    self.commentContentLabel.text = comment.comment;
    
    [self.scoreStarImageView drawStarWithScore:comment.score_service];
}
@end
