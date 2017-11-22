//
//  RGCollectionViewCell.m
//  RGPageView
//
//  Created by Robin on 16/8/12.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "RGCollectionViewCell.h"


@interface RGCollectionViewCell ()

@end

@implementation RGCollectionViewCell

- (void)setupDataSource:(NSIndexPath *)indexPath data:(id)data collectionView:(UICollectionView *)collectionView{
    if ([self.cellInfo isEqual:indexPath]) {
        NSLog(@"重用");
        return;
    }
    NSLog(@"赋值%@",data);
    _cellInfo = indexPath;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    [self.contentView addSubview:self.listTableView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.listTableView.frame = self.bounds;
}

- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor  = [UIColor clearColor];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
    }
    return _listTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"NULL"];
}

@end
