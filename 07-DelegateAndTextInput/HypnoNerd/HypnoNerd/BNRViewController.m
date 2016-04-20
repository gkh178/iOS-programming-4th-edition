//
//  BNRViewController.m
//  Quiz
//
//  Created by gankaihua on 15/12/8.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRViewController.h"

@interface BNRViewController ()
@property (nonatomic, assign) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *questionArray;
@property (nonatomic, copy) NSArray *answerArray;

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;


@end

@implementation BNRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"BNRViewController loaded its view!!!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.questionArray = [NSArray arrayWithObjects:@"1+1?", @"what is pi?",@"7*8", nil];
        self.answerArray = [NSArray arrayWithObjects:@"2", @"3.14", @"56", nil];
        
        self.tabBarItem.title = @"Quiz";//设置tabBarItem标签栏的标题
    }
    return self;
}

- (IBAction)showQuestion:(id)sender {
    self.currentQuestionIndex++;
    if (self.currentQuestionIndex == [self.questionArray count]) {
        self.currentQuestionIndex = 0;
    }
    
    self.questionLabel.text = self.questionArray[self.currentQuestionIndex];
    self.answerLabel.text = @"???";
}

- (IBAction)showAnswer:(id)sender {
    self.answerLabel.text = self.answerArray[self.currentQuestionIndex];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
