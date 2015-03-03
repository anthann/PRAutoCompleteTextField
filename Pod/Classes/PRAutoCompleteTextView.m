//
//  PRAutoCompleteTextView.m
//  PRAutoCompleteTextView
//
//  Created by Anthann-Macbook on 15/3/3.
//  Copyright (c) 2015年 Anthann-Macbook. All rights reserved.
//

#import "PRAutoCompleteTextView.h"

@interface PRAutoCompleteTextView()
@property(strong, nonatomic)UITextField* textField;
@property(strong, nonatomic)UITableView* tableView;

@property(strong, nonatomic)NSArray* emailSuffix;
@property(strong, nonatomic)NSMutableArray* AutoCompleteCandidates;
@end


#define TEXTFIELD_HEIGHT 44
@implementation PRAutoCompleteTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (self.bounds.size.height < TEXTFIELD_HEIGHT) {
            return nil;
        }
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TEXTFIELD_HEIGHT)];
        [self.textField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
        [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
        [self addSubview:self.textField];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TEXTFIELD_HEIGHT, self.bounds.size.width, self.bounds.size.height - TEXTFIELD_HEIGHT)];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)textFieldChanged{
    self.text = self.textField.text;
    [self.AutoCompleteCandidates removeAllObjects];
    //NSRange atLoc = [self.textField.text rangeOfString:@"@"];
    NSArray* split = [self.textField.text componentsSeparatedByString:@"@"];
    NSLog(@"%@", split);
    
    if ([split[0] isEqualToString:@""]) {
        [self.tableView reloadData];
        return;
    }
    if ([split count] == 1) {
        
        for (NSString *suffix in self.emailSuffix) {
            [self.AutoCompleteCandidates addObject:[NSString stringWithFormat:@"%@@%@", split[0], suffix]];
        }
    } else if ([split count] == 2) {
        for (NSString* suffix in self.emailSuffix) {
            NSRange match = [suffix rangeOfString:split[1]];
            if ([split[1] isEqualToString:@""]
                || (match.length > 0 && match.location == 0)) {
                [self.AutoCompleteCandidates addObject:[NSString stringWithFormat:@"%@@%@", split[0], suffix]];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (NSString*)text{
    if (!_text) {
        _text = @"";
    }
    return _text;
}

- (NSArray*)emailSuffix{
    if (!_emailSuffix) {
        _emailSuffix = [[NSArray alloc] initWithObjects:@"163.com", @"126.com", @"188.com",  @"vip.163.com", @"vip.126.com", @"vip.188.net", @"yeah.net", @"popo.163.com", @"gmail.com", @"live.cn", @"sina.com", @"qq.com", @"outlook.com", @"icloud.com",   @"yahoo.com", nil];
    }
    return _emailSuffix;
}

- (NSMutableArray*)AutoCompleteCandidates{
    if (!_AutoCompleteCandidates) {
        _AutoCompleteCandidates = [[NSMutableArray alloc] init];
    }
    return _AutoCompleteCandidates;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.AutoCompleteCandidates count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.AutoCompleteCandidates objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.textField.text = [self.AutoCompleteCandidates objectAtIndex:indexPath.row];
    self.text = self.textField.text;
    [self.AutoCompleteCandidates removeAllObjects];
    [self.tableView reloadData];
}
@end
