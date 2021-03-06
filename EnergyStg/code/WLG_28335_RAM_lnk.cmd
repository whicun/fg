/*
// TI File $Revision: /main/9 $
// Checkin $Date: August 28, 2007   11:23:31 $
//###########################################################################
//
// FILE:    28335_RAM_lnk.cmd
//
// TITLE:   Linker Command File For 28335 examples that run out of RAM
//
//          This ONLY includes all SARAM blocks on the 28335 device.
//          This does not include flash or OTP. 
//
//          Keep in mind that L0 and L1 are protected by the code
//          security module.
//
//          What this means is in most cases you will want to move to 
//          another memory map file which has more memory defined.  
//
//###########################################################################
// $TI Release: DSP2833x Header Files V1.10 $
// $Release Date: February 15, 2008 $
//###########################################################################
*/

/* ======================================================
// For Code Composer Studio V2.2 and later
// ---------------------------------------
// In addition to this memory linker command file, 
// add the header linker command file directly to the project. 
// The header linker command file is required to link the
// peripheral structures to the proper locations within 
// the memory map.
//
// The header linker files are found in <base>\DSP2833x_Headers\cmd
//   
// For BIOS applications add:      DSP2833x_Headers_BIOS.cmd
// For nonBIOS applications add:   DSP2833x_Headers_nonBIOS.cmd    
========================================================= */

/* ======================================================
// For Code Composer Studio prior to V2.2
// --------------------------------------
// 1) Use one of the following -l statements to include the 
// header linker command file in the project. The header linker
// file is required to link the peripheral structures to the proper 
// locations within the memory map                                    */

/* Uncomment this line to include file only for non-BIOS applications */
/* -l DSP2833x_Headers_nonBIOS.cmd */

/* Uncomment this line to include file only for BIOS applications */
/* -l DSP2833x_Headers_BIOS.cmd */

/* 2) In your project add the path to <base>\DSP2833x_headers\cmd to the
   library search path under project->build options, linker tab, 
   library search path (-i).
/*========================================================= */

/* Define the memory block start/length for the F28335  
   PAGE 0 will be used to organize program sections
   PAGE 1 will be used to organize data sections

   Notes: 
         Memory blocks on F28335 are uniform (ie same
         physical memory) in both PAGE 0 and PAGE 1.  
         That is the same memory region should not be
         defined for both PAGE 0 and PAGE 1.
         Doing so will result in corruption of program 
         and/or data. 
         
         L0/L1/L2 and L3 memory blocks are mirrored - that is
         they can be accessed in high memory or low memory.
         For simplicity only one instance is used in this
         linker file. 
         
         Contiguous SARAM memory blocks can be combined 
         if required to create a larger memory block. 
*/

#include "flashburn.h"
#ifndef FLASHBURN

MEMORY
{
PAGE 0 :
   /* BEGIN is used for the "boot to SARAM" bootloader mode      */
   /* BOOT_RSVD is used by the boot ROM for stack.               */
   /* This section is only reserved to keep the BOOT ROM from    */
   /* corrupting this area during the debug process              */

   RAML7K      : origin = 0x008000, length = 0x002500	 /*	program area */
   RAML0123    : origin = 0x00A500, length = 0x003F00	 /*	program area */
/* RAML0       : origin = 0x008000, length = 0x001000    
   RAML1       : origin = 0x009000, length = 0x001000    
   RAML2       : origin = 0x00A000, length = 0x001000    
   RAML3       : origin = 0x00B000, length = 0x001000
*/
//   RAM_EX_PROG : origin = 0x200000, length = 0x080000     /* XINTF zone 7A -  program area */
  
     
   BEGIN      : origin = 0x000000, length = 0x000002     /* Boot to M0 will go here                      */
   BOOT_RSVD  : origin = 0x000002, length = 0x00004E     /* Part of M0, BOOT rom will use this for stack */               
   RAMM0      : origin = 0x000050, length = 0x0003B0
   /*ZONE7A   : origin = 0x200000, length = 0x00FC00     XINTF zone 7 - program space */ 
   CSM_RSVD   : origin = 0x33FF80, length = 0x000076     /* Part of FLASHA.  Program with all 0x0000 when CSM is in use. */
   CSM_PWL    : origin = 0x33FFF8, length = 0x000008     /* Part of FLASHA.  CSM password locations in FLASHA            */
   ADC_CAL    : origin = 0x380080, length = 0x000009
   RESET      : origin = 0x3FFFC0, length = 0x000002
   IQTABLES   : origin = 0x3FE000, length = 0x000b50
   IQTABLES2  : origin = 0x3FEB50, length = 0x00008c
   FPUTABLES  : origin = 0x3FEBDC, length = 0x0006A0
   BOOTROM    : origin = 0x3FF27C, length = 0x000D44               

         
PAGE 1 : 
   
   RAML4567    : origin = 0x00E400, length = 0x001C00	  /* data area *///����0x002100
/* RAML4	   : origin = 0x00C000, length = 0x001000    
   RAML5       : origin = 0x00D000, length = 0x001000    
   RAML6       : origin = 0x00E000, length = 0x001000    
   RAML7       : origin = 0x00F000, length = 0x001000
*/
   RAM_EX_DATA : origin = 0x200000, length = 0x080000     /* XINTF zone 7B - data space */
/* RAM_WLG_g   : origin = 0x200000, length = 0x100000*/   /* XINTF zone 7 - data space */


   RAMM1      : origin = 0x000400, length = 0x000400      /*on-chip RAM block M1 */
   ZONE6B     : origin = 0x10FC00, length = 0x000400     /* XINTF zone 6 - data space */
}
 
 
SECTIONS
{
   /* Setup for "boot to SARAM" mode: 
      The codestart section (found in DSP28_CodeStartBranch.asm)
      re-directs execution to the start of user code.  */
   codestart        : > BEGIN,     PAGE = 0

/*	program distribute */
   ramfuncs         : > RAML7K,  PAGE = 0  
   .switch          : > RAML7K,  PAGE = 0
	Ramfuncs2:
	{ 
	/* 
		-l rts2800_fpu32.lib<atan.obj> 		(.text)
		-l rts2800_fpu32.lib<atan2.obj> 	(.text)
		-l rts2800_fpu32.lib<exp.obj> 		(.text)
		-l rts2800_fpu32.lib<ldexp.obj> 	(.text)
		-l rts2800_fpu32.lib<frexp.obj> 	(.text)
	*/
		-l rts2800_fpu32.lib<fs_div.obj>	(.text)
		-l rts2800_fpu32.lib<u_div.obj> 	(.text)
		-l rts2800_fpu32.lib<sin.obj> 		(.text)
		-l rts2800_fpu32.lib<cos.obj> 		(.text)
		-l rts2800_fpu32.lib<sqrt.obj> 		(.text)
		-l rts2800_fpu32.lib<lock.obj> 		(.text)
		-l C28x_FPU_Lib.lib<RFFT_f32.obj>	(.text)
	}
		 > RAML7K,  PAGE = 0  

   .text2     : {*(.text)}  > RAML0123,  PAGE = 0
     
   .cinit           : > RAML0123, PAGE = 0
   .pinit           : > RAML0123, PAGE = 0
   
/*	data distribute */   
   .stack           : > RAMM1,     PAGE = 1
   .esysmem         : > RAMM1,     PAGE = 1
   .ebss            : > RAML4567,  PAGE = 1
   .econst          : > RAML4567,  PAGE = 1      
   WLG_g  		    : > RAM_EX_DATA, PAGE = 1

   RFFT_IN_LM1	    : > RAML4567,     PAGE = 1, ALIGN(256)
   RFFT_IN_LM2		: > RAML4567,     PAGE = 1, ALIGN(256)
   RFFT_IN_CT1      : > RAML4567,     PAGE = 1, ALIGN(256)
   RFFT_IN_CT2      : > RAML4567,     PAGE = 1, ALIGN(256)
   RFFT			    : > RAML4567,     PAGE = 1

   IQmath           : > RAML0123,  PAGE = 0
   IQmathTables     : > IQTABLES,  PAGE = 0, TYPE = NOLOAD 
   IQmathTables2    : > IQTABLES2, PAGE = 0, TYPE = NOLOAD 
   FPUmathTables    : > FPUTABLES, PAGE = 0, TYPE = NOLOAD 
      
   DMARAML4         : > RAML4567,     PAGE = 1
   DMARAML5         : > RAML4567,     PAGE = 1
   DMARAML6         : > RAML4567,     PAGE = 1
   DMARAML7         : > RAML4567,     PAGE = 1
   
   ZONE6DATA        : > ZONE6B,    PAGE = 1  

   .reset           : > RESET,     PAGE = 0, TYPE = DSECT /* not used                    */
   csm_rsvd         : > CSM_RSVD   PAGE = 0, TYPE = DSECT /* not used for SARAM examples */
   csmpasswds       : > CSM_PWL    PAGE = 0, TYPE = DSECT /* not used for SARAM examples */
   
   /* Allocate ADC_cal function (pre-programmed by factory into TI reserved memory) */
   .adc_cal         : load = ADC_CAL,   PAGE = 0, TYPE = NOLOAD
  
}

#endif
/*
//===========================================================================
// End of file.
//===========================================================================
*/
