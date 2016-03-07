//
//  FlieTableViewController.m
//  EHMediaPlayer
//
//  Created by howell on 9/29/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "FlieTableViewController.h"
#import "net_sdk.h"
#import "PlayBackFileInfo.h"

@interface FlieTableViewController () {
    int _userHandle;
}

@property (nonatomic) NSMutableArray * playBackFileInfos;
@end

@implementation FlieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userHandle = hwnet_login("192.168.2.103",
                              5198,
                              "admin",
                              "12345");
    
    SYSTEMTIME beginTime,endTime;
    [self getCurrentDataBeginTime:&beginTime
                          endTime:&endTime];
    
    Pagination pagination = {
        .page_size = 10,
        .page_no = 0
    };
    
    FILE_LIST_HANDLE fileListHandle = hwnet_get_file_list_by_page(_userHandle,
                                                              0,
                                                              0,
                                                              beginTime,
                                                              endTime,
                                                              0,
                                                              1,
                                                              0,
                                                              &pagination);
    
    for (int i = 0; i < pagination.cur_size; i++) {
        SYSTEMTIME tempBeginTime,tempEndTime;
        int type;
        hwnet_get_file_detail(fileListHandle,
                              i,
                              &tempBeginTime,
                              &tempEndTime,
                              &type);
        PlayBackFileInfo * playbackFileInfo = [PlayBackFileInfo playbackplaybackInfoWithBiginTime:tempBeginTime
                                                                          endTime:tempEndTime
                                                                             type:type];
        [self.playBackFileInfos addObject:playbackFileInfo];
    }
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playBackFileInfos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    PlayBackFileInfo * playBackFileInfo = self.playBackFileInfos[indexPath.row];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%d",playBackFileInfo.totalSeconds];
    
    return cell;
}


#pragma mark - Private Methods
- (void) getCurrentDataBeginTime:(SYSTEMTIME *)begintm
                         endTime:(SYSTEMTIME *)endtm {
    
    time_t begin,end;
    struct tm *endTimeInfo,*beginTimeInfo;
    
    time(&end);
    begin = end - 10*365*24*3600;
    endTimeInfo = localtime(&end);
    endtm->wYear = endTimeInfo->tm_year+1900;
    endtm->wMonth = endTimeInfo->tm_mon+1;
    endtm->wDay = endTimeInfo->tm_mday;
    endtm->wHour = endTimeInfo->tm_hour;
    endtm->wMinute = endTimeInfo->tm_min;
    endtm->wSecond = endTimeInfo->tm_sec;
    
    beginTimeInfo = localtime(&begin);
    begintm->wYear = beginTimeInfo->tm_year+1900;
    begintm->wMonth = beginTimeInfo->tm_mon+1;
    begintm->wDay = beginTimeInfo->tm_mday;
    begintm->wHour = beginTimeInfo->tm_hour;
    begintm->wMinute = beginTimeInfo->tm_min;
    begintm->wSecond = beginTimeInfo->tm_sec;
}


#pragma mark - Getters & Setters
- (NSMutableArray*)playBackFileInfos {
    if (!_playBackFileInfos) {
        _playBackFileInfos = [NSMutableArray array];
    }
    return _playBackFileInfos;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
