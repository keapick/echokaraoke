//
//  KaraokeTableViewController.m
//  EchoKaraoke
//
//  Created by echo on 6/17/17.
//  Copyright © 2017 echo. All rights reserved.
//

#import "KaraokeTableViewController.h"
#import "Song.h"
#import "SongPlayerViewController.h"

@interface KaraokeTableViewController ()
@property (nonatomic, strong, readwrite) NSMutableArray *songs;
@end

@implementation KaraokeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KaraokeTableCell" forIndexPath:indexPath];
    Song *song = [self.songs objectAtIndex:indexPath.row];
    cell.textLabel.text = song.title;
    
    return cell;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Song *song = [self.songs objectAtIndex:path.row];
    
    SongPlayerViewController *vc = (SongPlayerViewController *)[segue destinationViewController];
    [vc setSong:song];
}


- (IBAction)reloadSongs:(id)sender {
    self.songs = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:[self documentsURL] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSArray *mp3Files = [self mp3FilesFromAllFiles:allFiles];
    NSArray *cdgFiles = [self cdgFilesFromAllFiles:allFiles];
    
    for (NSURL *mp3 in mp3Files) {
        NSURL *cdg = [self cdgFileWithMatchingMp3Path:mp3.path cdgFiles:cdgFiles];
        if (cdg) {
            // TODO: find a reasonable way to parse out the filename, maybe in the mp3 metadata?
            [self.songs addObject:[Song songWithTitle:mp3.lastPathComponent mp3Path:mp3.lastPathComponent cdgPath:cdg.lastPathComponent]];
        }
    }
    
    [self.tableView reloadData];
}

- (NSURL *)cdgFileWithMatchingMp3Path:(NSString *)mp3Path cdgFiles:(NSArray *)cdgFiles {
    NSString *expectedCdgPath = [[mp3Path stringByDeletingPathExtension] stringByAppendingPathExtension:@"cdg"];
    for (NSURL *cdgFile in cdgFiles) {
        if ([expectedCdgPath caseInsensitiveCompare:cdgFile.path] == NSOrderedSame) {
            return cdgFile;
        }
    }
    
    NSLog(@"Failed to find a CDG file for %@", mp3Path);
    return nil;
}

- (NSArray *)mp3FilesFromAllFiles:(NSArray *)allFiles {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension ==[c] 'mp3'"];
    return [allFiles filteredArrayUsingPredicate:predicate];
}

- (NSArray *)cdgFilesFromAllFiles:(NSArray *)allFiles {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension ==[c] 'cdg'"];
    return [allFiles filteredArrayUsingPredicate:predicate];
}

// the application documents directory, used to save mp3 & cdg files
- (NSURL *) documentsURL {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if (path) {
        return [NSURL fileURLWithPath:path];
    }
    return nil;
}

@end
