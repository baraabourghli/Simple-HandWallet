//
//  EntryViewController.m
//  FirstApp
//
//  Created by Baraa on 10/29/13.
//  Copyright (c) 2013 BEBA. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalExpenceLable;


@end

@implementation EntryViewController




#pragma mark - UIViewController delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTotalsLabels];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setTotalsLabels];

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     NSLog(@"Segue about to be performed from tag %d",[sender tag]);
    if ([segue.identifier isEqualToString:@"EditEntry"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Entry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        addEditEntryViewController *add_edit_controller= segue.destinationViewController;
        add_edit_controller.entry=entry;
        add_edit_controller.title=@"Edit";
    }
}

-(NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
    {
		NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
		[fetchRequest setEntity:[Entry entityDescriptionWithError:nil]];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1, nil]];
		[fetchRequest setFetchBatchSize:20];
		
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																			managedObjectContext:[Entry managedObjectContextForCurrentThreadWithError:nil]
																			  sectionNameKeyPath:nil
																					   cacheName:nil];
		
		fetchedResultsController.delegate = self;
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
        {
			NSLog(@"Unresolved error: %@", [error localizedDescription]);
		}
    }
	
	return fetchedResultsController;
}

-(void)configureCell:(EntryCellView *)cell atIndexPath:(NSIndexPath *)indexPath
{
	
	Entry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.entryTextLabel.text = [NSString stringWithFormat:@"%@",entry.text];
    cell.entryAmountLabel.text=[NSString stringWithFormat:@"%@",entry.amount];
    
}


-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"EntryCellView";
	
	EntryCellView *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    
	[self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //add code here for when you hit delete
        Entry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [entry delete];
        [Entry commit];
        [self setTotalsLabels];
    }
}

#pragma mark - Actions

- (IBAction)addAction:(id)sender
{
    [self performSegueWithIdentifier:@"AddEntity" sender:sender];
}

#pragma mark - Custome Methodes

-(void) setTotalsLabels
{
    double expences = 0,incomes = 0;
    NSArray *allEntries = [Entry fetchAllWithError:nil];
    for (Entry *entry in allEntries) {
        if (entry.amount.floatValue < 0)
        {
            expences += entry.amount.floatValue ;
        }
        else
        {
            incomes += entry.amount.floatValue ;
        }
    }
    self.totalIncomeLabel.text = [NSString stringWithFormat:@"%g",incomes];
    self.totalExpenceLable.text = [NSString stringWithFormat:@"%g",expences];
}



@end
