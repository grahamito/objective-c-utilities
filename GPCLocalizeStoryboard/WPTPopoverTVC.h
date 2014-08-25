//
//  WPTPopoverTVC.h
//  Clipboard
//
//  Created by Graham Conway on 7/10/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WPTPopoverTVC;

@protocol WPTPopoverTVCDelegate <NSObject>

/*
 * User selected row from popover
 * @param wptPopoverTVC - tableview controller displaying popup list
 * @param rowNUm - idx in array of data selected
 * @param rowText - text of the row selected
 * @param control - the control that the popup is showing values for
 
 */
- (void)wptPopoverTVC:(WPTPopoverTVC*)wptPopoverTVC
          rowSelected:(NSUInteger)rowNum
          withRowText:(NSString *)rowText
     forControl:(UIControl *)control;

- (void)wptPopoverWantsToBeDismissed:(WPTPopoverTVC *)wptPopoverTVC;

@end


@interface WPTPopoverTVC : UITableViewController

@property (weak, nonatomic) id <WPTPopoverTVCDelegate> delegate;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSDictionary *dictionary;
@property (weak, nonatomic) UIControl *originatingControl;
@property ( nonatomic) NSUInteger currentRow;


@end
