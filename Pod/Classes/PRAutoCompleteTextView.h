//
//  PRAutoCompleteTextView.h
//  PRAutoCompleteTextView
//
//  Created by Anthann-Macbook on 15/3/3.
//  Copyright (c) 2015年 Anthann-Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRAutoCompleteTextView : UIView<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSString* text;
@end
