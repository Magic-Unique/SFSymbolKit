//
//  SKViewController.m
//  SFSymbolKit
//
//  Created by 冷秋 on 03/22/2023.
//  Copyright (c) 2023 冷秋. All rights reserved.
//

#import "SKViewController.h"
#import <SFSymbolKit/SFSymbolKit.h>

@interface SKViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage sk_imageNamed:@"widget.small.badge.plus" pointSize:100];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:self.imageView];
    self.imageView.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
