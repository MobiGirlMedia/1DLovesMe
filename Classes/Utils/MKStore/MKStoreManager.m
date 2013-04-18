//
//  MKStoreManager.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//  mugunthkumar.com
//

#import "MKStoreManager.h"


@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;
@synthesize delegate;

// all your features should be managed one and only by StoreManager
//static NSString *featureAId = @"com.appsnminded.jlovess.justinall";
static NSString *featureAId = @"com.appsnminded.1dlovesme.1dpack";
static NSString *featureBId = @"";
static NSString *featureCId = @"";

BOOL featureAPurchased;
BOOL featureBPurchased;
BOOL featureCPurchased;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
	
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (BOOL) featureAPurchased {
	return featureAPurchased;
}
+ (BOOL) featureBPurchased {
	return featureBPurchased;
}
+ (BOOL) featureCPurchased {
	return featureCPurchased;
}

+ (MKStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [NSMutableArray array];
			[_sharedStoreManager requestProductData];
			
			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[[MKStoreObserver alloc] init] autorelease];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 
								 [NSSet setWithObjects: featureAId, featureBId, featureCId, nil]]; // add any other product here
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

// $10,000 per $2
- (void) buyFeatureA
{
	[self buyFeature:featureAId];
}

- (void) buyFeatureARestore
{
	if ([SKPaymentQueue canMakePayments])
	{
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
		[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Popstar" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}
// $50,000 per $2
- (void) buyFeatureB
{
	[self buyFeature:featureBId];
}
// Unlock all girls per $4
- (void) buyFeatureC
{
	[self buyFeature:featureCId];
}

- (void) buyFeature:(NSString*) featureId
{
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Popstar" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

-(void)paymentCanceled
{
	[FlurryAnalytics logEvent:@"Payment canceled"];
	
	if([delegate respondsToSelector:@selector(failed)])
		[delegate failed];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if([delegate respondsToSelector:@selector(failed)])
		[delegate failed];
	
	[FlurryAnalytics logEvent:@"Purchase was failed"];
	
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void) provideContent: (NSString*) productIdentifier
{
	if([productIdentifier isEqualToString:featureAId])
	{
		featureAPurchased = YES;
		if([delegate respondsToSelector:@selector(productAPurchased)])
			[delegate productAPurchased];
	}

	if([productIdentifier isEqualToString:featureBId])
	{
		featureBPurchased = YES;
		if([delegate respondsToSelector:@selector(productBPurchased)])
			[delegate productBPurchased];
	}
	
	if([productIdentifier isEqualToString:featureCId])
	{
		featureCPurchased = YES;
		if([delegate respondsToSelector:@selector(productCPurchased)])
			[delegate productCPurchased];
	}
	
	[MKStoreManager updatePurchases];
}


+(void) loadPurchases 
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	featureAPurchased = [userDefaults boolForKey:featureAId]; 
	featureBPurchased = [userDefaults boolForKey:featureBId];
	featureCPurchased = [userDefaults boolForKey:featureCId]; 
}


+(void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:featureAPurchased forKey:featureAId];
	[userDefaults setBool:featureBPurchased forKey:featureBId];
	[userDefaults setBool:featureCPurchased forKey:featureCId];
}
@end
