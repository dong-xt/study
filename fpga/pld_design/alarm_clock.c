#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "sys/alt_irq.h"

void init_timer();
void timer_interrupts();

unsigned int state = 0;
unsigned char idx = 0;
unsigned int timer_isr_context;
unsigned int hour = 0;
unsigned int minute = 0;
unsigned int second = 0;
unsigned int light_cnt = 0;
unsigned char light_flag = 0;
unsigned int hour_alarm = 0;
unsigned int minute_alarm = 0;
unsigned char alarm_flag = 0;

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

#define TIMER_IRQ_DISABLE alt_ic_irq_disable(TIMER_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_IRQ)
#define TIMER_IRQ_ENABLE alt_ic_irq_enable(TIMER_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_IRQ)

#define TIMER_START IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_BASE, 7)
#define TIMER_STOP IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_BASE, 0)

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

const char hex_decoder[11] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};


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

void clear()
{
	  TIMER_STOP;
	  state = 0;
	  idx = 0;
	  hour = 0;
	  minute = 0;
	  second = 0;
	  hour_alarm = 0;
	  minute_alarm = 0;
	  light_cnt = 0;
	  light_flag = 0;
	  alarm_flag = 0;
	  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_BASE, 0x02FA);
	  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_BASE, 0xF07F);
	  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_BASE, 0);
	  TIMER_START;
}

void init_timer()
{
	void* isr_context_ptr = (void*) &timer_isr_context;
	//1s-0x2FAF07F
	alt_ic_isr_register(TIMER_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_IRQ, timer_interrupts, isr_context_ptr, 0x0);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_BASE, 7);
	hour = 0;
	minute = 0;
	second = 0;
}

void show_time(unsigned int state, unsigned char index)
{
	unsigned int _hour_l = hour % 10;
	unsigned int _hour_h = hour / 10;
	unsigned int _minute_l = minute % 10;
	unsigned int _minute_h = minute / 10;
	unsigned int _second_l = second % 10;
	unsigned int _second_h = second / 10;

	unsigned int _hour_l_alarm = hour_alarm % 10;
	unsigned int _hour_h_alarm = hour_alarm / 10;
	unsigned int _minute_l_alarm = minute_alarm % 10;
	unsigned int _minute_h_alarm = minute_alarm / 10;

	if(light_cnt >= 30000)
	{
		light_cnt = 0;
		light_flag = (light_flag == 0) ? 1 : 0;
	}
	else
	{
		light_cnt ++;
	}

	if(state == 1)//setmode
	{
		if(index == 0)
		{
			if(light_flag == 0)
			{
				HEX_HOUR_H_OFF;
				HEX_HOUR_L_OFF;
			}
			else
			{
				HEX_HOUR_H_SHOW(hex_decoder[_hour_h]);
				HEX_HOUR_L_SHOW(hex_decoder[_hour_l]);
			}
			HEX_MINUTE_H_SHOW(hex_decoder[_minute_h]);
			HEX_MINUTE_L_SHOW(hex_decoder[_minute_l]);
			HEX_SECOND_H_SHOW(hex_decoder[_second_h]);
			HEX_SECOND_L_SHOW(hex_decoder[_second_l]);
		}
		else if(index == 1)
		{
			if(light_flag == 0)
			{
				HEX_MINUTE_H_OFF;
				HEX_MINUTE_L_OFF;
			}
			else
			{
				HEX_MINUTE_H_SHOW(hex_decoder[_minute_h]);
				HEX_MINUTE_L_SHOW(hex_decoder[_minute_l]);
			}
			HEX_HOUR_H_SHOW(hex_decoder[_hour_h]);
			HEX_HOUR_L_SHOW(hex_decoder[_hour_l]);
			HEX_SECOND_H_SHOW(hex_decoder[_second_h]);
			HEX_SECOND_L_SHOW(hex_decoder[_second_l]);
		}
		else if(index == 2)
		{
			if(light_flag == 0)
			{
				HEX_SECOND_H_OFF;
				HEX_SECOND_L_OFF;
			}
			else
			{
				HEX_SECOND_H_SHOW(hex_decoder[_second_h]);
				HEX_SECOND_L_SHOW(hex_decoder[_second_l]);
			}
			HEX_HOUR_H_SHOW(hex_decoder[_hour_h]);
			HEX_HOUR_L_SHOW(hex_decoder[_hour_l]);
			HEX_MINUTE_H_SHOW(hex_decoder[_minute_h]);
			HEX_MINUTE_L_SHOW(hex_decoder[_minute_l]);
		}
	}
	else if(state == 2)//alarmmode
	{
		if(index == 0)
		{
			if(light_flag == 0)
			{
				HEX_HOUR_H_OFF;
				HEX_HOUR_L_OFF;
			}
			else
			{
				HEX_HOUR_H_SHOW(hex_decoder[_hour_h_alarm]);
				HEX_HOUR_L_SHOW(hex_decoder[_hour_l_alarm]);
			}
			HEX_MINUTE_H_SHOW(hex_decoder[_minute_h_alarm]);
			HEX_MINUTE_L_SHOW(hex_decoder[_minute_l_alarm]);
			HEX_SECOND_H_OFF;
			HEX_SECOND_L_OFF;
		}
		else if(index == 1)
		{
			if(light_flag == 0)
			{
				HEX_MINUTE_H_OFF;
				HEX_MINUTE_L_OFF;
			}
			else
			{
				HEX_MINUTE_H_SHOW(hex_decoder[_minute_h_alarm]);
				HEX_MINUTE_L_SHOW(hex_decoder[_minute_l_alarm]);
			}
			HEX_HOUR_H_SHOW(hex_decoder[_hour_h_alarm]);
			HEX_HOUR_L_SHOW(hex_decoder[_hour_l_alarm]);
			HEX_SECOND_H_OFF;
			HEX_SECOND_L_OFF;
		}
	}
	else//runmode
	{
		if(alarm_flag && ALARM_SW_VALUE == SW_UP && hour == hour_alarm && minute == minute_alarm && light_flag)
		{
			ALARM_LED_ON;
		}
		else
		{
			ALARM_LED_OFF;
		}

		HEX_HOUR_H_SHOW(hex_decoder[_hour_h]);
		HEX_HOUR_L_SHOW(hex_decoder[_hour_l]);
		HEX_MINUTE_H_SHOW(hex_decoder[_minute_h]);
		HEX_MINUTE_L_SHOW(hex_decoder[_minute_l]);
		HEX_SECOND_H_SHOW(hex_decoder[_second_h]);
		HEX_SECOND_L_SHOW(hex_decoder[_second_l]);
	}

	if(alarm_flag)
	{
		ALARM_SET_LED_ON;
	}
	else
	{
		ALARM_SET_LED_OFF;
	}

	if(ALARM_SW_VALUE == SW_UP)
	{
		ALARM_SW_LED_ON;
	}
	else
	{
		ALARM_SW_LED_OFF;
	}

}

int main()
{
  printf("alarm clock based on nios ii by dongxiaoting\n");

  init_timer();
  state = 0;
  idx = 0;

  while(1)
  {
	  show_time(state, idx);

	  if(state == 0)
	  {
		  if(getPB3())//set mode
		  {
			  printf("time setting mode\n");
			  TIMER_STOP;
//			  TIMER_IRQ_DISABLE;
			  state = 1;
		  }
		  else if(getPB2())//alarm mode
		  {
			  printf("alarm setting mode\n");
			  TIMER_STOP;
//			  TIMER_IRQ_DISABLE;
			  state = 2;
		  }
		  else if(getPB0())//reset
		  {
			  clear();
		  }
	  }
	  else if(state == 1)
	  {
		  if(getPB2())//move
		  {
			  idx = (idx == 2) ? 0 : idx + 1;
		  }
		  else if(getPB1())//add
		  {
			  if(idx == 0)
			  {
				  hour = (hour == 23) ? 0 : hour + 1;
			  }
			  else if(idx == 1)
			  {
				  minute = (minute == 59) ? 0 : minute + 1;
			  }
			  else if(idx == 2)
			  {
				  second = (second == 59) ? 0 : second + 1;
			  }
		  }
		  else if(getPB0())//sub
		  {
			  if(idx == 0)
			  {
				  hour = (hour == 0) ? 23 : hour - 1;
			  }
			  else if(idx == 1)
			  {
				  minute = (minute == 0) ? 59 : minute - 1;
			  }
			  else if(idx == 2)
			  {
				  second = (second == 0) ? 59 : second - 1;
			  }
		  }
		  else if(getPB3())//ok
		  {
			  printf("time set succeed: %.2d:%.2d:%.2d\n", hour, minute, second);
			  idx = 0;
			  state = 0;
			  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_BASE, 0x02FA);
			  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_BASE, 0xF07F);
			  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_BASE, 0);
			  TIMER_START;
//			  TIMER_IRQ_ENABLE;
		  }
	  }
	  else if(state == 2)
	  {
		  if(getPB1())//move
		  {
			  idx = (idx == 1) ? 0 : idx + 1;
		  }
		  else if(getPB0())//add
		  {
			  if(idx == 0)
			  {
				  hour_alarm = (hour_alarm == 23) ? 0 : hour_alarm + 1;
			  }
			  else if(idx == 1)
			  {
				  minute_alarm = (minute_alarm == 59) ? 0 : minute_alarm + 1;
			  }
		  }
		  else if(getPB2())//ok
		  {
			  printf("alarm set succeed: %.2dh %.2dm\n", hour_alarm, minute_alarm);
			  alarm_flag = 1;
			  idx = 0;
			  state = 0;
			  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_BASE, 0x02FA);
			  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_BASE, 0xF07F);
			  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_BASE, 0);
			  TIMER_START;
//			  TIMER_IRQ_ENABLE;
		  }
		  else if(getPB3())//cancel
		  {
			  printf("alarm cancel\n");
			  hour_alarm = 0;
			  minute_alarm = 0;
			  alarm_flag = 0;
			  idx = 0;
			  state = 0;
			  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_BASE, 0x02FA);
			  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_BASE, 0xF07F);
			  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_BASE, 0);
			  TIMER_START;
//			  TIMER_IRQ_ENABLE;
		  }
	  }
  }

  return 0;
}


void timer_interrupts()
{
	IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_BASE, 0);

	if(second >= 59)
	{
		second = 0;
		if(minute >= 59)
		{
			minute = 0;
			if(hour >= 23)
			{
				hour = 0;
			}
			else
			{
				hour++;
			}
		}
		else
		{
			minute++;
		}
	}
	else
	{
		second++;
	}


	if(alarm_flag)
	{
		printf("TIME-- %.2d:%.2d:%.2d   ", hour, minute, second);
		printf("ALARM TIME-- %.2dh %.2dm\n", hour_alarm, minute_alarm);
	}
	else
	{
		printf("TIME-- %.2d:%.2d:%.2d\n", hour, minute, second);
	}
	if(ALARM_SW_VALUE == SW_UP)
	{
		printf("ALARM SWITCH IS ON\n");
	}
	if(alarm_flag && ALARM_SW_VALUE == SW_UP && hour == hour_alarm && minute == minute_alarm)
	{
		printf("THE ALARM CLOCK RANG...\n");
	}

}
