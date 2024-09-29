//
//  KJCommentCell.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import "KJCommentCell.h"
#import "YYTextLayout.h"

#define MsgTableViewWidth     288

@interface KJCommentCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *chatMsgLabel;

@end

@implementation KJCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = UIColor.clearColor;
        self.contentView.transform = CGAffineTransformMakeScale(1, -1);
        
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 11;
        
       
    }
    return self;
}

- (void)setChatModel:(KJChatModel *)chatModel {
    
    _chatModel = chatModel;
    
    self.nameLabel.text = @"111";
    self.chatMsgLabel.text = @"222- (void)setSelected:(BOOL)selected animated:(BOOL)animated {";
    
    NSString *allMessage = [NSString stringWithFormat:@"%@%@", self.nameLabel.text, self.chatMsgLabel.text];
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:allMessage];
    [mutableString setAttributes:@{NSForegroundColorAttributeName:UIColor.yellowColor} range:[allMessage rangeOfString:self.nameLabel.text]];
    self.chatMsgLabel.attributedText = mutableString;
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
    
    CGSize bgViewSize = [self YYTextLayoutSize:mutableString];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bgViewSize);
    }];
}

#pragma mark ----- 获取cell高度
- (CGSize)YYTextLayoutSize:(NSMutableAttributedString *)attribText {
    // 距离左边8  距离右边也为8
    CGFloat maxWidth = MsgTableViewWidth - 23;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, MAXFLOAT) text:attribText];
    CGSize size = layout.textBoundingSize;
    
    if (size.height && size.height < 24) {
        size.height = 24;
    } else {
        // 再加上6=文字距离上下的间距
        size.height = size.height + 6;
    }
    
    return size;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
        [self.contentView addSubview:_bgView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.leading.offset(10);
            make.trailing.offset(-10);
            make.top.offset(2);
            make.bottom.offset(-2);
        }];
    }
    return _bgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"nameLabell";
        [self.bgView addSubview:_nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(6);
            make.top.bottom.offset(0);
        }];
    }
    return _nameLabel;
}

- (UILabel *)chatMsgLabel {
    if (!_chatMsgLabel) {
        _chatMsgLabel = [[UILabel alloc] init];
        _chatMsgLabel.text = @"chatMsgLabel";
        [self.bgView addSubview:_chatMsgLabel];
        
        [self.chatMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(80);
            make.centerY.offset(0);
            make.trailing.offset(-7.5);
        }];
    }
    return _chatMsgLabel;
}

@end
