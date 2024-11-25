#include <linux/module.h>
#include <linux/printk.h>

int start_module(void);
void end_module(void);

int start_module(void) 
{ 
  pr_info("Loaded GCTF module\n"); 
  return 0; 
} 

void end_module(void) 
{ 
  pr_info("Unloaded CTF module\n"); 
} 

module_init(start_module);
module_exit(end_module);

MODULE_LICENSE("GPL");
