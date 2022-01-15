/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

//led on&off
#define ALARM_LED_ON IOWR_ALTERA_AVALON_PIO_DATA(ALARM_LED_BASE, 1)
#define ALARM_LED_OFF IOWR_ALTERA_AVALON_PIO_DATA(ALARM_LED_BASE, 0)
#define ALARM_SET_LED_ON IOWR_ALTERA_AVALON_PIO_DATA(ALARM_SET_LED_BASE, 1)
#define ALARM_SET_LED_OFF IOWR_ALTERA_AVALON_PIO_DATA(ALARM_SET_LED_BASE, 0)
#define ALARM_SW_LED_ON IOWR_ALTERA_AVALON_PIO_DATA(ALARM_SW_LED_BASE, 1)
#define ALARM_SW_LED_OFF IOWR_ALTERA_AVALON_PIO_DATA(ALARM_SW_LED_BASE, 0)
#define HEX_HOUR_H_ON IOWR_ALTERA_AVALON_PIO_DATA(HEX_HOUR_H_BASE, 0x00)
#define HEX_HOUR_H_OFF IOWR_ALTERA_AVALON_PIO_DATA(HEX_HOUR_H_BASE, 0x7f)
#define HEX_HOUR_L_ON IOWR_ALTERA_AVALON_PIO_DATA(HEX_HOUR_L_BASE, 0x00)
#define HEX_HOUR_L_OFF IOWR_ALTERA_AVALON_PIO_DATA(HEX_HOUR_L_BASE, 0x7f)
#define HEX_MINUTE_H_ON IOWR_ALTERA_AVALON_PIO_DATA(HEX_MINUTE_H_BASE, 0x00)
#define HEX_MINUTE_H_OFF IOWR_ALTERA_AVALON_PIO_DATA(HEX_MINUTE_H_BASE, 0x7f)
#define HEX_MINUTE_L_ON IOWR_ALTERA_AVALON_PIO_DATA(HEX_MINUTE_L_BASE, 0x00)
#define HEX_MINUTE_L_OFF IOWR_ALTERA_AVALON_PIO_DATA(HEX_MINUTE_L_BASE, 0x7f)
#define HEX_SECOND_H_ON IOWR_ALTERA_AVALON_PIO_DATA(HEX_SECOND_H_BASE, 0x00)
#define HEX_SECOND_H_OFF IOWR_ALTERA_AVALON_PIO_DATA(HEX_SECOND_H_BASE, 0x7f)
#define HEX_SECOND_L_ON IOWR_ALTERA_AVALON_PIO_DATA(HEX_SECOND_L_BASE, 0x00)
#define HEX_SECOND_L_OFF IOWR_ALTERA_AVALON_PIO_DATA(HEX_SECOND_L_BASE, 0x7f)
#define HEX_HOUR_H_SHOW(data) IOWR_ALTERA_AVALON_PIO_DATA(HEX_HOUR_H_BASE, data)
#define HEX_HOUR_L_SHOW(data) IOWR_ALTERA_AVALON_PIO_DATA(HEX_HOUR_L_BASE, data)
#define HEX_MINUTE_H_SHOW(data) IOWR_ALTERA_AVALON_PIO_DATA(HEX_MINUTE_H_BASE, data)
#define HEX_MINUTE_L_SHOW(data) IOWR_ALTERA_AVALON_PIO_DATA(HEX_MINUTE_L_BASE, data)
#define HEX_SECOND_H_SHOW(data) IOWR_ALTERA_AVALON_PIO_DATA(HEX_SECOND_H_BASE, data)
#define HEX_SECOND_L_SHOW(data) IOWR_ALTERA_AVALON_PIO_DATA(HEX_SECOND_L_BASE, data)

//PUSH-LOW NOPUSH-HIGH
#define PB0_VALUE IORD_ALTERA_AVALON_PIO_DATA(PB0_BASE)
#define PB1_VALUE IORD_ALTERA_AVALON_PIO_DATA(PB1_BASE)
#define PB2_VALUE IORD_ALTERA_AVALON_PIO_DATA(PB2_BASE)
#define PB3_VALUE IORD_ALTERA_AVALON_PIO_DATA(PB3_BASE)
#define PB_DOWN 0
#define PB_UP 1
//UP-LOGIC1 DOWN-LOGIC0
#define ALARM_SW_VALUE IORD_ALTERA_AVALON_PIO_DATA(ALARM_SW_BASE)
#define SW_UP 1
#define SW_DOWN 0

char hex_decoder[11] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};


void LIGHT_ON()
{
	ALARM_LED_ON;
	ALARM_SET_LED_ON;
	ALARM_SW_LED_ON;
//	HEX_HOUR_H_ON;
//	HEX_HOUR_L_ON;
//	HEX_MINUTE_H_ON;
//	HEX_MINUTE_L_ON;
//	HEX_SECOND_H_ON;
//	HEX_SECOND_L_ON;
}

void LIGHT_OFF()
{
	ALARM_LED_OFF;
	ALARM_SET_LED_OFF;
	ALARM_SW_LED_OFF;
//	HEX_HOUR_H_OFF;
//	HEX_HOUR_L_OFF;
//	HEX_MINUTE_H_OFF;
//	HEX_MINUTE_L_OFF;
//	HEX_SECOND_H_OFF;
//	HEX_SECOND_L_OFF;
}

void delay_ms(int ms)
{
	for(int i = 0; i < ms; i++)
	{
		for(int j = 0; j < 3333; j++);
	}
}

int getPB0()
{
	  if(PB0_VALUE == PB_DOWN)
	  {
		 delay_ms(10);
		 if(PB0_VALUE == PB_DOWN)
		 {
			 while(PB0_VALUE == PB_DOWN);
			 return 1;
		 }
	  }
	  return 0;
}

int getPB1()
{
	  if(PB1_VALUE == PB_DOWN)
	  {
		 delay_ms(10);
		 if(PB1_VALUE == PB_DOWN)
		 {
			 while(PB1_VALUE == PB_DOWN);
			 return 1;
		 }
	  }
	  return 0;
}

int getPB2()
{
	  if(PB2_VALUE == PB_DOWN)
	  {
		 delay_ms(10);
		 if(PB2_VALUE == PB_DOWN)
		 {
			 while(PB2_VALUE == PB_DOWN);
			 return 1;
		 }
	  }
	  return 0;
}

int getPB3()
{
	  if(PB3_VALUE == PB_DOWN)
	  {
		 delay_ms(10);
		 if(PB3_VALUE == PB_DOWN)
		 {
			 while(PB3_VALUE == PB_DOWN);
			 return 1;
		 }
	  }
	  return 0;
}

int a = 1;
a = a << 1;
if(a == x)
{
	a = 1;
}

int main()
{
  printf("Hello from Nios II!\n");

  int state = 0;
  int num = 0;
  while(1)
  {
//	  LIGHT_ON();
//	  delay_ms(1000);
//	  LIGHT_OFF();
//	  delay_ms(1000);

	  if(ALARM_SW_VALUE == SW_UP)
	  {
		  if(getPB0())
		  {
			state = (state == 0) ? 1 : 0;
			num = (num == 9) ? 0 : num + 1;
		  }
		  if(getPB1())
		  {
			state = (state == 0) ? 1 : 0;
			num = (num == 9) ? 0 : num + 1;
		  }
		  if(getPB2())
		  {
			state = (state == 0) ? 1 : 0;
			num = (num == 9) ? 0 : num + 1;
		  }
		  if(getPB3())
		  {
			state = (state == 0) ? 1 : 0;
			num = (num == 9) ? 0 : num + 1;
		  }
		  HEX_HOUR_H_SHOW(hex_decoder[num]);
		  HEX_HOUR_L_SHOW(hex_decoder[num]);
		  HEX_MINUTE_H_SHOW(hex_decoder[num]);
		  HEX_MINUTE_L_SHOW(hex_decoder[num]);
		  HEX_SECOND_H_SHOW(hex_decoder[num]);
		  HEX_SECOND_L_SHOW(hex_decoder[num]);
	  }
	  else
	  {
		  state = 0;
		  num = 0;
		  HEX_HOUR_H_OFF;
		  HEX_HOUR_L_OFF;
		  HEX_MINUTE_H_OFF;
		  HEX_MINUTE_L_OFF;
		  HEX_SECOND_H_OFF;
		  HEX_SECOND_L_OFF;
	  }

	  if(state)
	  {
		  LIGHT_ON();
	  }
	  else
	  {
		  LIGHT_OFF();
	  }

  }

  return 0;
}
