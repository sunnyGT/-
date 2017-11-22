//
//  RGCollectionFlowLayout.m
//  RGPageView
//
//  Created by Robin on 16/8/12.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "RGCollectionFlowLayout.h"

@interface RGCollectionFlowLayout ()

@property (nonatomic ,strong)NSMutableArray *sectionItemAttribute;
@property (nonatomic ,strong)NSMutableArray *supplementaryViewAttributes;
@property (nonatomic ,strong)NSMutableArray *allAttributes;
@property (nonatomic ,strong)NSMutableArray *contentWidth;

@end

@implementation RGCollectionFlowLayout

+ (instancetype)createSelfWithSomething:(id)something{
    
    RGCollectionFlowLayout *result = [[self class] new];
    result.allAttributes = nil;
   return result;
}


- (void)prepareLayout{
   
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.sectionItemAttribute[indexPath.section][indexPath.row];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return self.supplementaryViewAttributes[indexPath.row];
}

@end
