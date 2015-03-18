//
//  ViewController.m
//  UIScrollGesture
//
//  Created by apple  on 13-8-21.
//  Copyright (c) 2013年 apple . All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){

    UIImageView *backImageView;
}

@end

@implementation ViewController

//返回yes的时候呢，就可以响应多个手势。

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

/*
 
 此方法在gesture recognizer视图转出UIGestureRecognizerStatePossible状态时调用，如果返回NO,则转换到UIGestureRecognizerStateFailed;如果返回YES,则继续识别触摸序列.(默认情况下为YES)
 
 
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return YES;
}

/*
 
 此方法在window对象在有触摸事件发生时，调用gesture recognizer的touchesBegan:withEvent:方法之前调用，如果返回NO,则gesture recognizer不会看到此触摸事件。(默认情况下为YES).
 */

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return YES;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"touchesBegan");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    backImageView.image = [UIImage imageNamed:@"批阅作业111.png"];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    [backImageView release];
    
    
    
     
     //轻扫手势
     UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
     swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
     [backImageView addGestureRecognizer:swipeLeft];
     [swipeLeft release];
     
     
     UISwipeGestureRecognizer *swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
     swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
     [backImageView addGestureRecognizer:swipeRight];
     [swipeRight release];
     
     
    
    
    // 捏合的手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinch.delegate = self;
    [backImageView addGestureRecognizer:pinch];
    [pinch release];
    
    //旋转手势
    UIRotationGestureRecognizer *rota = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotaAction:)];
    rota.delegate = self;
    [backImageView addGestureRecognizer:rota];
    [rota release];
    
    
    
    
    
    //拖拽
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delaysTouchesBegan = YES;
    [backImageView addGestureRecognizer:pan];
    [pan release];
   
   //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [longPress setMinimumPressDuration:1.0];
    [backImageView addGestureRecognizer:longPress];
    [longPress release];
    
    
    
    //添加双击事件
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:doubleTap];
    [doubleTap release];
    
    
    //添加单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [backImageView addGestureRecognizer:tap];
    [tap release];
    
    //如果单击检测到双击失败了，就执行单击。
    [tap requireGestureRecognizerToFail:doubleTap];
   
    
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark click
//单击事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    NSLog(@"click");
}
//双击事件
-(void)doubleClick:(UITapGestureRecognizer *)tap{
    
    NSLog(@"double click");
}
#pragma mark swipe
//轻扫
-(void)swipeAction:(UISwipeGestureRecognizer *)swipe{
   
    NSLog(@"swipe is %d",swipe.direction);
}
#pragma mark pinch
//捏合
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch{
    
    if ([pinch state] == UIGestureRecognizerStateBegan || [pinch state] == UIGestureRecognizerStateChanged) {
		[pinch view].transform = CGAffineTransformScale([[pinch view] transform], [pinch scale], [pinch scale]);
		[pinch setScale:1];
		
	}

}
#pragma mark rota
//旋转
-(void)rotaAction:(UIRotationGestureRecognizer *)rota{
    
    if ([rota state] == UIGestureRecognizerStateBegan || [rota state] == UIGestureRecognizerStateChanged) {
		[rota view].transform = CGAffineTransformRotate([[rota view] transform], [rota rotation]);
		[rota setRotation:0];
		
	}

}
#pragma mark pan
//拖拽
-(void)panAction:(UIPanGestureRecognizer *)pan{
    
    UIView *piece = [pan view];
    
	if ([pan state] == UIGestureRecognizerStateBegan || [pan state] == UIGestureRecognizerStateChanged) {
        
        
		CGPoint translation = [pan translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y+ translation.y)];
        
		[pan setTranslation:CGPointZero inView:[piece superview]];
	}
}
//长按
-(void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            
        {
          
            NSLog(@"press long began");
            break;
        case UIGestureRecognizerStateEnded:
            
            NSLog(@"press long ended");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"press long failed");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            
            NSLog(@"press long changed");
            break;
        default:
            NSLog(@"press long else");
            break;
        }
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
