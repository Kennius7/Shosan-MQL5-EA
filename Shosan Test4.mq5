//+------------------------------------------------------------------+
//|                                                 Shosan Test4.mq5 |
//|                                                     Shosan Boggs |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Shosan Boggs"
#property link      ""
#property version   "1.00"


input double threshold = 100.00;
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
   double ask = SYMBOL_ASK;
   double bid = SYMBOL_BID;
   double symbolSpread1 = ask - bid;
   double currentMomentum = iMomentum(NULL, 0, 5, PRICE_CLOSE)*10;
 
   
   if(currentMomentum>threshold)
     {
        Comment("Go long because the momentum value is ", currentMomentum, "and the current spread is ", DoubleToString(symbolSpread1));
     }
   else if(currentMomentum<threshold)
     {
        Comment("Go Short because the momentum value is ", currentMomentum, "and the current spread is ", DoubleToString(symbolSpread1));
     };
     
  }
//+------------------------------------------------------------------+
