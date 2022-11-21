//+------------------------------------------------------------------+
//|                                                 Shosan Test1.mq5 |
//|                                                     Shosan Boggs |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Shosan Boggs"
#property link      ""
#property version   "1.00"
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
//---
// Writing a code that tells me the current spread

      double current_spread;
      
  //    CalculateSpread(SYMBOL_ASK, SYMBOL_BID);
      current_spread = SYMBOL_ASK - SYMBOL_BID;
      
      string spread_message = "The new current spread is ";
      
      Comment(spread_message, current_spread);
   
  }
//+------------------------------------------------------------------+

//double CalculateSpread(double pAsk, double pBid)
//{
   // create a spread variable and give the bid ask spread as a variable
   //double current_spread = pAsk - pBid;
   //double point_spread;
   // divide by Point variable to give the spread in points
   //point_spread = current_spread/0.000000000001;
   //return point_spread;
   //return current_spread;
   
//}

