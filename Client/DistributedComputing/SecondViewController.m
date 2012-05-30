//
//  SecondViewController.m
//  DistributedComputing
//
//  Created by Егор Быков on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize txtAddress;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[ ((AppDelegate *)[[UIApplication sharedApplication] delegate]) setServerAddress:[txtAddress text]]];
}

- (void)viewDidUnload
{
    [self setTxtAddress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)Edited:(UITextField *)sender
{
    [[ ((AppDelegate *)[[UIApplication sharedApplication] delegate]) setServerAddress:[txtAddress text]]];
}
@end
