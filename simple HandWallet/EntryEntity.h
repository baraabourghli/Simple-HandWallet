//
//  EntryEntity.h
//  FirstApp
//
//  Created by Baraa on 11/5/13.
//  Copyright (c) 2013 BEBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHManagedObject.h"


@interface EntryEntity : RHManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * type;

@end
