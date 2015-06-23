//
//  ScheduleFetcher.m
//  Forecast
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "ScheduleFetcher.h"
#import "ScheduledClass.h"

@interface ScheduleFetcher ()

@property (strong) NSMutableArray *classes;
@property (strong) NSMutableString *currentString;
@property (strong) NSMutableDictionary *currentFields;
@property (strong) NSDateFormatter *dateFormatter;

@property (strong) NSMutableData *responseData;
@property (strong) NSURLConnection *connection;

@end

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

- (void)fetchClasses {
    
    NSURL *xmlURL = [NSURL URLWithString:@"http://bignerdranch.com/xml/schedule"];
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL
                                         cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                     timeoutInterval:30];
    self.connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (self.connection) {
        self.responseData = [[NSMutableData alloc] init];
    }
}

- (void)cleanup {
    self.responseData = nil;
    self.connection = nil;
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.classes removeAllObjects];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.responseData];
    parser.delegate = self;
    
    BOOL success = [parser parse];
    if (!success) {
        if ([self.delegate respondsToSelector:@selector(scheduledFetcher:didFailWithError:)]) {
            [self.delegate scheduledFetcher:self didFailWithError:[parser parserError]];
        }
    } else {
        NSArray *output = [self.classes copy];
        if ([self.delegate respondsToSelector:@selector(scheduledFetcher:didFinishLoadingClasses:)]) {
            [self.delegate scheduledFetcher:self didFinishLoadingClasses:output];
        }
    }
    
    [self cleanup];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(scheduledFetcher:didFailWithError:)]) {
        [self.delegate scheduledFetcher:self didFailWithError:error];
    }
    
    [self cleanup];
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


