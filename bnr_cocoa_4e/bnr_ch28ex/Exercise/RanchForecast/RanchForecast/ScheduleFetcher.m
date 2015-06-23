//
//  ScheduleFetcher.m
//  Forecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "ScheduleFetcher.h"
#import "ScheduledClass.h"

@implementation ScheduleFetcher

- (instancetype)init {
    self = [super init];
    if (self) {
        self.classes = [[NSMutableArray alloc] init];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzzz";
    }
    return self;
}

- (NSArray *)fetchClassesWithError:(NSError *__autoreleasing *)outError {
    BOOL success;
    NSURL *xmlURL = [NSURL URLWithString:@"http://bignerdranch.com/xml/schedule"];
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL
                                         cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                     timeoutInterval:30];
    NSURLResponse *resp = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:outError];
    if (!data) {
        return nil;
    }
    
//    NSLog(@"Received %ld bytes.", [data length]);

    [self.classes removeAllObjects];
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    success = [parser parse];
    if (!success) {
        *outError = [parser parserError];
        return nil;
    }
    
    NSArray *output = [self.classes copy];
    
    return output;
}

#pragma mark -
#pragma mark NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqual:@"class"]) {
        self.currentFields = [[NSMutableDictionary alloc] init];;
    } else if ([elementName isEqual:@"offering"]) {
        [self.currentFields setObject:[attributeDict objectForKey:@"href"] forKey:@"href"];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {

    if ([elementName isEqual:@"class"]) {
        ScheduledClass *currentClass = [[ScheduledClass alloc] init];
        currentClass.name = [self.currentFields objectForKey:@"offering"];
        currentClass.location = [self.currentFields objectForKey:@"location"];
        currentClass.href = [self.currentFields objectForKey:@"href"];
        
        NSString *beginString = [self.currentFields objectForKey:@"begin"];
        NSDate *beginDate = [self.dateFormatter dateFromString:beginString];
        currentClass.begin = beginDate;
        
        [self.classes addObject:currentClass];
        currentClass = nil;
        
        self.currentFields = nil;
    } else if (self.currentFields && self.currentString) {
        NSString *trimmed;
        trimmed = [self.currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.currentFields setObject:trimmed forKey:elementName];
    }
    self.currentString = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.currentString) {
        self.currentString = [[NSMutableString alloc] init];
    }
    [self.currentString appendString:string];
}

@end


