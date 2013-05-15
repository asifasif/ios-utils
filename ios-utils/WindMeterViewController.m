//
//  ViewController.m
//  Sensor
//
//  Created by Derek Trauger on 3/22/13.
//  Copyright (c) 2013 WeatherFlow. All rights reserved.
//

#import "WindMeterViewController.h"
#import "SVProgressHUD.h"
#import "WFSensor.h"
#import "AnemometerObservation.h"
#import "SensorStatus.h"
#import "SensorHistoryTableViewController.h"
#import "WFSensorHistory.h"
#import "SensorObservationSummary.h"
#import "NSNumber+WindSpeed.h"
#import "MFSideMenuContainerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "DTAProgressBar.h"

@interface WindMeterViewController ()

@end

@implementation WindMeterViewController

@synthesize latestObservation;

-(void)viewDidDisappear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
    unitsLabel1.text = [[utils windUnitsLabel] uppercaseString];
    unitsLabel2.text = [[utils windUnitsLabel] uppercaseString];
    unitsLabel3.text = [[utils windDirectionUnitsLabel] uppercaseString];
    
    [self updateLatestSampleData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"Proxima Nova: %@",[UIFont fontNamesForFamilyName:@"Proxima Nova"]);
    
    unitsLabel1.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    unitsLabel2.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    unitsLabel3.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    
    sampleAvg.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:30.0];
    sampleDirection.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:30.0];
    sampleLull.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:30.0];
    sampleGust.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:30.0];
    sampleDateTime.font = [UIFont fontWithName:@"Proxima Nova Light" size:25.0];
    sampleLocation.font = [UIFont fontWithName:@"Proxima Nova Light" size:25.0];
    
    
    
    customProgressBar =
    [[DTAProgressBar alloc] initWithFrame:CGRectMake(0, 0, 263, 60)
                             andProgressBarColor:DTAProgressBarCustom];
    
    [customProgressBar setShowPercent:NO];
    [customProgressBar setShowProgressLabel:NO];
    [customProgressBar setMinProgressValue:0];
    [customProgressBar setMaxProgressValue:100];
    [customProgressBar setProgress:100];
    [customProgressBar setCustomLabelFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0]];
    [customProgressBar setCustomLabelTextColor:[UIColor whiteColor]];
    [customProgressBar setCustomLabelValue:NSLocalizedString(@"TAKE A READING", nil)];
    
    [customProgressBar addTarget:self action:@selector(recordSample) forControlEvents:UIControlEventTouchUpInside];
    
    [customButtonHolder addSubview:customProgressBar];
    
    realTimeReadingLabel.text = NSLocalizedString(@"REAL TIME READING", nil);
    realTimeReadingLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    
    
    speedLabel.text = NSLocalizedString(@"SPEED", nil);
    speedLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    realTimeSpeed.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:35.0];
    
    directionLabel.text = NSLocalizedString(@"DIRECTION", nil);
    directionLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    realTimeDirection.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:35.0];
    
    latestSampleLabel.text = NSLocalizedString(@"LATEST SAMPLE", nil);
    latestSampleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    
    sampleAvgLabel.text = NSLocalizedString(@"AVERAGE SPEED", nil);
    sampleAvgLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    
    sampleDirectionLabel.text = NSLocalizedString(@"AVERAGE DIRECTION", nil);
    sampleDirectionLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    
    sampleLullLabel.text = NSLocalizedString(@"LULL", nil);
    sampleLullLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    
    sampleGustLabel.text = NSLocalizedString(@"GUST", nil);
    sampleGustLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0];
    
    [innerConnectedView.layer setCornerRadius:15.0f];
    [innerConnectedView.layer setBorderWidth:1.0f];
    [innerConnectedView.layer setBorderColor:[UIColor blackColor].CGColor];
    [innerConnectedView.layer setMasksToBounds:YES];
    
    self.title = NSLocalizedString(@"", nil);
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)] autorelease];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:166.0/255.0 green:218.0/255.0 blue:96.0/255.0 alpha:1.0];
    
    history = [[WFSensorHistory alloc] init];
    
    sensor = [[WFSensor alloc] init];
    sensor.samplePeriod = 15; //sample for 15 sec when in record mode
    
    utils = [[Utils alloc] init];
    
    [sensor reportValueChange:^(AnemometerObservation *value){
        self.latestObservation = value;
        if ([value.statusCode intValue] == OK) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                connectedView.hidden = NO;
                notConnectedView.hidden = YES;
                realTimeSpeed.text = [utils windSpeedPerUnitSetting:value.windSpeed];
                [realTimeSpeed setNeedsDisplay];
                realTimeDirection.text = [utils windDirectionPerUnitSetting:[[value retain] autorelease]];
                [realTimeDirection setNeedsDisplay];
            });
        } else if ([value.statusCode intValue] == ANEMOMTER_NOT_CONNECTED) {
            connectedView.hidden = YES;
            notConnectedView.hidden = NO;
        }
    }];
    
    [sensor recordProgressValueChange:^(int value){
        dispatch_async(dispatch_get_main_queue(), ^{
            [customProgressBar setCustomLabelValue:NSLocalizedString(@"RECORDING...", nil)];
            [customProgressBar setProgress:((float)value/100.0)*100.0];
            [customProgressBar setNeedsDisplay];
            //[SVProgressHUD showProgress:((float)value/100.0) status:NSLocalizedString(@"RECORDING", nil)];
        });
    }];
    
    [sensor recordFinished:^(SensorObservations *value){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateLatestSampleData];
            [customProgressBar setCustomLabelValue:NSLocalizedString(@"TAKE A READING", nil)];
            [customProgressBar setProgress:100.0];
            //[SVProgressHUD dismiss];
        });
    }];
    
    
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

-(void) showMenu {
    [[self menuContainerViewController] toggleLeftSideMenuCompletion:^{NSLog(@"left menu toggled!");}];
}

-(void)start {
    [sensor startListener];
}

-(void)stop {
    [sensor stopListener];
}

-(void) recordSample
{
    if (sensor.isRecording) {
        [sensor stopRecording];
        [customProgressBar setCustomLabelValue:NSLocalizedString(@"TAKE A READING", nil)];
    } else {
        [sensor startRecording];
        [customProgressBar setCustomLabelValue:NSLocalizedString(@"RECORDING...", nil)];
    }
}


-(IBAction) record:(id)sender
{
    if (sensor.isRecording) {
        [sensor stopRecording];
        [sender setTitle:NSLocalizedString(@"TAKE A READING", nil) forState:UIControlStateNormal];
        [SVProgressHUD dismiss];
    } else {
        //[SVProgressHUD showProgress:0 status:NSLocalizedString(@"RECORDING", nil)];
        [sensor startRecording];
        [sender setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
    }
}

-(void) updateLatestSampleData {
    SensorObservationSummary *sos = [history getLatestSample];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"HH:mm, dd MMMM yyyy"];
    NSDate *parsedDate = [format dateFromString: sos.timestamp];
    [format1 stringFromDate:parsedDate];
    
    sampleAvg.text = [utils windSpeedPerUnitSetting:sos.avg];
    sampleDirection.text = [utils windDirectionSummaryPerUnitSetting:sos];
    sampleLull.text = [utils windSpeedPerUnitSetting:sos.lull];
    sampleGust.text = [utils windSpeedPerUnitSetting:sos.gust];;
    sampleLocation.text = [utils latitudeLongitudeFormatted: sos.latitude : sos.longitude];
    sampleDateTime.text = [format1 stringFromDate:parsedDate];
    [format release];
    [format1 release];
}


- (void)dealloc
{
    [utils release];
    [sensor release];
    sensor = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
