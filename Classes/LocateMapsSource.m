//
//  LocateMapsSource.m
//  History
//
//  Created by Martin Ceperley on 8/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocateMapsSource.h"
#import "JSON.h"



@implementation LocateMapsSource

- (id)init {
	if (self = [super init]) {
		_isLoading = YES;
		_isLoaded = NO;
	}  
	return self;
}


- (void)load:(TTURLRequestCachePolicy)cachePolicy nextPage:(BOOL)nextPage {    
	static NSString *jsonUrl = 
    @"http://search.yahooapis.com/ImageSearchService/V1/imageSearch?appid=YahooDemo&query=lolcats&output=json";
	TTURLRequest *request = 
    [TTURLRequest requestWithURL:jsonUrl delegate:self];
	request.cachePolicy = cachePolicy;
	request.response = [[[TTURLDataResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	
	BOOL cacheHit = [request send];  
	NSLog((cacheHit ? @"Cache hit for %@" : @"Cache miss for %@"), jsonUrl);
}

- (BOOL)isLoading {
	return _isLoading;
}

- (BOOL)isLoaded {
	return _isLoaded;
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
	_isLoading = YES;
	_isLoaded = NO;    
//	[self dataSourceDidStartLoad];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {  
	TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
    
	// JSON processing
	NSDictionary *json =  [responseBody JSONValue];
	[responseBody release];
	
	NSDictionary *resultSet = [json objectForKey:@"ResultSet"];
	NSArray *results = [resultSet objectForKey:@"Result"];
	
	for(NSDictionary *result in results) {     
		[self.items addObject:
							   [[TTTableItem alloc]
								itemWithText:[result objectForKey:@"Title"]
								subtitle:nil
								imageURL:[result objectForKey:@"Url"]
								URL: nil]
							   ];
		}
	
	_isLoading = NO;
	_isLoaded = YES;  
//	[self didFinishLoad];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	NSLog(@"didFailLoadWithError");
	_isLoading = NO;
	_isLoaded = YES;    
//	[self dataSourceDidFailLoadWithError:error];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
	NSLog(@"requestDidCancelLoad");
	_isLoading = NO;
	_isLoaded = YES;  
//	[self dataSourceDidCancelLoad];
}

@end