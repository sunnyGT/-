//
//  RGHeaderView.m
//  RGPageView
//
//  Created by Robin on 16/8/12.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "RGHeaderView.h"


@implementation RGHeaderViewAppearence

- (instancetype)initWithHeaderView:(RGHeaderView *)headerView{
    self = [super init];
    if (self) {
        _headerView = headerView;
    }
    return self;
}


- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
    self.headerView.contentInset = edgeInsets;
    [self.headerView setContentOffset:CGPointMake(edgeInsets.top, 0) animated:YES];
}

- (void)setLineSize:(CGSize)lineSize{
    _lineSize = lineSize;
    self.headerView.lineImageView.size = lineSize;
}

- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
    [self.headerView layoutIfNeeded];
}

- (void)setTitleColor:(UIColor *)titleColor{
    if ([_titleColor isEqual:titleColor]) return;
    _titleColor = titleColor;
    if (!self.headerView) return;
    [self.headerView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *tempButton = (UIButton *)obj;
        [tempButton setTitleColor:_titleColor forState:UIControlStateNormal];
    }];
}

- (void)setTintColor:(UIColor *)tintColor{
    
    if ([_tintColor isEqual:tintColor]) return;
    _tintColor = tintColor;
    if (!self.lineColor) {
        self.lineColor = _tintColor;
    }
    if (!self.headerView) return;
    [self.headerView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *tempButton = (UIButton *)obj;
        [tempButton setTitleColor:_tintColor forState:UIControlStateSelected];
    }];
}

- (void)setTitleFont:(UIFont *)titleFont{
    if ([_titleFont isEqual:titleFont]) return;
    _titleFont = titleFont;
    if (!self.headerView) return;
    [self.headerView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *tempButton = (UIButton *)obj;
        tempButton.titleLabel.font = _titleFont;
    }];
    
}

@end


@interface RGHeaderView (){
    
    UIButton *_lastButton;
    CGFloat _maxOffset;
}

@end



@implementation RGHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.exclusiveTouch = YES;
    self.showsHorizontalScrollIndicator = NO;
    
    _appearence = [RGHeaderViewAppearence new];
    _appearence.tintColor = [UIColor redColor];
    _appearence.titleColor = [UIColor lightGrayColor];
    _appearence.titleFont = XMFontOfSize(13.f);
    _appearence.itemBackgroundColor = [UIColor whiteColor];
    
    _maxOffset = 0.f;
    
    _lineImageView = [UIImageView new];
    _lineImageView.backgroundColor = _appearence.lineColor;
    _lineImageView.frame = (CGRect){CGPointMake(0, self.height - 1),_appearence.lineSize};
    [self addSubview:self.lineImageView];
}

- (void)setFrame:(CGRect)frame{
    
    if (!_appearence.itemWidth) {
        
        CGFloat tempWidth = frame.size.width /_titles.count;
        _appearence.itemWidth = tempWidth >= ITEM_DEFALUT_WIDTH?tempWidth: ITEM_DEFALUT_WIDTH;
        _lineImageView.frame = CGRectMake(0, frame.size.height - 1, tempWidth - 5, 1);
    }
    [super setFrame:frame];
}
#pragma mark - override

- (void)layoutSubviews{
    
    [super layoutSubviews];

    [self.items enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIButton class]]) return ;
        obj.frame = CGRectMake(self.appearence.itemWidth * idx, 0, self.appearence.itemWidth, CGRectGetHeight(self.bounds));
        self.contentSize = CGSizeMake(self.appearence.itemWidth * _titles.count, 0);
    }];
    _maxOffset = self.contentSize.width <= SCRERNWIDTH? :self.contentSize.width - SCRERNWIDTH;
}

- (void)setAppearence:(RGHeaderViewAppearence *)appearence{
    
    _appearence = appearence;
    [self layoutIfNeeded];
}

- (void)setTitles:(NSArray<NSString *> *)titles{
    if ([_titles isEqualToArray:titles]) return;
    _titles = titles;
    _items = [NSMutableArray array];
    NSInteger subviewNum = titles.count;
    for (NSInteger idx = 0; idx < subviewNum; idx ++) {
        @autoreleasepool {
            UIButton *tempButton = [self buttonWithColor:[UIColor clearColor]];
            tempButton.tag = 1000+idx;
            
            
            [tempButton setTitle:titles[idx] forState: UIControlStateNormal];
            [tempButton setTitleColor:_appearence.tintColor forState:UIControlStateSelected];
            [tempButton setTitleColor:_appearence.titleColor forState:UIControlStateNormal];
            tempButton.titleLabel.font = _appearence.titleFont;
            [self addSubview:tempButton];
            [_items addObject:tempButton];
            if (idx) continue;
            tempButton.selected = !idx;
            _lastButton = tempButton;

        }
    }
}


#pragma mark - CreatItem
- (UIButton *)buttonWithColor:(UIColor *)color{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = color;
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    return button;
}



#pragma mark - Action

- (void)selectAction:(UIButton *)sender{
    
    if ([self.RGDelegate respondsToSelector:@selector(RGScrolleToSelectedPage:)]) {
        [self.RGDelegate RGScrolleToSelectedPage:sender.tag];
    }
}

- (void)RGSelectButtonWithIdx:(NSInteger)idx{

    _lastButton.selected = !_lastButton.selected;
    UIButton *tempButton =  (UIButton *)[self.items objectAtIndex:idx];
    tempButton.selected = !tempButton.selected;
    [self scrollsToCenter:tempButton];
    _lastButton = tempButton;
}

- (void)scrollsToCenter:(UIButton *)sender{
    CGPoint senderPoint = [self convertPoint:sender.center toView:self.superview];
    CGFloat centerX = self.superview.center.x;
    CGFloat D_value = senderPoint.x - centerX;
    if (fabs(D_value) > 0.001) {
    CGPoint tempOffset = self.contentOffset;
    tempOffset.x = self.contentOffset.x + D_value;
        
        if (tempOffset.x <= 0) {
            
            tempOffset = CGPointZero;
        }
     
        if (tempOffset.x > _maxOffset) {
            
            tempOffset.x = _maxOffset;
        }

    [self setContentOffset:tempOffset animated:YES];
    }
}


@end
