//
//  WPTPopoverController
//  Clipboard
//
//  Created by Graham Conway on 7/10/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import "WPTPopoverController.h"
#import "WPTUtilities.h"

@interface WPTPopoverController ()

@property (strong, nonatomic) UIControl *control;
@property (assign, nonatomic, getter = isKeyboardVisible) BOOL keyboardVisible;
@property (assign, nonatomic) BOOL shouldShowPopup;

@end

@implementation WPTPopoverController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShown) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
* show popover
*
* @param sender - control where the popup should appear.
* @param data   - array of strings
*/
- (void)wpt_showPopoverForControl:(UIControl *)sender
                        withData:(NSArray *)data
{
    self.control = sender;
    [self hideKeyboard];
    
    self.wptPopoverSourceControl = sender;
    
    WPTPopoverTVC *wptPopoverTVC = [[WPTPopoverTVC alloc] initWithStyle:UITableViewStylePlain];
    wptPopoverTVC.delegate = self;
    wptPopoverTVC.array = data;
    wptPopoverTVC.originatingControl = sender;
    
    self.wptPopoverController = [[UIPopoverController alloc] initWithContentViewController:wptPopoverTVC];
    
    if (!self.isKeyboardVisible) {
        [self.wptPopoverController presentPopoverFromRect:sender.frame
                                                   inView:sender.superview
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
    } else {
        self.shouldShowPopup = YES;
    }
}

- (void)wpt_showPopoverForControl:(UIControl *)sender
                   withDictionary:(NSDictionary *)dictionary
{
    self.control = sender;
    [self hideKeyboard];
    
    self.wptPopoverSourceControl = sender;
    
    WPTPopoverTVC *wptPopoverTVC = [[WPTPopoverTVC alloc] initWithStyle:UITableViewStylePlain];
    wptPopoverTVC.delegate = self;
    wptPopoverTVC.dictionary = dictionary;
    wptPopoverTVC.originatingControl = sender;
    
    self.wptPopoverController = [[UIPopoverController alloc] initWithContentViewController:wptPopoverTVC];
    
    if (!self.isKeyboardVisible) {
        [self.wptPopoverController presentPopoverFromRect:sender.frame
                                                   inView:sender.superview
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
    } else {
        self.shouldShowPopup = YES;
    }

}

/*
 * show popover for date picker
 *
 * @param sender - control where the popup should appear.
 * @param date   - selected date, if date is nil it defaults to current date
 */
- (void)wpt_showDatePopoverForControl:(UIControl *)sender
{
    self.control = sender;
    [self hideKeyboard];
    
    self.wptPopoverSourceControl = sender;
    
    NSDateFormatter *dateFormatter = [WPTUtilities dateFormatterWithFullYear:YES];
    
    NSDate *date = nil;
    
    if ([self.wptPopoverSourceControl isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self.wptPopoverSourceControl;
        date = [dateFormatter dateFromString:textField.text];
    } else if ([self.wptPopoverSourceControl isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.wptPopoverSourceControl;
        date = [dateFormatter dateFromString:[button titleForState:UIControlStateNormal]];
    }
    
    UIViewController *viewController = [[UIViewController alloc] init];
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];

    NSString *language = [WPTUtilities getPatientCurrentLanguageFromDefaults];
        datePicker.locale =  [NSLocale localeWithLocaleIdentifier:[NSString stringWithFormat:@"%@_US", language]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    if (date && [date isKindOfClass:[NSDate class]]) datePicker.date = date;
    [viewController.view addSubview:datePicker];
    
    self.wptPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    
    self.wptPopoverController.popoverContentSize = datePicker.frame.size;

    if (!self.isKeyboardVisible) {
        [self.wptPopoverController presentPopoverFromRect:sender.frame
                                                   inView:sender.superview
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
    } else {
        self.shouldShowPopup = YES;
    }
}

- (void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)onKeyboardShown
{
    self.keyboardVisible = YES;
}

- (void)onKeyboardHide
{
    self.keyboardVisible = NO;
    if (self.shouldShowPopup) {
        [self.wptPopoverController presentPopoverFromRect:self.control.frame
                                                   inView:self.control.superview
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
        self.shouldShowPopup = NO;
    }

}

- (IBAction)datePickerChanged:(UIDatePicker *)sender
{
    //TODO: Get format from utility class
    NSDateFormatter *dateFormatter = [WPTUtilities dateFormatterWithFullYear:YES];
    
    if ([self.wptPopoverSourceControl isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self.wptPopoverSourceControl;
        textField.text = [dateFormatter stringFromDate:sender.date];
    } else if ([self.wptPopoverSourceControl isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.wptPopoverSourceControl;
        [button setTitle:[dateFormatter stringFromDate:sender.date] forState:UIControlStateNormal];
    }
}

#pragma mark wptPopoverTVCDelegate Methods

/*
* User selected row from popover. Update control title.
* 
* override to do more 
*
* @param wptPopoverTVC - tableview controller displaying popup list
* @param rowNUm - idx in array of data selected
* @param rowText - text of the row selected
* @param control - the control that the popup is showing values for

*/
- (void)wptPopoverTVC:(WPTPopoverTVC*)wptPopoverTVC
          rowSelected:(NSUInteger)rowNum
          withRowText:(NSString *)rowText
            forControl:(UIControl *)control;
{
    // set title or label depending what type of control
    if ([self.wptPopoverSourceControl isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *) self.wptPopoverSourceControl;
        [btn setTitle:rowText
             forState:UIControlStateNormal];
    }
    else if ([self.wptPopoverSourceControl isKindOfClass:[UITextField class]]) {
        UITextField *txtField = (UITextField *)self.wptPopoverSourceControl;
        txtField.text = rowText;
        [self.delegate optionWasSelected:txtField];
    }
}

- (void)wptPopoverWantsToBeDismissed:(WPTPopoverTVC*)wptPopoverTVC
{
    [self.wptPopoverController dismissPopoverAnimated:YES];
}

@end
