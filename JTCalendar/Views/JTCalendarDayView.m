//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"
#import "JTCalendarManager.h"
#import "UIFont+Additions.h"
#import "ACLabel.h"

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;
        
        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.hidden = YES;
        
        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView.layer.shouldRasterize = YES;
    }
    
    {
        _textLabel = [[ACLabel alloc] init];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont aussieCommerceFontWithSize:[UIFont systemFontSize]];
      
    }
    {
        _textLabelSmall = [[ACLabel alloc] init];
        [self addSubview:_textLabelSmall];
  
        _textLabelSmall.textColor = [UIColor blackColor];
        _textLabelSmall.textAlignment = NSTextAlignmentCenter;
        _textLabelSmall.font = [UIFont aussieCommerceFontBoldWithSize:9];
    }

  
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}
- (void)drawMask:(BOOL)left{
  if (!CGRectIsEmpty(self.circleView.bounds)){
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = self.circleView.bounds;
    CGFloat offset = self.circleView.bounds.size.width/10;
    maskRect.origin.x = left ? offset : -offset*4;
    maskRect.size.width = (self.circleView.bounds.size.width+(offset*3));
    // Create a path with the circle in it.
    CGPathRef path = CGPathCreateWithRoundedRect(maskRect,4,4, NULL);
    // Set the path to the mask layer.
    maskLayer.path = path;
    // Set the mask of the view.
    self.circleView.layer.mask = maskLayer;
  }
}
-(void)maskLeft{
  self.circleView.backgroundColor = self.maskColor;
  self.circleView.layer.mask = nil;
  self.circleView.hidden = NO;
  [self drawMask:YES];
}

-(void)maskRight{
  self.circleView.backgroundColor = self.maskColor;
  self.circleView.layer.mask = nil;
  self.circleView.hidden = NO;
  [self drawMask:NO];
}
- (void)mask{
  self.circleView.backgroundColor = self.maskColor;
  self.circleView.layer.mask = nil;
  self.circleView.hidden = NO;
}
- (void)maskNone{
  self.circleView.backgroundColor = self.maskColor;
  self.circleView.layer.mask = nil;
  self.circleView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textLabel.frame = self.bounds;
    _textLabelSmall.frame = CGRectOffset(self.bounds, 0, 15.0f);
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
  
//    _circleView.frame = CGRectMake(0, 0, self.bounds.size.width,(self.bounds.size.height/5)*3);
    _circleView.frame = CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height * .8);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    
    _dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
    _dotView.layer.cornerRadius = sizeDot / 2.;
}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
    }
    [dateFormatter setDateFormat:self.dayFormat];
    
    _textLabel.text = [ dateFormatter stringFromDate:_date];
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

- (NSString *)dayFormat
{
    return self.manager.settings.zeroPaddedDayFormat ? @"dd" : @"d";
}

@end
