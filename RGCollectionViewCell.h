//
//  RGCollectionViewCell.h
//  RGPageView
//
//  Created by Robin on 16/8/12.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RGCollectionViewCellDelegate <NSObject>

- (void)didSelectCell:(id)info;

@optional
- (Class)cellClass;
- (Class)nibCellClass;

@end

@interface RGCollectionViewCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak)UICollectionView *collectionView;
@property (nonatomic ,weak)id <RGCollectionViewCellDelegate> cellDelegate;
@property (nonatomic ,strong)UITableView *listTableView;
@property (nonatomic ,copy)id cellInfo;

- (void)setupDataSource:(NSIndexPath *)indexPath data:(id)data collectionView:(UICollectionView *)collectionView;
@end
