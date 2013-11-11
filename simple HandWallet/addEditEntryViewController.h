//
//  addEditEntryViewController.h
//  FirstApp
//
//  Created by Baraa on 10/31/13.
//  Copyright (c) 2013 BEBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "DateView.h"


@interface addEditEntryViewController : UIViewController

@property (strong,nonatomic) Entry *entry;
@property (weak, nonatomic) IBOutlet UITextField *typeTextInput;
@property (weak, nonatomic) IBOutlet UITextField *amountTextInput;
@property (weak, nonatomic) IBOutlet UILabel *dateTextInput;

@end
