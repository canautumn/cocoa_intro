//
//  Document.m
//  ZIPspector
//
//  Created by Can on 2/11/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "Document.h"

@interface Document ()
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) NSArray *filenames;
@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

//- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
//    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
//    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
//    return nil;
//}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    
    NSString *filename = [url path];
    NSTask *task = [[NSTask alloc] init];
    
    NSLog(@"typeName: %@", typeName);
    
    if ([typeName isEqualToString:@"com.pkware.zip-archive"] || [typeName isEqualToString:@"public.zip-archive"]) {
        task.launchPath = @"/usr/bin/zipinfo";
        task.arguments = @[@"-1", filename];
    } else if ([typeName isEqualToString:@"public.tar-archive"]) {
        task.launchPath = @"/usr/bin/tar";
        task.arguments = @[@"tf", filename];
    } else if ([typeName isEqualToString:@"org.gnu.gnu-zip-tar-archive"]) {
        task.launchPath = @"/usr/bin/tar";
        task.arguments = @[@"tzf", filename];
    } else {
        if (outError) {
            NSDictionary *errDict = @{NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"Unrecognized file type %@", typeName]};
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:errDict];
        }
        return NO;
    }
    
    NSPipe *outPipe = [[NSPipe alloc] init];
    task.standardOutput = outPipe;
    [task launch];
    
    NSData *data = [[outPipe fileHandleForReading] readDataToEndOfFile];
    [task waitUntilExit];
    int status = task.terminationStatus;
    
    if (status != 0) {
        if (outError) {
            NSDictionary *errDict = @{NSLocalizedFailureReasonErrorKey : @"zipinfo failed"};
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:errDict];
        }
        return NO;
    }
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.filenames = [str componentsSeparatedByString:@"\n"];
    NSLog(@"filenames = %@", self.filenames);
    
    [self.tableView reloadData];
    
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.filenames.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return self.filenames[row];
}

//- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
//    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
//    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
//    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
//    return YES;
//}

@end
