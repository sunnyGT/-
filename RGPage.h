//
//  RGPage.h
//  WhatStore
//
//  Created by robin on 2017/11/14.
//  Copyright © 2017年 robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RGHeaderView.h"
#import "RGCollectionViewCell.h"

@protocol RGPageDelegate <NSObject>

@optional
- (void)RGPageSubviewAction:(id)info;
- (void)RGPageHeaderDidSelectItemIndex:(NSInteger)idx;
- (void)RGPageViewWillDisplay:(RGCollectionViewCell *)displayCell indexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView;
- (Class)customCell;

@end

@interface RGPage : NSObject

@property (nonatomic ,strong)NSMutableDictionary *dataDic;
@property (nonatomic ,copy)NSArray *pageTitles;
@property (nonatomic ,copy)NSArray <UIView *>*pages;

@property (nonatomic ,weak)id<RGPageDelegate>pageDelegate;
@property (nonatomic ,strong)RGHeaderView *headerView;
@property (nonatomic ,strong)UICollectionView *pageCollection;


+ (RGPage *)RGPageWithTitles:(NSArray <NSString *>*)titles delegate:(id<RGPageDelegate>)delegate;

+ (RGPage *)RGPageWithTitles:(NSArray *)titles pages:(NSArray *)pages;//未完

- (UIView *)RGPageViewWithFrame:(CGRect)frame;

@end

