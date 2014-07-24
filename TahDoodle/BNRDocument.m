//
//  BNRDocument.m
//  TahDoodle
//
//  Created by Chase Gosingtian on 7/22/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

//COLLISION TEST

#import "BNRDocument.h"

@implementation BNRDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        if ([capsCheckBox state] == NSOnState)
        {
            NSLog(@"Setting isAllCaps to true");
            isAllCaps = true;
        }
        else
        {
            NSLog(@"Setting isAllCaps to false");
            isAllCaps = false;
        }
    }
    return self;
}

#pragma mark - NSDocument Overrides

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"BNRDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

//- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
//{
//    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
//    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    return nil;
//}

//- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
//{
//    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
//    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
//    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    return YES;
//}

#pragma mark - Actions

- (NSString *)getBlockString
{
    NSString *(^newItemString)(void);
    newItemString = ^(void)
    {
        if (isAllCaps)
        {
            return [NSString stringWithFormat:@"NEW ITEM"];
        } else return [NSString stringWithFormat:@"new item"];
    };
    return newItemString();
}

- (IBAction)createNewItem:(id)sender
{
    if (!todoItems)
        todoItems = [NSMutableArray array];
    
    [todoItems addObject:[self getBlockString]];
    
    [itemTableView reloadData]; // don't forget to refresh table views
    [self updateChangeCount:NSChangeDone]; // tells the document whether there are unsaved changes
}

- (IBAction)deleteSelectedItem:(id)sender
{
    [todoItems removeObjectAtIndex:[itemTableView selectedRow]];
    [itemTableView reloadData];
    [self updateChangeCount:NSChangeDone];
}

- (IBAction)setAllCaps:(id)sender
{
    if (![capsCheckBox state])
    {
        isAllCaps = FALSE;
    }
    else
    {
        isAllCaps = TRUE;
    }
//    NSLog(@"%@",isAllCaps ? @"YES" : @"NO");
}

#pragma mark - Data Source Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [todoItems count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [todoItems objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    [todoItems replaceObjectAtIndex:row withObject:object];
    //flag document as having unsaved changes
    [self updateChangeCount:NSChangeDone];
}

#pragma mark - Save/Load; NSDocument Overrides

- (NSData *)dataOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if (!todoItems)
    {
        todoItems = [NSMutableArray array];
    }
    
    //pack into NSData object
    return [NSPropertyListSerialization dataWithPropertyList:todoItems format:NSPropertyListXMLFormat_v1_0 options:0 error:outError];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    todoItems = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainers format:NULL error:outError];
    
    return (todoItems != nil);
}

@end
