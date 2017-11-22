//
//  RGPage.m
//  WhatStore
//
//  Created by robin on 2017/11/14.
//  Copyright © 2017年 robin. All rights reserved.
//

#import "RGPage.h"

@interface RGPage ()<UICollectionViewDelegate,UICollectionViewDataSource,RGHeaderViewDelegate,RGCollectionViewCellDelegate>{
    
    
}
@property (nonatomic ,assign)NSInteger currentIdx;
@property (nonatomic ,strong)UICollectionViewFlowLayout *flowLayout;

@end

#define HEADER_HEIGHT 37.f
#define CELLIDENTIFER @"RGCell"
#define HEADERIDENTIFER @"RGHeader"

@implementation RGPage


- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

+ (RGPage *)RGPageWithTitles:(NSArray *)titles pages:(NSArray *)pages{
    
      RGPage *page = [[[self class] alloc] init];
//    page.pageTitles = titles;
//    page.pages = pages;
      return page;
}

+ (RGPage *)RGPageWithTitles:(NSArray<NSString *> *)titles delegate:(id<RGPageDelegate>)delegate{
    
    RGPage *page = [[[self class] alloc] init];
    page.pageTitles = titles;
    page.pageDelegate = delegate;
    return page;
}



- (RGHeaderView *)defalutHeaderView{
    
    self.headerView = [[RGHeaderView alloc] initWithFrame:CGRectZero];
    _headerView.RGDelegate = self;
    return _headerView;
}

- (UICollectionView *)defalutPageCollection{
    
    self.pageCollection = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:self.flowLayout];
    _pageCollection.backgroundColor = [UIColor whiteColor];
    _pageCollection.delegate = self;
    _pageCollection.pagingEnabled = YES;
    _pageCollection.dataSource = self;
    _pageCollection.showsHorizontalScrollIndicator = NO;
    return _pageCollection;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0.f;
        _flowLayout.minimumInteritemSpacing = 0.f;
    }
    return _flowLayout;
}

- (void)setup{
    
    self.currentIdx = 0;
    [self defalutHeaderView];
    [self defalutPageCollection];
    [self addObserver:self forKeyPath:@"currentIdx" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Override


- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"currentIdx"];
    self.headerView = nil;
}


- (void)setPageDelegate:(id<RGPageDelegate>)pageDelegate{
    
    if ([pageDelegate isEqual: _pageDelegate]) return;
    _pageDelegate = pageDelegate;
    [self registorCell];
    [self.pageCollection reloadData];
}

- (void)registorCell{
    
    if ([_pageDelegate respondsToSelector:@selector(customCell)]) {
        Class class = [self.pageDelegate customCell];
        [_pageCollection registerClass:class forCellWithReuseIdentifier:CELLIDENTIFER];
        
    }else{
        
        [_pageCollection registerNib:[UINib nibWithNibName:@"RGCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CELLIDENTIFER];
    }
}

#pragma mark - LayoutSubviews

- (UIView *)RGPageViewWithFrame:(CGRect)frame{
    
    UIView *containView = [[UIView alloc] initWithFrame:frame];
    containView.exclusiveTouch = YES;
    self.headerView.frame = CGRectMake(0, 0, frame.size.width, HEADER_HEIGHT);
    self.pageCollection.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - HEADER_HEIGHT);
    [self setLayoutWithItemSize:self.pageCollection.size];
    [containView addSubview:_headerView];
    [containView addSubview:_pageCollection];
    return containView;
}

- (void)setLayoutWithItemSize:(CGSize)itemSize{
    
    self.flowLayout.itemSize = itemSize;
    [self.pageCollection layoutIfNeeded];
}


#pragma mark setupSubviwes

- (void)setPageTitles:(NSArray *)pageTitles{
    if (![_pageTitles isEqualToArray:pageTitles]) {
        _pageTitles = pageTitles;
        self.headerView.titles = _pageTitles;
    }
}

- (void)setPages:(NSArray<UIView *> *)pages{
    if (![_pages isEqualToArray:pages]) {
        _pages = pages;
        [self.pageCollection reloadData];
    }
}

#pragma mark - CollectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.pageTitles.count? : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDENTIFER forIndexPath:indexPath];
    cell.cellDelegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.pageDelegate respondsToSelector:@selector(RGPageViewWillDisplay:indexPath:collectionView:)]) {
        [self.pageDelegate RGPageViewWillDisplay:(RGCollectionViewCell *)cell indexPath:indexPath collectionView:collectionView];
    }
}

#pragma mark - CollectionCellDelegate

- (void)didSelectCell:(id)info{
    if ([self.pageDelegate respondsToSelector:@selector(RGPageSubviewAction:)]) {
        [self.pageDelegate RGPageSubviewAction:info];
    }
}

#pragma mark - 滚动,选中同步

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger idx = floor(scrollView.contentOffset.x / SCRERNWIDTH + 0.5);
    if (idx >= self.pageTitles.count) return;
    if (idx != self.currentIdx)
        self.currentIdx = idx;
    
    //更改下划线位置
    CGPoint tempScrollPoint = scrollView.contentOffset;
    CGFloat lineCenterX = self.headerView.appearence.itemWidth/2.f;
    self.headerView.lineImageView.center = CGPointMake(lineCenterX + tempScrollPoint.x * (self.headerView.appearence.itemWidth/(SCRERNWIDTH - HEADER_GAP)) , CGRectGetHeight(self.headerView.frame) - 0.5);
}

- (void)RGScrolleToSelectedPage:(NSInteger)idx{

    [self.pageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:idx - 1000 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    if ([self.pageDelegate respondsToSelector:@selector(RGPageHeaderDidSelectItemIndex:)]) {
        [self.pageDelegate RGPageHeaderDidSelectItemIndex:idx];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentIdx"]) {
        [self.headerView RGSelectButtonWithIdx:self.currentIdx];
    }
}
@end
