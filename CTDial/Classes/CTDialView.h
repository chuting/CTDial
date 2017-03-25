//
//  CTDialView.h
//  Pods
//
//  Created by zhutc on 2017/3/25.
//
//

#import <UIKit/UIKit.h>
@class CTDialView;
typedef void (^ ValueChangeBlock) (CTDialView *deialView);
typedef NS_ENUM(NSUInteger , ControlEvents)
{
    ControlEventsValueChange,
    ControlEventsValueChangeEnd,
 
};
@interface CTDialView : UIView

@property   (nonatomic , weak)  UIColor *fontColor;
@property   (nonatomic , assign)    CGFloat  minVaule;
@property   (nonatomic , assign)    CGFloat  maxVaule;
@property   (nonatomic , assign)    CGFloat  value;
@property   (nonatomic , copy)  ValueChangeBlock valueChangeBlock;

-(void)setValue:(CGFloat)value animated:(BOOL)animated;
 
@end
