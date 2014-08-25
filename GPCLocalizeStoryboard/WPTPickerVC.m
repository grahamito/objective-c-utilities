//
//  WPTPickerVC.m
//  Clipboard
//
//  Created by Graham Conway on 7/4/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import "WPTPickerVC.h"

@interface WPTPickerVC ()

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation WPTPickerVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view
    NSLog(@"viewDidLoad WPTPicker");
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self.picker selectRow:self.selectedRow inComponent:0 animated:NO];
    
    
    [self setupPreferredContentSize];
    
    
}

- (void)setupPreferredContentSize
{
    
    // Estimate height
    NSInteger rowsCount = [self.pickerArray count];
    
    // guess / assume height of single row
    NSInteger singleRowHeight = 44;
    //    NSInteger singleRowHeight = 120;
    
    NSInteger totalRowsHeight = rowsCount * singleRowHeight;
    
    
    // guestimate for width
    CGFloat largestLabelWidth = 100;
    
    //Add a little padding to the width
    CGFloat popoverWidth = largestLabelWidth + 50;
    
    //Set the property to tell the popover container how big this view should be
    self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerArray[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    // get selected row
    self.selectedRow = row;
    
    // do unwind segue back to where picker was called from
    // (Unwind seque can be defined in storyboard by dragging
    // from  this view controller to exit button.
    // its identifier, @"unwindFromPickerVC", is then set in the inspector)
    
    [self performSegueWithIdentifier:@"unwindFromPickerVC" sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
