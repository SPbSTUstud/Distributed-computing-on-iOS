//
//  FirstViewController.m
//  DistributedComputing
//
//  Created by Егор Быков on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "Solver.h"


@interface FirstViewController ()
@property (nonatomic) NSMutableData *receivedData;
@end

@implementation FirstViewController
@synthesize lblHeader;
@synthesize txtDescription;
@synthesize btnRegister;
@synthesize receivedData = _receivedData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLblHeader:nil];
    [self setTxtDescription:nil];
    [self setBtnRegister:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
        didFailWithError:(NSError *)error
{
    [txtDescription setText:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
                                      [error localizedDescription],
                                      [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [txtDescription setText:[[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding]];
}

-(void)solverDidProgressWithPercent:(float)percent{

}
-(void)solverDidFinishCalculateWithUp:(NSDecimalNumber *)up down:(NSDecimalNumber *)down{

}

- (IBAction)Register:(id)sender
{
    NSString *urlTemplate = @"http://%@:%@/DistributedComputingServer/API?action=%@&id=%@";
    NSString *serverName = @"127.0.0.1";
    NSString *serverPort = @"8080";
    
    NSString *xmlRegisterRequest = @"<RegisterRequest/>";
    //NSString *xmlGetDataRequest = @"<GetDataToComputeRequest/>";
    //NSString *xmlPutDataRequest = @"<PutDataComputedRequest/>";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:urlTemplate,serverName,serverPort,@"Register",@"0"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[xmlRegisterRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self];
    
    if (connection) {
        _receivedData = [[NSMutableData alloc] init];
    }
}
@end
