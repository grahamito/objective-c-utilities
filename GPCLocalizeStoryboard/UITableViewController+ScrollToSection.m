//
//  UIViewController+ScrollToSection.m
//  Clipboard
//
//  Created by Tono MacMini on 7/28/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import "UITableViewController+ScrollToSection.h"


@implementation UITableViewController (ScrollToSection)

- (void)scrollToSection:(WPTFormSection)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (BOOL)isComplete
{
    return YES;
}
@end
