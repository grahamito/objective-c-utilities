//
//  WPTPickerVC.h
//  Clipboard
//
//  Created by Graham Conway on 7/4/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTPickerVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *pickerArray;
@property (nonatomic) NSInteger selectedRow;

@end
