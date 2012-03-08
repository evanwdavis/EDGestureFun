//
//  EDHiddenTableViewController.m
//  EDGestureFun
//
//  Created by Evan Davis on 3/3/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "EDHiddenTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EDHiddenTableViewController ()
- (void)didPan:(UIPanGestureRecognizer *)recognizer;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * xShift;
@property (nonatomic) BOOL isPanningVertical;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@end

@implementation EDHiddenTableViewController

@synthesize tableView = _tableView;
@synthesize xShift = _xShift;
@synthesize isPanningVertical;
@synthesize selectedIndexPath = _selectedIndexPath;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor greenColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 200) / 2, (CGRectGetHeight(self.view.bounds) - 300.0) / 2, 200.0, 300.0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
    [self.view addSubview:self.tableView];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    self.xShift = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 460 - 30, CGRectGetWidth(self.view.bounds), 30.0)];
    self.xShift.textColor = [UIColor blackColor];
    self.xShift.text = @"Shift in X";
    self.xShift.backgroundColor = [UIColor clearColor];
    self.xShift.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:self.xShift];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Private methods

- (void)didPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translatedPoint = [recognizer translationInView:self.view];

    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Started!");
        self.isPanningVertical = (fabs(translatedPoint.y) > fabs(translatedPoint.x));
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Done!");
        self.xShift.textColor = [UIColor blackColor];
        [recognizer setTranslation:CGPointZero inView:self.view];

    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"translation: %f, %f", translatedPoint.x, translatedPoint.y);
        if(isPanningVertical)
        {
            CGFloat newY = self.tableView.contentOffset.y - translatedPoint.y;
            if (newY > -100 && newY < self.tableView.contentSize.height)
                [self.tableView setContentOffset:CGPointMake(0.0, newY)];
            [recognizer setTranslation:CGPointZero inView:self.view];
        }
        else 
        {
            self.xShift.textColor = [UIColor whiteColor];
            self.xShift.text = [NSString stringWithFormat:@"%f", translatedPoint.x];
        }
    }
}

#pragma mark UITableView-ScrollView-Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray * visibleIndices = [self.tableView indexPathsForVisibleRows];
    if([visibleIndices count] > 2)
    {
        NSIndexPath * newSelected = [visibleIndices objectAtIndex:2];
        NSLog(@"new %d old %d", newSelected.row, self.selectedIndexPath.row);
        if(newSelected.row != self.selectedIndexPath.row)
        {
            [self.tableView selectRowAtIndexPath:newSelected animated:YES scrollPosition:UITableViewScrollPositionNone];
            self.selectedIndexPath = newSelected;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint *)targetContentOffset
{
    
}

#pragma mark UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SimpleListControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Light" size:14];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    
    return cell;
}

@end
