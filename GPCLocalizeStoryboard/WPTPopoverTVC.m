//
//  WPTPopoverTVC.m
//  Clipboard
//
//  Created by Graham Conway on 7/10/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import "WPTPopoverTVC.h"
#import "WPTUtilities.h"

@interface WPTPopoverTVC ()

@end

static NSString * const kCellIdentifier = @"SimpleCell";

@implementation WPTPopoverTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // get text depending on what type of control we were passed
    NSString *controlText =  [self getControlText:self.originatingControl];

    // find entry for current text displayed in  control
    self.currentRow = [self.array indexOfObject:controlText];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    
    [self setupPreferredContentSize];
    [self scrollAndSelectRow:self.currentRow];

}

- (NSString *)getControlText:(UIControl *)control
{
    // control is button or label
    if ([control isKindOfClass:[UIButton class] ]) {
        UIButton *btn = (UIButton *)control;
        return btn.titleLabel.text;
    }
    else if ([control isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)control;
        return textField.text;
    }
    else {
        return @"";
    }        
}


- (void)scrollAndSelectRow:(NSUInteger)row
{
    if (self.currentRow != NSNotFound) {
        
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:NO
                          scrollPosition: UITableViewScrollPositionNone];
    }
}

- (void)setupPreferredContentSize
{
    // Estimate height
    NSInteger rowsCount = [self.array count];
    
    // guess / assume height of single row
    NSInteger singleRowHeight = 44;
    
    NSInteger totalRowsHeight = rowsCount * singleRowHeight;
    
    CGFloat largestLabelWidth = 0;

    for (NSString *row in self.dictionary ? [self.dictionary allKeys] : self.array) {
        CGSize labelSize = [row boundingRectWithSize:CGSizeMake(320, singleRowHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}  context:nil].size;
        //[row sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
        
        if (labelSize.width > largestLabelWidth) {
            largestLabelWidth = labelSize.width;
        }
    }
    
    // Add a little padding to the width
    CGFloat popoverWidth = largestLabelWidth + 60;
    
    //Set the property to tell the popover container how big this view should be
    self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.dictionary) {
        return [self.dictionary allKeys][section];
    } else {
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dictionary) {
        return [self.dictionary count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dictionary) {
        NSString *key = [self.dictionary allKeys][section];
        NSArray *objects = [self.dictionary objectForKey:key];
        return [objects count];
    } else {
        return [self.array count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                            forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier];
    }
    
    NSString *value;
    if (self.dictionary) {
        NSString *key = [self.dictionary allKeys][indexPath.section];
        value = [WPTUtilities translateToPatientLanguage:[self.dictionary objectForKey:key][indexPath.row]];
    } else {
        value = [WPTUtilities translateToPatientLanguage:self.array[indexPath.row]];
    }
    cell.textLabel.text = value;
    
    // if cell is selected
    NSString *currentText = [self getControlText:self.originatingControl];
    if ([currentText isEqualToString:cell.textLabel.text ]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // call delegate method that says we seleceted row
    NSString *value;
    if (self.dictionary) {
        NSString *key = [self.dictionary allKeys][indexPath.section];
        value = [WPTUtilities translateToPatientLanguage:[self.dictionary objectForKey:key][indexPath.row]];
    } else {
        value = [WPTUtilities translateToPatientLanguage:self.array[indexPath.row]];
    }

    [self.delegate wptPopoverTVC:(WPTPopoverTVC*)self
                     rowSelected:(NSUInteger)indexPath.row
                     withRowText:(NSString *)value
                       forControl:(UIControl *)self.originatingControl];
    
    // call delegate button that says we are done.
    [self.delegate wptPopoverWantsToBeDismissed:self];
}

@end