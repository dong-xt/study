#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "sys/alt_irq.h"

void init_timer();
void timer_interrupts();

unsigned int state;
unsigned int timer_isr_context;
unsigned int hour;
unsigned int minute;
unsigned int second;
unsigned int light_cnt_ms = 0;
unsigned int light_cnt = 0;
unsigned char light_flag = 0;


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

void show_time(unsigned int _hour, unsigned int _minute, unsigned int _second, unsigned int state, unsigned char index)
{
	unsigned int _hour_l = _hour % 10;
	unsigned int _hour_h = _hour / 10;
	unsigned int _minute_l = _minute % 10;
	unsigned int _minute_h = _minute / 10;
	unsigned int _second_l = _second % 10;
	unsigned int _second_h = _second / 10;

	if(state == 1 || state == 2)
	{
		if(light_cnt >= 3000)
		{
			light_cnt = 0;
			if(light_cnt_ms >= 10)
			{
				light_cnt_ms = 0;
				light_flag = (light_flag == 0) ? 1 : 0;
			}
			else
			{
				light_cnt_ms ++;
			}
		}
		else
		{
			light_cnt ++;
		}

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
	else
	{
		light_cnt = 0;
		light_cnt_ms = 0;
		HEX_HOUR_H_SHOW(hex_decoder[_hour_h]);
		HEX_HOUR_L_SHOW(hex_decoder[_hour_l]);
		HEX_MINUTE_H_SHOW(hex_decoder[_minute_h]);
		HEX_MINUTE_L_SHOW(hex_decoder[_minute_l]);
		HEX_SECOND_H_SHOW(hex_decoder[_second_h]);
		HEX_SECOND_L_SHOW(hex_decoder[_second_l]);
	}
}

int main()
{
  printf("Hello from Nios II!\n");

  init_timer();
  state = 0;
  unsigned char index = 0;

  while(1)
  {
	  show_time(hour, minute, second, state, index);

	  if(state == 0)
	  {
		  if(getPB3())
		  {
			  TIMER_IRQ_DISABLE;
			  state = 1;//set mode
		  }
		  else if(getPB2())
		  {
			  TIMER_IRQ_DISABLE;
			  state = 2;//alarm mode
		  }
	  }
	  else if(state == 1)
	  {
		  if(getPB2())//move
		  {
			  index = (index == 2) ? 0 : index + 1;
		  }
		  else if(getPB1())//add
		  {
			  if(index == 0)
			  {
				  hour = (hour == 23) ? 0 : hour + 1;
			  }
			  else if(index == 1)
			  {
				  minute = (minute == 59) ? 0 : minute + 1;
			  }
			  else if(index == 2)
			  {
				  second = (second == 59) ? 0 : second + 1;
			  }
		  }
		  else if(getPB0())//sub
		  {
			  if(index == 0)
			  {
				  hour = (hour == 0) ? 23 : hour - 1;
			  }
			  else if(index == 1)
			  {
				  minute = (minute == 0) ? 59 : minute - 1;
			  }
			  else if(index == 2)
			  {
				  second = (second == 0) ? 59 : second + 1;
			  }
		  }
		  else if(getPB3())//ok
		  {
			  index = 0;
			  state = 0;
			  TIMER_IRQ_ENABLE;
			  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_BASE, 0x02FA);
			  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_BASE, 0xF080);
		  }
	  }
	  else if(state == 2)
	  {

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
}


//	  LIGHT_ON();
//	  delay_ms(1000);
//	  LIGHT_OFF();
//	  delay_ms(1000);

//	  if(ALARM_SW_VALUE == SW_UP)
//	  {
//		  if(getPB0())
//		  {
//			state = (state == 0) ? 1 : 0;
//			num = (num == 9) ? 0 : num + 1;
//		  }
//		  if(getPB1())
//		  {
//			state = (state == 0) ? 1 : 0;
//			num = (num == 9) ? 0 : num + 1;
//		  }
//		  if(getPB2())
//		  {
//			state = (state == 0) ? 1 : 0;
//			num = (num == 9) ? 0 : num + 1;
//		  }
//		  if(getPB3())
//		  {
//			state = (state == 0) ? 1 : 0;
//			num = (num == 9) ? 0 : num + 1;
//		  }
//		  HEX_HOUR_H_SHOW(hex_decoder[num]);
//		  HEX_HOUR_L_SHOW(hex_decoder[num]);
//		  HEX_MINUTE_H_SHOW(hex_decoder[num]);
//		  HEX_MINUTE_L_SHOW(hex_decoder[num]);
//		  HEX_SECOND_H_SHOW(hex_decoder[num]);
//		  HEX_SECOND_L_SHOW(hex_decoder[num]);
//	  }
//	  else
//	  {
//		  state = 0;
//		  num = 0;
//		  HEX_HOUR_H_OFF;
//		  HEX_HOUR_L_OFF;
//		  HEX_MINUTE_H_OFF;
//		  HEX_MINUTE_L_OFF;
//		  HEX_SECOND_H_OFF;
//		  HEX_SECOND_L_OFF;
//	  }
//
//	  if(state)
//	  {
//		  LIGHT_ON();
//	  }
//	  else
//	  {
//		  LIGHT_OFF();
//	  }
