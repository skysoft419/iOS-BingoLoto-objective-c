//
//  OptionsTableViewController.m
//  BingoLoto
//
//  Created by Johann Huguenin on 20.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "OptionsTableViewController.h"
#import "Common/AppManager.h"
#import "Common/Constants.h"
#import "AppDelegate.h"
#import "RageIAPHelper.h"


@interface OptionsTableViewController ()

@end

@implementation OptionsTableViewController

+(UINavigationController*)create
{
    OptionsTableViewController*options=[[OptionsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    return [[UINavigationController alloc]initWithRootViewController:options];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
    //en,fr-US,    de-US
    [self.tableView registerNib:[UINib nibWithNibName:@"SoundSpeed" bundle:nil] forCellReuseIdentifier:@"SoundSpeed"];
    
}
// soundOnOff
- (IBAction)soundOnOffAction:(id)sender
{
    if([[AppManager sharedInstance] isSoundOn]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SOUNDON];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SOUNDON];
    }
    //    [[AppManager sharedInstance] playMusic];
}
//speechSpeed
- (IBAction)speechSpeedAction:(id)sender
{
    UISlider*speed = (UISlider*)sender;
    float speechSpeed = speed.value;
    [[NSUserDefaults standardUserDefaults] setFloat:speechSpeed forKey:SPEECHSPEED];
}
//speechOnOff
- (IBAction)speechOnOffAction:(id)sender
{
    if([[AppManager sharedInstance] isSpeechOn]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SPEECHON];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SPEECHON];
    }
}


-(IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 3; //sound
    else if (section == 1)
        return 2;// docSize
    else if (section == 2)
        return 4;// language
    else
        return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return NSLocalizedString(@"Sounds", @"");
    }else if (section==1){
        return NSLocalizedString(@"PageSize", @"");
    }else if (section==2){
        return NSLocalizedString(@"Language", @"");
    }else{
        return NSLocalizedString(@"Restore Purchase", @"");
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(indexPath.section==0)
    {
        /* Sound effects here */
        
        if(indexPath.row==0)
        {
            static NSString *CellIdentifier = @"SoundOnCell";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            //add a switch
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
            if([[AppManager sharedInstance] isSoundOn])
                [switchview setOn:YES];
            else
                [switchview setOn:NO];
            [switchview addTarget:self action:@selector(soundOnOffAction:) forControlEvents:UIControlEventValueChanged];
            cell.textLabel.text = NSLocalizedString(@"Sound", @"");
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
        if(indexPath.row==1)
        {
            static NSString *CellIdentifier = @"SpeechOnCell";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            //add a switch
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
            if([[AppManager sharedInstance] isSpeechOn])
                [switchview setOn:YES];
            else
                [switchview setOn:NO];
            [switchview addTarget:self action:@selector(speechOnOffAction:) forControlEvents:UIControlEventValueChanged];
            cell.textLabel.text = NSLocalizedString(@"Speech", @"");
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
        else
        {
            float speed = [[AppManager sharedInstance] speechSpeed];
            cell=[tableView dequeueReusableCellWithIdentifier:@"SoundSpeed" forIndexPath:indexPath];
            UISlider*slider=[[cell subviews][0] subviews][2] ;
            [slider setValue:speed];
        }
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            static NSString *CellIdentifier = @"DocA4";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            if([[AppManager sharedInstance] isDocA4])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"A4";
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
        if(indexPath.row==1)
        {
            static NSString *CellIdentifier = @"DocUS";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            if(![[AppManager sharedInstance] isDocA4])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"US Letter";
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
    }else if(indexPath.section==2){
        
        if(indexPath.row==0)
        {
            static NSString *CellIdentifier = @"Automatic";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            if([[AppManager sharedInstance] languageSelect] == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"Automatic";
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
        if(indexPath.row==1)
        {
            static NSString *CellIdentifier = @"English";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            if([[AppManager sharedInstance] languageSelect] == 1)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"English";
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
        if(indexPath.row==2)
        {
            static NSString *CellIdentifier = @"German";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            if([[AppManager sharedInstance] languageSelect] == 2)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"Deutsch";
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
        if(indexPath.row==3)
        {
            static NSString *CellIdentifier = @"Franch";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            if([[AppManager sharedInstance] languageSelect] == 3)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"Français";
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
    }else{
        if(indexPath.row==0)
        {
            static NSString *CellIdentifier = @"Purchase";
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            cell.textLabel.text = NSLocalizedString(@"Restore Premium Version", @"");
            cell.layoutMargins = UIEdgeInsetsMake(0, 45, 0, 0);
            return cell;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger curRow = indexPath.row;
    
    if(indexPath.section == 1){
        if([[AppManager sharedInstance] isDocA4]){
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DOCA4];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DOCA4];
        }
    }
    if(indexPath.section == 2){
        switch (curRow) {
            case 0:
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LANGUAGEOPT];
                break;
            case 1:
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:LANGUAGEOPT];
                break;
            case 2:
                [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:LANGUAGEOPT];
                break;
            case 3:
                [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:LANGUAGEOPT];
                break;
            default:
                break;
        }
        //reload
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        delegate.window.rootViewController = [storyboard instantiateInitialViewController];
        
    }
    
    if(indexPath.section == 3){
        [[RageIAPHelper sharedInstance] restorePurchases];
    }
    
    [tableView reloadData];
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
