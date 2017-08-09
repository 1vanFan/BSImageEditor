//
//  ViewController.m
//  BSImageEditor
//
//  Created by 范宝珅 on 2017/8/2.
//  Copyright © 2017年 IvanFan. All rights reserved.
//

#import "ViewController.h"
#import "BSImageEditor.h"
@interface ViewController () <BSImageEditorDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.image = [UIImage imageNamed:@"testImage"];
}

- (IBAction)buttonClick:(UIButton *)sender {
    BSImageEditor *editor = [[BSImageEditor alloc] initWithImage:self.imageView.image delegate:self];
    [self presentViewController:editor animated:YES completion:nil];
}

- (void)bs_imageEditorDidCancel:(BSImageEditor *)controller
{
    
}

- (void)bs_imageEditor:(BSImageEditor *)controller didFinishEditWithImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
