//
//  RGHeaderView.h
//  RGPageView
//
//  Created by Robin on 16/8/12.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LINE_WIDTH  65.f
#define SCREENHEIGHT  [[UIScreen mainScreen] bounds].size.height
#define SCRERNWIDTH   [[UIScreen mainScreen] bounds].size.width
#define ITEM_DEFALUT_WIDTH 65.f
#define HEADER_GAP 0.f

@protocol RGHeaderViewDelegate <NSObject>

- (void)RGScrolleToSelectedPage:(NSInteger)idx;

@end

@class RGHeaderView;
@interface RGHeaderViewAppearence : NSObject

@property (nonatomic ,strong)UIFont *titleFont;
@property (nonatomic ,strong)UIColor *tintColor;
@property (nonatomic ,strong)UIColor *titleColor;
@property (nonatomic ,strong)UIColor *itemBackgroundColor;
@property (nonatomic ,strong)UIColor *lineColor;//defualt is tintColor
@property (nonatomic ,assign)CGSize lineSize;
@property (nonatomic ,assign)CGFloat itemWidth;
@property (nonatomic ,assign)UIEdgeInsets edgeInsets;
@property (nonatomic ,weak)RGHeaderView *headerView;

- (instancetype)initWithHeaderView:(RGHeaderView *)headerView;
@end


@interface RGHeaderView : UIScrollView

@property (nonatomic ,weak)id <RGHeaderViewDelegate>RGDelegate;
@property (nonatomic ,readonly)UIImageView *lineImageView;
@property (nonatomic ,strong)NSArray <NSString *> *titles;
@property (nonatomic ,strong ,readonly)NSMutableArray *items;
@property (nonatomic ,strong)RGHeaderViewAppearence *appearence;

- (void)RGSelectButtonWithIdx:(NSInteger)idx;

@end
