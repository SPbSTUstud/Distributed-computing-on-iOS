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
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) UITextView *outputTextView;
@property (nonatomic, strong) Solver *solver;

@property (nonatomic, strong) RegisterResponse *registerResponse;
@property (nonatomic, strong) GetDataToComputeResponse *getDataResponse;

@property (nonatomic, strong) NSMutableString *currentElementValue;

@property (nonatomic, strong) UIAlertView *alert;

// Private methods
- (NSURL *)urlForAction:(NSString *)action andUserId:(NSString *)userId;
- (NSMutableURLRequest *)requestForUrl:(NSURL *)url andBody:(NSString *)body;

- (NSString *)userIdFromSettings;
- (void)saveUserId:(NSString *)userId;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

- (NSData *)dataForRegister;
- (NSData *)dataForCompute;
- (void)sendComputedWithUp:(NSNumber *)up andDown:(NSNumber *)down;

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
@synthesize alert;

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
    //return [defaults stringForKey:userIdKey];
    return [[defaults stringForKey:userIdKey] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)saveUserId:(NSString *)userId
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:userId forKey:userIdKey];
    [defaults synchronize];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self alert]) {
            self.alert = [[UIAlertView alloc] init];
            [[self alert] setDelegate:nil];
            [[self alert] addButtonWithTitle:@"Ok"];
            [[self alert] setCancelButtonIndex:0];
        }
    
        [[self alert] setTitle:title];
        [[self alert] setMessage:message];
        [[self alert] show];
    });
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

- (void)sendComputedWithUp:(NSNumber *)up andDown:(NSNumber *)down
{
    NSString *userId = [self userIdFromSettings];
    
    if (!userId) {
        [self showAlertWithTitle:@"Hmm" andMessage:@"Bad user ID"];
        return;
    }
    
    NSURL *url = [self urlForAction:actionPutData andUserId:userId];
    NSMutableURLRequest *request = [self requestForUrl:url andBody:xmlPutDataRequest];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!result) {
        [self showAlertWithTitle:@"Sending of data failed" andMessage:[error description]];
    }
}

- (void)solverDidProgressWithPercent:(NSNumber*)percent
{

}

// Implement required methods
- (void)goWithOutputIn:(UITextView *)textView
{
    // Output for our spam
    [self setOutputTextView:textView];
    
    // 1. register if needed
    NSString *userId = [self userIdFromSettings];
    if (!userId) {
        NSXMLParser *registrationParser = [[NSXMLParser alloc] initWithData:[self dataForRegister]];
        [registrationParser setDelegate:self];
        BOOL registrationSuccess = [registrationParser parse];
        
        if (!registrationSuccess) {
            [self showAlertWithTitle:@"XML parsing failed: register" andMessage:[[NSString alloc] initWithData:[self dataForRegister] encoding:NSUTF8StringEncoding]];
            return;
        }
        
        [self saveUserId:[[self registerResponse] id]];
        [self setRegisterResponse:nil];
    }
    
    // 2. get data
    NSXMLParser *getDataParser = [[NSXMLParser alloc] initWithData:[self dataForCompute]];
    [getDataParser setDelegate:self];
    BOOL getDataSuccess = [getDataParser parse];
    
    if (!getDataSuccess) {
        [self showAlertWithTitle:@"XML parsing failed: getData" andMessage:[[NSString alloc] initWithData:[self dataForCompute] encoding:NSUTF8StringEncoding]];
        return;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *from = [formatter numberFromString:[[self getDataResponse] from]];
    NSNumber *to = [formatter numberFromString:[[self getDataResponse] to]];
    [self setGetDataResponse:nil];
    
    if ([from intValue] == -1 && [to intValue] == -1) {
        [self showAlertWithTitle:@"Ok" andMessage:@"Nothing to calculate"];
    }
    
    //3. calculate
    self.solver = [[Solver alloc] init];
    [self.solver calculateFrom:from to:to processing:@selector(solverDidProgressWithPercent:) finish:@selector(sendComputedWithUp::)];
}

- (void)stop
{
    // wtf?
}

// Parser delegate methods
-(void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName 
     attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"RegisterResponse"]) {
        [self setRegisterResponse:[[RegisterResponse alloc] init]];
    }
    else if ([elementName isEqualToString:@"GetDataToComputeResponse"]) {
        [self setGetDataResponse:[[GetDataToComputeResponse alloc] init]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (![self currentElementValue]) {
        [self setCurrentElementValue:[[NSMutableString alloc] initWithString:string]];
    }
    else {
        [[self currentElementValue] appendString:string];
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
        [[self registerResponse] setValue:[self currentElementValue] forKey:elementName];
    }
    else {
        [[self getDataResponse] setValue:[self currentElementValue] forKey:elementName];
    }
    
    [self setCurrentElementValue:nil];
}

@end
