//
//  Communicator.m
//  DistributedComputing
//
//  Created by Tatiana Petrova on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Communicator.h"
#import "Solver.h"
#import "RegisterResponse.h"
#import "GetDataToComputeResponse.h"

@interface Communicator()

// Private properties
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSMutableData *receivedData;

@property (nonatomic) UITextView *outputTextView;
@property (nonatomic) Solver *solver;

@property (nonatomic) RegisterResponse *registerResponse;
@property (nonatomic) GetDataToComputeResponse *getDataResponse;

@property (nonatomic) NSMutableString *currentElementValue;

// Private methods
- (NSURL *)urlForAction:(NSString *)action andUserId:(NSString *)userId;
- (NSMutableURLRequest *)requestForUrl:(NSURL *)url andBody:(NSString *)body;

- (NSString *)userIdFromSettings;
- (void)saveUserId:(NSString *)userId;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

- (NSData *)dataForRegister;
- (NSData *)dataForCompute;
- (NSData *)sendComputedWithUp:(NSNumber *)up andDown:(NSNumber *)down;

@end



@implementation Communicator

// Define constants
NSString *const urlTemplate = @"http://%@:%@/DistributedComputingServer/API?action=%@&id=%@";
NSString *const serverName = @"127.0.0.1";
NSString *const serverPort = @"8080";

NSString *const userIdKey = @"userId";
NSString *const actionRegister = @"Register";
NSString *const actionGetData = @"GetDataToCompute";
NSString *const actionPutData = @"PutDataComputed";

NSString *const xmlRegisterRequest = @"<RegisterRequest/>";
NSString *const xmlGetDataRequest = @"<GetDataToComputeRequest/>";
NSString *const xmlPutDataRequest = @"<PutDataComputedRequest/>";

// Synthesize private properties
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;

@synthesize outputTextView = _outputTextView;
@synthesize solver = _solver;

@synthesize registerResponse = _registerResponse;
@synthesize getDataResponse = _getDataResponse;

@synthesize currentElementValue = _currentElementValue;

// Implement private methods
- (NSURL *)urlForAction:(NSString *)action andUserId:(NSString *)userId
{
    return [NSURL URLWithString:[NSString stringWithFormat:urlTemplate,serverName,serverPort,action,userId]];
}

- (NSMutableURLRequest *)requestForUrl:(NSURL *)url andBody:(NSString *)body
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];    
    return request;
}

- (NSString *)userIdFromSettings
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    return [defaults stringForKey:userIdKey];
}

- (void)saveUserId:(NSString *)userId
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:userId forKey:userIdKey];
    [defaults synchronize];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                              message:message
                                              delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alert show];
}

- (NSData *)dataForRegister
{
    NSURL *url = [self urlForAction:actionRegister andUserId:@"0"];
    NSMutableURLRequest *request = [self requestForUrl:url andBody:xmlRegisterRequest];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!result) {
        [self showAlertWithTitle:@"Registration failed" andMessage:[error description]];
        return nil;
    }
    
    return result;
}

- (NSData *)dataForCompute
{
    NSString *userId = [self userIdFromSettings];
    
    if (!userId) {
        [self showAlertWithTitle:@"Hmm" andMessage:@"Bad user ID"];
        return nil;
    }
    
    NSURL *url = [self urlForAction:actionGetData andUserId:userId];
    NSMutableURLRequest *request = [self requestForUrl:url andBody:xmlGetDataRequest];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!result) {
        [self showAlertWithTitle:@"Receiving of data failed" andMessage:[error description]];
        return nil;
    }
    
    return result;
}

- (NSData *)sendComputedWithUp:(NSNumber *)up andDown:(NSNumber *)down
{
    NSString *userId = [self userIdFromSettings];
    
    if (!userId) {
        [self showAlertWithTitle:@"Hmm" andMessage:@"Bad user ID"];
        return nil;
    }
    
    NSURL *url = [self urlForAction:actionPutData andUserId:userId];
    NSMutableURLRequest *request = [self requestForUrl:url andBody:xmlPutDataRequest];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!result) {
        [self showAlertWithTitle:@"Sending of data failed" andMessage:[error description]];
        return nil;
    }
    
    return result;
}

// Implement required methods
- (void)goWithOutputIn:(UITextView *)textView
{
    // Output for our spam
    _outputTextView = textView;
    
    // 1. register if needed
    NSString *userId = [self userIdFromSettings];
    if (!userId) {
        NSXMLParser *registrationParser = [[NSXMLParser alloc] initWithData:[self dataForRegister]];
        [registrationParser delete:self];
        BOOL registrationSuccess = [registrationParser parse];
        
        if (!registrationSuccess) {
            [self showAlertWithTitle:@"Hmm" andMessage:@"XML parsing failed: registration"];
            return;
        }
        
        [self saveUserId:[_registerResponse id]];
        _registerResponse = nil;
    }
    
    // 2. get data
    NSXMLParser *getDataParser = [[NSXMLParser alloc] initWithData:[self dataForCompute]];
    [getDataParser delete:self];
    BOOL getDataSuccess = [getDataParser parse];
    
    if (!getDataSuccess) {
        [self showAlertWithTitle:@"Hmm" andMessage:@"XML parsing failed: getData"];
        return;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *from = [formatter numberFromString:[_getDataResponse from]];
    NSNumber *to = [formatter numberFromString:[_getDataResponse to]];
    _getDataResponse = nil;
    
    // 3. calculate
    //[_solver calculateFrom:<#(NSNumber *)#> to:<#(NSNumber *)#> up:<#(NSNumber *__autoreleasing *)#> down:<#(NSNumber *__autoreleasing *)#>
    
    // 4. show result
    
    // 5. send result
    
}

- (void)stop
{
    // wtf?
}

// TODO стринги захардкожены!!! БЛЕЯТЬ!!!
// Parser delegate methods
-(void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName 
     attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"RegisterResponse"]) {
        _registerResponse = [[RegisterResponse alloc] init];
    }
    else if ([elementName isEqualToString:@"GetDataToComputeResponse"]) {
        _getDataResponse = [[GetDataToComputeResponse alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!_currentElementValue) {
        _currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [_currentElementValue appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"RegisterResponse"] || [elementName isEqualToString:@"GetDataToComputeResponse"]) {
        return;
    }
    else if ([elementName isEqualToString:@"id"]) {
        [_registerResponse setValue:_currentElementValue forKey:elementName];
    }
    else {
        [_getDataResponse setValue:_currentElementValue forKey:elementName];
    }
    
    _currentElementValue = nil;
}

@end
