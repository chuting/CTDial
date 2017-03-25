//
//  CTDialView.m
//  Pods
//
//  Created by zhutc on 2017/3/25.
//
//

#import "CTDialView.h"
#define PointImageViewTag 1000
#define BackImageViewTag 2000
#define EndAngle  2.21*M_PI
#define StartAngle 0.79*M_PI


@interface CTDialView  ()
{
    CGFloat endAngle;
    CGFloat lastAngle;
    CADisplayLink *displayLink;
    CAShapeLayer *maskLayer;
    ValueChangeBlock valueChangeBlock;
   
}
@end

@implementation CTDialView
@synthesize valueChangeBlock;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc
{
    if (displayLink) {
        [displayLink invalidate];
    }
   
}

-(instancetype)init
{
    
    
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame
{
   
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    UIImageView *imageview=[[UIImageView alloc]init];
    imageview.image=[UIImage imageNamed:@"btn_light"];
    imageview.tag=BackImageViewTag;
    imageview.userInteractionEnabled=YES;
    [self addSubview:imageview];
    
    UIImage *panelImage=[UIImage imageNamed:@"btn_brightness_panel"];
    
    UIImageView *panelImageView=[[UIImageView alloc]init];
    panelImageView.image=panelImage;
    panelImageView.tag=PointImageViewTag+1;
    panelImageView.userInteractionEnabled=YES;
    [self addSubview:panelImageView];
    

    UIImage *pointImage=[UIImage imageNamed:@"btn_needle"];
    UIImageView *pointImageView=[[UIImageView alloc]init];
    pointImageView.image=pointImage;
    pointImageView.tag=PointImageViewTag;
    pointImageView.userInteractionEnabled=YES;
    [panelImageView addSubview:pointImageView];
    
    
    UILabel *pointLabel=[[UILabel alloc]init];
    pointLabel.backgroundColor=[UIColor clearColor];
    pointLabel.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    pointLabel.font=[UIFont systemFontOfSize:40];
    pointLabel.text=@"1%";
    pointLabel.textAlignment=NSTextAlignmentCenter;
    pointLabel.tag=PointImageViewTag+2;
    [panelImageView addSubview:pointLabel];
    
    
    _minVaule = 0;
    _maxVaule = 100;
    lastAngle = StartAngle;
    
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [panelImageView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [panelImageView addGestureRecognizer:tap];
    
    
    return self;


}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat width = CGRectGetWidth(self.frame) < CGRectGetHeight(self.frame) ? CGRectGetWidth(self.frame): CGRectGetHeight(self.frame);
    
    UIImageView *backImageView = [self viewWithTag:BackImageViewTag];
    UIImageView *panelImageView = [self viewWithTag:PointImageViewTag+1];
    UIImageView *pointImageView = [self viewWithTag:PointImageViewTag];
    UILabel *pointLabel = [self viewWithTag:PointImageViewTag+2];
    
    backImageView.frame = CGRectMake(0, 0, width, width);
    backImageView.center = self.center;
    
    panelImageView.frame = CGRectMake(0, 0, width, width);
    panelImageView.center = self.center;
    
    pointImageView.frame = CGRectMake(0, 0, width, width);
//    pointImageView.center = self.center;

    
    pointLabel.frame = CGRectMake(0, 0,CGRectGetWidth(panelImageView.frame), CGRectGetHeight(panelImageView.frame));
     pointImageView.transform=CGAffineTransformMakeRotation(lastAngle);
//    pointLabel.center = self.center;
}

#pragma mark - 滑动手势
-(void)panGesture:(UIPanGestureRecognizer *)gesture
{
    
    if (displayLink) {
        [displayLink invalidate];
    }
    
    
    CGPoint point=[gesture locationInView:gesture.view];
    CGPoint centerPoint=CGPointMake(CGRectGetWidth(gesture.view.frame)/2, CGRectGetHeight(gesture.view.frame)/2);
   
    //手势到圆心的距离
    double z=sqrt( (point.x-centerPoint.x) *(point.x-centerPoint.x) +(point.y-centerPoint.y)*(point.y-centerPoint.y));
    
    if (z<CGRectGetWidth(gesture.view.frame)/8|| z> (CGRectGetWidth(gesture.view.frame)/2+5)) {
        if (gesture.state==UIGestureRecognizerStateEnded) {
            CGFloat bright= fabs(endAngle-StartAngle)/(EndAngle- StartAngle )*(self.maxVaule-self.minVaule)+self.minVaule;
//            NSLog(@"手势结束的时候手势在色盘外面 %f",bright);
            self.value = bright;
            if (valueChangeBlock) {
                valueChangeBlock(self);
            }
        }
         return;
    }
    
    //当前指针的角度
    double angle=acos((point.x-centerPoint.x)/z) ;
    
    if (point.y<(centerPoint.y-1)) {
        angle=2*M_PI-angle;
    }
    
    if (angle<StartAngle) {
        angle+=2*M_PI;
    }
    
    angle= (angle>EndAngle && angle<M_PI*2.5)?EndAngle:angle;
    angle= (angle>M_PI*2.5)?StartAngle:angle;
    CGFloat value= fabs(angle-StartAngle)/(EndAngle- StartAngle )*(self.maxVaule-self.minVaule)+self.minVaule;
    UILabel *pointLabel=[self viewWithTag:PointImageViewTag+2];
    
    if (angle>EndAngle || angle<StartAngle||fabs( [pointLabel.text floatValue]-value )>(self.maxVaule- self.minVaule -1)) {
        return;
    }
    [self reloadWithValue:value  startangle:lastAngle endAngle:angle animation:gesture.state==UIGestureRecognizerStateEnded];
    if (gesture.state==UIGestureRecognizerStateEnded) {
//        NSLog(@"手势结束");
        self.value = value;
        if (valueChangeBlock) {
            valueChangeBlock(self);
        }
        
    }
    
}


-(void)reloadWithValue:(CGFloat)value  startangle:(CGFloat)sAngle  endAngle:(CGFloat)eAngle  animation:(BOOL)animation
{
    
    UIImageView *backImageView=[self viewWithTag:BackImageViewTag];
    
    CGPoint center=CGPointMake(CGRectGetWidth(backImageView.frame)/2, CGRectGetWidth(backImageView.frame)/2) ;
    CGFloat radius=CGRectGetWidth(backImageView.frame)/2;
    
    UILabel *pointLabel=[self viewWithTag:PointImageViewTag+2];
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.0f",floor(value)] attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:35]}];
    [string appendAttributedString:[[NSAttributedString alloc]initWithString:@"%" attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    if ([string.string isEqualToString:pointLabel.text]) {
        return;
    }
    pointLabel.text=string.string;
    pointLabel.attributedText=string;
    
    UIImageView *pointImageView=[self viewWithTag:PointImageViewTag];
    
    lastAngle=sAngle;
    endAngle=eAngle;
    
    if (displayLink) {
        [displayLink invalidate];
    }
    
    if (animation) {
        maskLayer=[CAShapeLayer layer];
        maskLayer.fillColor=[UIColor redColor].CGColor;
        backImageView.layer.mask=maskLayer;
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(layerAnimation:)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }else
    {
        pointImageView.transform=CGAffineTransformMakeRotation(endAngle);
        
        UIBezierPath *path=[UIBezierPath bezierPath];
        [path moveToPoint:center ];
        [path addLineToPoint:CGPointMake(center.x-fabs(cos(StartAngle)*radius), center.y+fabs(sin(StartAngle)*radius))];
        [path addArcWithCenter:center radius:radius startAngle:StartAngle endAngle:endAngle clockwise:YES];
        [path addLineToPoint:center];
        [path closePath];
        
        CAShapeLayer *layer=[CAShapeLayer layer];
        layer.path=path.CGPath;
        backImageView.layer.mask=layer;
        
        maskLayer.path=path.CGPath;
    }
}


-(void)layerAnimation:(CADisplayLink *)link
{
    if (fabs(lastAngle-endAngle) <0.1  || lastAngle<StartAngle ||lastAngle>EndAngle) {
        [link invalidate];
        lastAngle=endAngle;
    }else if (lastAngle-endAngle>0.1){
        lastAngle-=0.1;
    }else{
        lastAngle+=0.1;
    }
    
    
    UIImageView *backImageView=[self viewWithTag:BackImageViewTag];
    
    CGPoint center=CGPointMake(CGRectGetWidth(backImageView.frame)/2, CGRectGetWidth(backImageView.frame)/2) ;
    CGFloat radius=CGRectGetWidth(backImageView.frame)/2;
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:center ];
    [path addLineToPoint:CGPointMake(center.x-fabs(cos(StartAngle)*radius), center.y+fabs(sin(StartAngle)*radius))];
    [path addArcWithCenter:center radius:radius startAngle:StartAngle endAngle:lastAngle clockwise:YES];
    [path addLineToPoint:center];
    [path closePath];
    maskLayer.path=path.CGPath;
    
    UIImageView *pointImageView=[self viewWithTag:PointImageViewTag];
    pointImageView.transform=CGAffineTransformMakeRotation(lastAngle);
}

#pragma mark - 设置值
-(void)setValue:(CGFloat)value
{
    [self setValue:value animated:YES];
}

#pragma mark - 设置值 带动画
-(void)setValue:(CGFloat)value animated:(BOOL)animated
{
    _value = value;
    CGFloat r = (value-self.minVaule)/(self.maxVaule-self.minVaule)*(EndAngle-StartAngle)+StartAngle;
    r = r < StartAngle ? StartAngle : r;
    r = r > EndAngle ? EndAngle : r;
    lastAngle = lastAngle < StartAngle ? StartAngle :lastAngle;
    
    [self reloadWithValue:value  startangle:lastAngle endAngle:r   animation:animated];

}

-(void)setFontColor:(UIColor *)fontColor
{
    
    UILabel *pointLabel = [self viewWithTag:PointImageViewTag+2];
    pointLabel.textColor = fontColor;
    
}


@end
