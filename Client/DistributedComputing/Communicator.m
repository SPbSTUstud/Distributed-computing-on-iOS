//
//  Communicator.m
//  DistributedComputing
//
//  Created by Tatiana Petrova on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Communicator.h"
#import "Solver.h"

@interface Communicator()

// Private properties
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSMutableData *receivedData;
@property (nonatomic) UITextView *outputTextView;
@property (nonatomic) Solver *solver;
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

// Implement required methods
- (void)goWithOutputIn:(UITextView *)textView
{
    // Output for our spam
    _outputTextView = textView;
    
    // 1. register if needed
    NSString *userId = [[[NSUserDefaults alloc] init] stringForKey:userIdKey];
    if (!userId) {
        
    }
    
    // 2. get data
    
    
    // 3. calculate
    
    
    // 4. show result
    
    // 5. send result
    
}

- (void)stop
{
    // wtf?
}
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed"
//                                             message:[error description] delegate:nil
//                                             cancelButtonTitle:@"Ok"
//                                             otherButtonTitles:nil];
//    [alert show];
//}

@end
