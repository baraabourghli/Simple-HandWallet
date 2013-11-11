//
//  addEditEntryViewController.m
//  FirstApp
//
//  Created by Baraa on 10/31/13.
//  Copyright (c) 2013 BEBA. All rights reserved.
//

#import "addEditEntryViewController.h"

@interface addEditEntryViewController ()
@property (weak,nonatomic) DateView *dateView;


@end

@implementation addEditEntryViewController

#pragma mark - Properties

@synthesize entry=_entry;

@synthesize dateView=_dateView;

- (UIView *)dateView
{
    if (!_dateView)
    {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil];
        _dateView = [subviewArray objectAtIndex:0];
        
        _dateView.doneButton.target = self;
        _dateView.doneButton.action = @selector(dismissDateView:);
        
        _dateView.frame = CGRectMake(0,self.view.bounds.size.height,
                                        _dateView.bounds.size.width,
                                        _dateView.bounds.size.height);
        
        [self.view addSubview:_dateView];
    }
    return _dateView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.title isEqualToString:@"Edit"]) {
        self.typeTextInput.text=self.entry.text;
        self.amountTextInput.text=[NSString stringWithFormat:@"%@", self.entry.amount];
        self.dateTextInput.text=[NSString stringWithFormat:@"%@",self.entry.date];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

#pragma mark - Actions

- (IBAction)saveEntry:(id)sender
{
    Entry *entry;
    if (self.entry==nil)
        entry = [Entry newEntity];
    else
        entry=self.entry;
    
    [entry setAmount:[NSNumber numberWithDouble:[self.amountTextInput.text doubleValue]]];
    [entry setText:self.typeTextInput.text];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [entry setDate:[dateFormatter dateFromString:[self.dateTextInput.text
                                                  stringByReplacingOccurrencesOfString:@":"
                                                  withString:@""
                                                  options:0
                                                  range:NSMakeRange(([self.dateTextInput.text length]-5),5)]]];
    NSLog(entry.date.description);
    [Entry commit];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editDate:(id)sender
{
    [self.typeTextInput resignFirstResponder];
    [self.amountTextInput resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.dateView.frame = CGRectMake(0,self.view.bounds.size.height - self.dateView.bounds.size.height,
                                           self.dateView.bounds.size.width,
                                           self.dateView.bounds.size.height);
    }];
}


#pragma mark - Custome Methodes


- (void)dismissDateView:(UIBarButtonItem *)sender
{
    NSDate *dateValue = [NSDate date];
    if (sender.tag == 1)
        dateValue = self.dateView.datePicker.date;
    
    NSDateFormatter *shortDateFormatter = [[NSDateFormatter alloc] init];
    shortDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    self.dateTextInput.text = [shortDateFormatter stringFromDate:dateValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.dateView.frame = CGRectMake(0,
                                           self.view.bounds.size.height,
                                           self.view.bounds.size.width,
                                           self.dateView.bounds.size.height);
    }];
}

- (void)handleTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchPoint = [sender locationInView:self.view];
        UIView *viewTouched = [sender.view hitTest:touchPoint withEvent:nil];
        if (viewTouched != self.typeTextInput)
            [self.typeTextInput resignFirstResponder];
        if (viewTouched != self.amountTextInput)
            [self.amountTextInput resignFirstResponder];
    }
}


@end
