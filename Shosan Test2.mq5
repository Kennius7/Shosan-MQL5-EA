//+------------------------------------------------------------------+
//|                                                 Shosan Test2.mq5 |
//|                                                     Shosan Boggs |
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   string svar="This is a character string";
   string svar2=StringSubstr(svar,0,4);
   Comment("This is the Copyright symbol = \t\x00A9");
   //FileWrite(handle,"This string contains a new line symbols \n");
   string MT5path="C:\\Program Files\\MetaTrader";
   
   
   
   
   //structs are like objects in Javascript
   
   struct trade_settings
   {
   double take; // values of the profit fixing price
   double stop; // value of the protective stop price
   uchar slippage; // value of the acceptable slippage
   };
   double input_TP;
   //--- create up and initialize a variable of the trade_settings type
   trade_settings my_set={0.0,0.0,5};
   if (input_TP>0) my_set.take=input_TP;
   input_TP=0.15;
   Comment(my_set.take);

   
  }
//+------------------------------------------------------------------+
