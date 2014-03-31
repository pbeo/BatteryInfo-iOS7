//
//  ELViewController.m
//  BatteryInfo
//
//  Created by Piotr Ożóg on 04.03.2014.
//  Copyright (c) 2014 Piotr Ozog. All rights reserved.
//

#import "ELViewController.h"

@interface PLBatteryPropertiesEntry : NSObject
+ (id)batteryPropertiesEntry;
@property(readonly, nonatomic) BOOL draining;
@property(readonly, nonatomic) BOOL isPluggedIn;
@property(readonly, nonatomic) NSString *chargingState;
@property(readonly, nonatomic) int batteryTemp;
@property(readonly, nonatomic) NSNumber *connectedStatus;
@property(readonly, nonatomic) NSNumber *adapterInfo;
@property(readonly, nonatomic) int chargingCurrent;
@property(readonly, nonatomic) BOOL fullyCharged;
@property(readonly, nonatomic) BOOL isCharging;
@property(readonly, nonatomic) int cycleCount;
@property(readonly, nonatomic) int designCapacity;
@property(readonly, nonatomic) double rawMaxCapacity;
@property(readonly, nonatomic) double maxCapacity;
@property(readonly, nonatomic) double rawCurrentCapacity;
@property(readonly, nonatomic) double currentCapacity;
@property(readonly, nonatomic) int current;
@property(readonly, nonatomic) int voltage;
@property(readonly, nonatomic) BOOL isCritical;
@property(readonly, nonatomic) double rawCapacity;
@property(readonly, nonatomic) double capacity;
@end


@interface ELViewController ()
@property (nonatomic, strong) NSDictionary *batteryInfo;
@property (nonatomic, strong) NSTimer *refreshTimer;
@end

@implementation ELViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initBatteryInfo];
    }
    return self;
}

- (void)dealloc {
    [self.refreshTimer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.title = @"Battery Info";
}

- (void) viewDidAppear:(BOOL)animated {
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshBatteryInfo:) userInfo:nil repeats:YES];
}

- (void) refreshBatteryInfo:(NSTimer*)timer {
    [self initBatteryInfo];
    [self.tableView reloadData];
}

#pragma mark BatteryInfo

- (void) initBatteryInfo {
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/PowerlogLoggerSupport.framework"];
    BOOL success = [b load];
    
    if (success) {
        Class PLBatteryPropertiesEntry = NSClassFromString(@"PLBatteryPropertiesEntry");
        id deviceInfo = [[PLBatteryPropertiesEntry alloc] init];
        
        NSMutableDictionary *batteryInfo = [NSMutableDictionary dictionary];

        
        [batteryInfo setObject:[deviceInfo draining] ? @"Yes" : @"No" forKey:@"draining"];
        [batteryInfo setObject:[deviceInfo isPluggedIn] ? @"Yes" : @"No" forKey:@"isPluggedIn"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%@", [deviceInfo chargingState]] forKey:@"chargingState"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%d", [deviceInfo batteryTemp]] forKey:@"batteryTemp"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%@", [deviceInfo connectedStatus]] forKey:@"connectedStatus"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%@", [deviceInfo adapterInfo]] forKey:@"adapterInfo"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%d", [deviceInfo chargingCurrent]] forKey:@"chargingCurrent"];
        [batteryInfo setObject:[deviceInfo fullyCharged] ? @"Yes" : @"No" forKey:@"fullyCharged"];
        [batteryInfo setObject:[deviceInfo isCharging] ? @"Yes" : @"No" forKey:@"isCharging"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%d", [deviceInfo cycleCount]] forKey:@"cycleCount"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%d", [deviceInfo designCapacity]] forKey:@"designCapacity"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%f", [deviceInfo rawMaxCapacity]] forKey:@"rawMaxCapacity"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%f", [deviceInfo maxCapacity]] forKey:@"maxCapacity"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%f", [deviceInfo rawCurrentCapacity]] forKey:@"rawCurrentCapacity"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%f", [deviceInfo currentCapacity]] forKey:@"currentCapacity"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%d", [deviceInfo current]] forKey:@"current"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%d", [deviceInfo voltage]] forKey:@"voltage"];
        [batteryInfo setObject:[deviceInfo isCritical] ? @"Yes" : @"No" forKey:@"isCritical"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%f", [deviceInfo rawCapacity]] forKey:@"rawCapacity"];
        [batteryInfo setObject:[NSString stringWithFormat:@"%f", [deviceInfo capacity]] forKey:@"capacity"];
        
        self.batteryInfo = batteryInfo;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.batteryInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"BatteryInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *title = [[self.batteryInfo allKeys] objectAtIndex:indexPath.row];
    NSString *detail = [[self.batteryInfo allValues] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    
    return cell;
}


@end
