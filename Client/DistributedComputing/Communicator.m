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
@property (nonatomic) BOOL needToStop;
@property (nonatomic, strong) NSString *serverAddress;

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
NSString *const urlTemplate = @"API?action=%@&id=%@";

NSString *const userIdKey = @"userId";
NSString *const actionRegister = @"Register";
NSString *const actionGetData = @"GetDataToCompute";
NSString *const actionPutData = @"PutDataComputed";

NSString *const xmlRegisterRequest = @"<RegisterRequest/>";
NSString *const xmlGetDataRequest = @"<GetDataToComputeRequest/>";
NSString *const xmlPutDataRequest = @"<PutDataComputedRequest><up>%@</up><down>%@</down></PutDataComputedRequest>";

// Synthesize private properties
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;

@synthesize outputTextView = _outputTextView;
@synthesize solver = _solver;

@synthesize registerResponse = _registerResponse;
@synthesize getDataResponse = _getDataResponse;

@synthesize currentElementValue = _currentElementValue;
@synthesize alert;

@synthesize serverAddress = _serverAddress;
@synthesize needToStop = _needToStop;

// Implement private methods
- (NSURL *)urlForAction:(NSString *)action andUserId:(NSString *)userId
{
    NSString *first = [self serverAddress];
    NSString *second = [NSString stringWithFormat:urlTemplate,action,userId];
    return [NSURL URLWithString:[first stringByAppendingString:second]];
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
        self.needToStop = YES;
        return nil;
    }
    
    return result;
}

- (NSData *)dataForCompute
{
    NSString *userId = [self userIdFromSettings];
    
    if (!userId) {
        [self showAlertWithTitle:@"Hmm" andMessage:@"Bad user ID"];
        self.needToStop = YES;
        return nil;
    }
    
    NSURL *url = [self urlForAction:actionGetData andUserId:userId];
    NSMutableURLRequest *request = [self requestForUrl:url andBody:xmlGetDataRequest];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    //[self showAlertWithTitle:@"Receiving of data ..." andMessage:[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]];

    if (!result) {
        [self showAlertWithTitle:@"Receiving of data failed" andMessage:[error description]];
        self.needToStop = YES;
        return nil;
    }
    
    return result;
}

- (void)sendComputedWithUp:(NSDecimalNumber *)up andDown:(NSDecimalNumber *)down
{
    NSString *userId = [self userIdFromSettings];

    if (!userId) {
        [self showAlertWithTitle:@"Hmm" andMessage:@"Bad user ID"];
        self.needToStop = YES;
        return;
    }

    NSURL *url = [self urlForAction:actionPutData andUserId:userId];
    NSMutableURLRequest *request = [self requestForUrl:url andBody:[NSString stringWithFormat:xmlPutDataRequest,[up description],[down description]]];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (!result) {
        [self showAlertWithTitle:@"Sending of data failed" andMessage:[error description]];
        self.needToStop = YES;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = [[self outputTextView] text];
        str = [str stringByAppendingString:@"\nup: "];
        str = [str stringByAppendingString:[up description]];
        [[self outputTextView] setText:str];
    });
}

- (void)solverDidProgressWithPercent:(NSNumber*)percent {

}

- (void)solverDidFinishWithUp:(NSDecimalNumber *)up down:(NSDecimalNumber *)down {
    [self sendComputedWithUp:up andDown:down];
}

// Implement required methods
- (void)goWithAddress:(NSString *)address andOutputIn:(UITextView *)textView;
{
    // Output for our spam
    [self setOutputTextView:textView];
    self.needToStop = NO;
    self.serverAddress = address;
    
    // 1. register if needed
    NSString *userId = [self userIdFromSettings];
    if (!userId) {
        NSData *data = [self dataForRegister];
        NSXMLParser *registrationParser = [[NSXMLParser alloc] initWithData:data];
        [registrationParser setDelegate:self];
        BOOL registrationSuccess = [registrationParser parse];

        //[self showAlertWithTitle:@"register response" andMessage:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];

        if (!registrationSuccess) {
            [self showAlertWithTitle:@"XML parsing failed: register" andMessage:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            self.needToStop = YES;
            return;
        }
        
        [self saveUserId:[[self registerResponse] id]];
        [self setRegisterResponse:nil];
    }

    while (![self needToStop])
    {
        // 2. get data
        NSData *data = [self dataForCompute];
        NSXMLParser *getDataParser = [[NSXMLParser alloc] initWithData:data];
        [getDataParser setDelegate:self];
        BOOL getDataSuccess = [getDataParser parse];

        //[self showAlertWithTitle:@"getData response" andMessage:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];

        if (!getDataSuccess) {
            [self showAlertWithTitle:@"XML parsing failed: getData" andMessage:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            self.needToStop = YES;
            return;
        }

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

        NSString *strFrom = [[[self getDataResponse] from] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *strTo = [[[self getDataResponse] to] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSNumber *from = [formatter numberFromString:strFrom];
        NSNumber *to = [formatter numberFromString:strTo];
        [self setGetDataResponse:nil];

        if ([from intValue] == -1 && [to intValue] == -1) {
            [self showAlertWithTitle:@"Ok" andMessage:@"Nothing to calculate"];
            self.needToStop = YES;
        }

        //3. calculate
        self.solver = [[Solver alloc] init];
        [self.solver calculateFrom:from to:to delegate:self];
    }
}

- (void)stop
{
    self.needToStop = YES;
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
