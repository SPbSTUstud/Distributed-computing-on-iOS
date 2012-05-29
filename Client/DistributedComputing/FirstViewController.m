//
//  FirstViewController.m
//  DistributedComputing
//
//  Created by Егор Быков on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "Communicator.h"
#import "Solver.h"


@interface FirstViewController ()
@property (nonatomic, strong) Communicator *communicator;
@end

@implementation FirstViewController
@synthesize lblHeader;
@synthesize txtDescription;
@synthesize btnRegister;
@synthesize communicator = _communicator;

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

-(void)solverDidProgressWithPercent:(float)percent
{

}

-(void)solverDidFinishCalculateWithUp:(NSDecimalNumber *)up down:(NSDecimalNumber *)down
{

}

- (IBAction)Register:(id)sender
{
    UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
    
    __block UIBackgroundTaskIdentifier background_task; //Create a task object
    
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
        [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
        background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
        
        //System will be shutting down the app at any point in time now
    }];
    
    //Background tasks require you to use asyncrous tasks
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Perform your tasks that your application requires
        [self setCommunicator:[[Communicator alloc] init]];
        [[self communicator] goWithOutputIn:txtDescription];
        
        [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
        background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
    });
}
@end
