//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import "MKStoreObserver.h"
#import "MKStoreManager.h"

@implementation MKStoreObserver


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				
                [self completeTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateFailed:
				
                [self failedTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateRestored:
				
                [self restoreTransaction:transaction];
				
            case SKPaymentTransactionStatePurchasing:
                
                break;
            
            default:
				
                break;
		}			
	}
}

- (int)getCacheMoney{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"money"];
}

- (void)setCacheMoney: (int) money {
    
    [[NSUserDefaults standardUserDefaults] setInteger:money forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	
	
    NSLog(@"money is: %d",[self getCacheMoney]);
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{	
    if (transaction.error.code != SKErrorPaymentCancelled)		
    {		
        // Optionally, display an error here.		
    }	

	
	[[MKStoreManager sharedManager] paymentCanceled];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	

    PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];

    [app hideHUD];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{		
    [[MKStoreManager sharedManager] provideContent: transaction.payment.productIdentifier];	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
	PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
    	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"time"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	NSString *ipad = (app.isPad) ? @" by iPad" : @" by iPhone";
	[FlurryAnalytics logEvent:[NSString stringWithFormat:@"User unlocked Justin clothes%@",ipad]];

	[self unlockAll];
	
	[app hideHUD];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Thanks for your purchase!" 
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
    [alert show];
    [alert release];
}

- (void) purchasing {
//    PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [[app.viewController girls] showActivityIndicator];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{	
    [[MKStoreManager sharedManager] provideContent: transaction.originalTransaction.payment.productIdentifier];	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
}


- (void) unlockAll {
	PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
	[app.viewController.girls removeLock];	
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    if( queue.transactions.count > 0 ) {
        [[MKStoreManager sharedManager] provideContent:@"com.appsnminded.1dlovesme.1dpack"];
    
        PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
    
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"time"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [self unlockAll];
	
        [app hideHUD];
	
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Restore was successful!"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
        [alert show];
        [alert release];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app hideHUD];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Restore was un-successful"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
    [alert show];
    [alert release];
}

@end