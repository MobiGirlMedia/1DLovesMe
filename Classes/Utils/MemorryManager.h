//
//  MemorryManager.h
//  Biber
//
//  Created by Alexander Morgan on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/sysctl.h>
#import <mach/mach_host.h>



@interface MemorryManager : NSObject


@end


static int printMemoryInfo()
{

	size_t length;
	int mib[6];
	int result;
	
	printf("Memory Info\n");
	printf("-----------\n");
	
	int pagesize;
	mib[0] = CTL_HW;
	mib[1] = HW_PAGESIZE;
	length = sizeof(pagesize);
	if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
	{
		perror("getting page size");
	}
	printf("Page size = %d bytes\n", pagesize);
	printf("\n");
	
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	
	vm_statistics_data_t vmstat;
	if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
	{
		printf("Failed to get VM statistics.");
	}
	
	double total = vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count;
	double wired = vmstat.wire_count / total;
	double active = vmstat.active_count / total;
	double inactive = vmstat.inactive_count / total;
	double free = vmstat.free_count / total;
	
//	printf("Total =    %8d pages\n", vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count);
//	printf("\n");
//	printf("Wired =    %8d bytes\n", vmstat.wire_count * pagesize);
//	printf("Active =   %8d bytes\n", vmstat.active_count * pagesize);
//	printf("Inactive = %8d bytes\n", vmstat.inactive_count * pagesize);
	printf("Free =     %8d bytes\n", vmstat.free_count * pagesize);
//	printf("\n");
//	printf("Total =    %8d bytes\n", (vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pagesize);
//	printf("\n");
//	printf("Wired =    %0.2f %%\n", wired * 100.0);
//	printf("Active =   %0.2f %%\n", active * 100.0);
//	printf("Inactive = %0.2f %%\n", inactive * 100.0);
//	printf("Free =     %0.2f %%\n", free * 100.0);
//	printf("\n");
	
	mib[0] = CTL_HW;
	mib[1] = HW_PHYSMEM;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting physical memory");
	}
	printf("Physical memory = %8d bytes\n", result);
	mib[0] = CTL_HW;
	mib[1] = HW_USERMEM;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting user memory");
	}
	printf("User memory =     %8d bytes\n", result);
	printf("\n");
	
	return vmstat.free_count * pagesize;
	
/*
	int sizefree = 1;
	size_t length;
	int mib[6];
	
#ifdef DEBUG	
	//	printf("Memory Info\n");
	//	printf("-----------\n");
#endif
	
	int pagesize;
	mib[0] = CTL_HW;
	mib[1] = HW_PAGESIZE;
	length = sizeof(pagesize);
	if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
	{
		perror("getting page size");
	}
	
#ifdef DEBUG
	//	printf("Page size = %d bytes\n", pagesize);
	//	printf("\n");
#endif
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	
	vm_statistics_data_t vmstat;
	if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
	{
		printf("Failed to get VM statistics.");
	}
	
	sizefree = (vmstat.free_count * pagesize)/480/320;
	
	
	printf("Free = %d Mb\n", sizefree);
	
	return sizefree;
 */
}
