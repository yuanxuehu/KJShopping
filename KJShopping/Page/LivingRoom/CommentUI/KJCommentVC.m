//
//  KJCommentVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import "KJCommentVC.h"
#import "KJLivingChatTableView.h"
#import "KJCommentCell.h"

#import "KJChatModel.h"


@interface KJCommentVC () <UITableViewDelegate, UITableViewDataSource, KJLivingChatTableViewDelegate>

@property (nonatomic, strong) KJLivingChatTableView *tableView;

// 记录cell高度
@property (nonatomic, strong) NSMutableDictionary *cellHightDictionary;
// 数据源
@property (nonatomic, strong) NSMutableArray <KJChatModel *> *dataSource;

@end

@implementation KJCommentVC

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self setTableGradientLayer];
    
}

- (void)setTableGradientLayer {
    // 渐变蒙层
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[
                     (__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                     (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor
                     ];
    layer.locations = @[@0.0, @0.4]; // 设置颜色的范围
    layer.startPoint = CGPointMake(0, 0); // 设置颜色渐变的起点
    layer.endPoint = CGPointMake(0, 0.30); // 设置颜色渐变的终点,与 startPoint 形成一个颜色渐变方向
    layer.frame = self.view.bounds;
    
    self.view.layer.mask = layer;
}

- (void)tableViewFrame {
    
    _tableView.frame = self.view.bounds;
    _tableView.transform = CGAffineTransformMakeScale(1, -1);
}

- (void)addChatModel:(KJChatModel *)chatModel {
    [self.dataSource insertObject:chatModel atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)clearAllData {
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - slide Events

- (void)slideFromLeftToRight
{
    if (self.tableViewDelegate) {
        [self.tableViewDelegate slideFromLeftToRight];
    }
}

- (void)slideFromRightToLeft
{
    if (self.tableViewDelegate) {
        [self.tableViewDelegate slideFromRightToLeft];
    }
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KJCommentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > indexPath.row) {
        cell.chatModel = [self.dataSource objectAtIndex:indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellHightDictionary setObject:@(cell.frame.size.height) forKey:[NSString stringWithFormat:@"%@_%ld_%ld", @"KJCommentCell", (long)indexPath.section, (long)indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellHeight = [self.cellHightDictionary objectForKey:[NSString stringWithFormat:@"%@_%ld_%ld",@"KJCommentCell", (long)indexPath.section, (long)indexPath.row]];
    
    if ([cellHeight floatValue] == 0.0) {
        return UITableViewAutomaticDimension;
    }
    return [cellHeight floatValue];
}

//#pragma mark - 处理 section height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


#pragma mark - Lazy loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[KJLivingChatTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.slideDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionIndexColor = [UIColor darkGrayColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexMinimumDisplayRowCount = 20;
        _tableView.estimatedRowHeight = 20;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[KJCommentCell class] forCellReuseIdentifier:@"KJCommentCell"];
    }
    return _tableView;
}

- (NSMutableDictionary *)cellHightDictionary {
    if (!_cellHightDictionary) {
        _cellHightDictionary = [[NSMutableDictionary alloc] init];
    }
    return _cellHightDictionary;
}

- (NSMutableArray<KJChatModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
