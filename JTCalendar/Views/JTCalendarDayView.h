//
//  JTCalendarDayView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendarDay.h"

@interface JTCalendarDayView : UIView<JTCalendarDay>

@property (nonatomic, weak) JTCalendarManager *manager;

@property (nonatomic) NSDate *date;

@property (nonatomic, readonly) UIView *circleView;
@property (nonatomic, readonly) UIView *dotView;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *textLabelSmall;

@property (nonatomic) CGFloat circleRatio;
@property (nonatomic) CGFloat dotRatio;

@property (nonatomic) BOOL isFromAnotherMonth;

/*!
 * Must be call if override the class
 */
- (void)commonInit;

/*
 * Mask the left,right full or none
 */
@property (nonatomic, strong) UIColor *maskColor;
-(void)maskLeft;
-(void)maskRight;
-(void)mask;
-(void)maskNone;

/*
 * Mask the right side of the cell to make half a circle
 */
-(void)maskRight;
@end
