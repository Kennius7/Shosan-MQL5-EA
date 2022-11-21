//+------------------------------------------------------------------+
//|                                                 Shosan Test3.mq5 |
//|                                                     Shosan Boggs |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Shosan Boggs"
#property link      ""
#property version   "1.00"

input double maxSpread = 2;
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
   /*double currentSpread = SYMBOL_ASK - SYMBOL_BID;
   Comment("The current spread is ", DoubleToString(currentSpread, 3));
   
   if(currentSpread > maxSpread)
     {
      Comment("The spread is higher by ", DoubleToString(currentSpread - maxSpread, 3), "points.");
     }
    else
      {
       Comment("The spread is lower by ", DoubleToString(maxSpread - currentSpread, 3), "points.");
      }*/
  }
//+------------------------------------------------------------------+

void OnStart()
       {
        double currentSpread = SYMBOL_ASK - SYMBOL_BID;
         Alert("The current spread is ", DoubleToString(currentSpread, 3));
   
         if(currentSpread > maxSpread)
           {
            Alert("The spread is higher by ", DoubleToString(currentSpread - maxSpread, 3), "points.");
           }
         else
            {
             Alert("The spread is lower by ", DoubleToString(maxSpread - currentSpread, 3), "points.");
            };
            
       }
   



