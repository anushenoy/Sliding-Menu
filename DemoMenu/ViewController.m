//
//  ViewController.m
//  DemoMenu
//
//  Created by neebal on 03/09/15.
//  Copyright (c) 2015 neebal. All rights reserved.
//

#import "ViewController.h"
#define menuWidth 150.0

@interface ViewController ()

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UITableView *menuTable;
@property (nonatomic, strong) UIDynamicAnimator *animator;

-(void)setupMenuView;
-(void)handleGesture:(UISwipeGestureRecognizer *)gesture;
-(void)toggleMenu:(BOOL)shouldOpenMenu;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupMenuView];
    
   _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //Right Swipe
    UISwipeGestureRecognizer *showMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleGesture:)];
    showMenuGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:showMenuGesture];
    
    //LeftSwipe
    UISwipeGestureRecognizer *hideMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleGesture:)];
    hideMenuGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_menuView addGestureRecognizer:hideMenuGesture];
    [self.view addGestureRecognizer:hideMenuGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private method implementation

-(void)setupMenuView
{

    // Setup the menu view.
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(-menuWidth,
                                                             0,
                                                             menuWidth,
                                                             self.view.frame.size.height)];

    _menuView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.menuView];
    
    
    // Setup the table view.
    _menuTable = [[UITableView alloc] initWithFrame:_menuView.bounds
                                              style:UITableViewStylePlain];
    _menuTable.backgroundColor = [UIColor clearColor];
    _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTable.scrollEnabled = NO;
    _menuTable.alpha = 1.0;
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    
    [self.menuView addSubview:self.menuTable];
    
}


-(void)handleGesture:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self toggleMenu:YES];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self toggleMenu:NO];
    }
}


-(void)toggleMenu:(BOOL)shouldOpenMenu
{
    
    [self.animator removeAllBehaviors];

    //Set constants
    CGFloat gravityDirectionX = (shouldOpenMenu) ? 1.0 : -1.0;
    CGFloat pushMagnitude = (shouldOpenMenu) ? 20.0 : -20.0;
    CGFloat boundaryPointX = (shouldOpenMenu) ? menuWidth: -menuWidth;
    
    //Gravity behaviour
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.menuView]];
    gravityBehavior.gravityDirection = CGVectorMake(gravityDirectionX, 0.0);
    [self.animator addBehavior:gravityBehavior];
    
    //Collission behaviour
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.menuView]];
    [collisionBehavior addBoundaryWithIdentifier:@"menuBoundary"
                                       fromPoint:CGPointMake(boundaryPointX, 0)
                                         toPoint:CGPointMake(boundaryPointX, self.view.frame.size.height)];
    [self.animator addBehavior:collisionBehavior];
    
    //Push behaviour
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.menuView]
                                                                    mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.magnitude = pushMagnitude;
    [self.animator addBehavior:pushBehavior];
    
    //Elastic behaviour
    UIDynamicItemBehavior *menuViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.menuView]];
    menuViewBehavior.elasticity = 0.4;
    [self.animator addBehavior:menuViewBehavior];
    
    self.view.alpha = (shouldOpenMenu) ? 0.5 : 1.0;
}


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *menuOptionText = [NSString stringWithFormat:@"Option %ld", indexPath.row + 1];
    cell.textLabel.text = menuOptionText;
    
    cell.textLabel.textColor = [UIColor whiteColor];
   
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

@end
