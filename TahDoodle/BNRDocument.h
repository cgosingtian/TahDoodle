//
//  BNRDocument.h
//  TahDoodle
//
//  Created by Chase Gosingtian on 7/22/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BNRDocument : NSDocument <NSTableViewDataSource>
{
    NSMutableArray * todoItems;
    IBOutlet NSTableView *itemTableView;
}
- (IBAction)createNewItem:(id)sender;
- (IBAction)deleteSelectedItem:(id)sender;

@end
