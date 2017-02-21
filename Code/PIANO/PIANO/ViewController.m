//
//  ViewController.m
//  PIANO
//
//  Created by tarena on 2017/2/14.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()
@property(nonatomic)NSMutableArray<NSNumber*>*allsound;
@property(nonatomic)NSMutableArray*allbtn;
@property(nonatomic)CGPoint beforepoint;
@end

@implementation ViewController
- (IBAction)playmusic:(UIButton *)sender {
    NSInteger num = sender.tag;
    AudioServicesPlaySystemSound([self.allsound[num] intValue]);
    
    
}


-(void)dispose
{
    
    for (int i=1; i<=21; i++) {
        
        
        //        SystemSoundID thisSoundID=i;
        //        NSURL* url=[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"00%d",i] withExtension:@"wav"];
        //
        //
        //        SystemSoundID sid= AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &thisSoundID);
        //        [self.allsound addObject:[NSNumber numberWithInt:sid]];
        
        //注册声音到系统
        NSURL* url=[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%d",i] withExtension:@"mp3"];
        CFURLRef inFileURL = (__bridge CFURLRef)url;
        SystemSoundID soundID = i;
        AudioServicesCreateSystemSoundID(inFileURL, &soundID);
        
        
        NSNumber*num=[NSNumber numberWithUnsignedInt:soundID];
        [self.allsound addObject:num];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dispose];
    [self panGestureTecognizer];
    
    for (int i=1; i<=21; i++){
        UIImageView *btnview=[self.view viewWithTag:i];
        [self.allbtn addObject:btnview];
    }//得到所有btn的view
}
-(void)xiang:(NSInteger)tag{
    AudioServicesPlaySystemSound([self.allsound[tag] intValue]);
}
-(void)panGestureTecognizer
{
    
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    //添加到指定视图
    [self.view addGestureRecognizer:pan];
    
}
//创建平移事件
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    
    //获取手势的位置
    CGPoint position =[pan locationInView:self.view];
    if (pan.state==UIGestureRecognizerStateBegan) {
        NSLog(@"开始拖拽");
        [self.allbtn enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectContainsPoint(obj.frame,position)) {
                [self xiang:idx];
                return;
            }
        }];
    }
    else if (pan.state==UIGestureRecognizerStateChanged) {
        NSLog(@"开始拖拽过程");
        //locationinview获得得的是父视图中的绝对位置
        CGPoint position=[pan locationInView:self.view];
        [self.allbtn enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectContainsPoint(obj.frame,position)) {
                if (CGRectContainsPoint(obj.frame,self.beforepoint)&&CGRectContainsPoint(obj.frame,position) ) {
                    return ;
                }else if(CGRectContainsPoint(obj.frame,position)){
                    [self xiang:idx];
                    return;
                }
                
                
            }
        }];
        
        NSLog(@"正在移动触摸结束的位置%@",NSStringFromCGPoint(position));
        

        
    }else  {
        NSLog(@"拖拽结束");
        
    }

    self.beforepoint=position;
    
}


//- (IBAction)PLAYDO:(id)sender {
//
//    AudioServicesPlaySystemSound(self.allsound[0].intValue);
//
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSMutableArray *)allsound {
    if(_allsound == nil) {
        _allsound = [[NSMutableArray alloc] init];
    }
    return _allsound;
}

- (NSMutableArray *)allbtn {
	if(_allbtn == nil) {
		_allbtn = [[NSMutableArray alloc] init];
	}
	return _allbtn;
}

@end
