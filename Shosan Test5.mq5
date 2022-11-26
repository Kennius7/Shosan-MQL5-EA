//+------------------------------------------------------------------+
//|                                                 Shosan Test5.mq5 |
//|                                                     Shosan Boggs |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Shosan Boggs"
#property link      ""
#property version   "1.00"


//Include Functions
#include <Trade/Trade.mqh>
CTrade   *Trade;


//Setup Variables
input int                  inputMagicNumber  = 2000001;
input int                  inputTradeComment = __FILE__;
input ENUM_APPLIED_PRICE   inputAppliedPrice = PRICE_CLOSE;

//Global variables
string indicatorMetrics               = "";
int ticksReceivedCount                = 0;      //Takes in the number of ticks 
int ticksProcessedCount               = 0;      //Takes in the number of ticks processed after candle is formed 
static datetime timeLastTickProcessed = 0;      //Stores the last time a tick was processed after candle is formed 
bool tradeCount                       = false;  //Stores trade count boolean values
double tradeCountTicks                = 0;      //Stores trade count double values

//Macd variable and Holder
int MacdHandle = 0;
int MacdFast = 12;
int MacdSlow = 26;
int MacdSignal = 9;

//EMA Handles and variables
int HandleEMA;
int EMAPeriod = 100;

//ATR Handles and variables
int HandleATR;
int AtrPeriod = 14;

//Risk Metrics
input bool   riskCompounding   = true;      //Use compounded risk method? 
double       startingEquity    = 0.0;       //Starting Equity
double       currentEquityRisk = 0.0;       //Equity that will be risked per trade
double       currentEquity     = 0.0;       //Current Equity
input double MaxLossPercent    = 0.02;      //Percent risk per trade
input double ATRMultStopLoss   = 1.0;       //Multiplier value for determining ATR based stop loss
input double ATRMultTakeProfit = 2.0;       //Multiplier value for determining ATR based take profit









//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   //Declare Magic number for all trades
   Trade = new CTrade();
   Trade.SetExpertMagicNumber(inputMagicNumber);
   
   //Storing starting equity on OnInit
   startingEquity = AccountInfoDouble(ACCOUNT_EQUITY);

   //Setup handle for Macd on the OnInit
   MacdHandle = iMACD(Symbol(), Period(), MacdFast, MacdSlow, MacdSignal, inputAppliedPrice);
   Print("Handle for Macd /", Symbol(), " / ", EnumToString(Period()), " successfully created.");

   //Setup handle for EMA on the OnInit
   HandleEMA = iMA(Symbol(), Period(), EMAPeriod, 0, MODE_EMA, inputAppliedPrice);
   Print("Handle for EMA /", Symbol(), " / ", EnumToString(Period()), " successfully created.");  

   //Setup handle for ATR on the OnInit
   HandleATR = iATR(Symbol(), Period(), AtrPeriod);
   Print("Handle for ATR /", Symbol(), " / ", EnumToString(Period()), " successfully created.");




   return(INIT_SUCCEEDED);
  }
//===============================================================================================





//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //Remove indicator Handle from Metatrader Cache
   IndicatorRelease(MacdHandle);
   IndicatorRelease(HandleEMA);
   IndicatorRelease(HandleATR);


   Print("Handles released...");
   
  }
//===============================================================================================



//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   //This count the number of ticks per second that passed
   ticksReceivedCount++;

   //This checks for a new candle
   bool  isNewCandle = false;

   //This would mean a new candle has formed
   if(timeLastTickProcessed != iTime(Symbol(), Period(), 0)) 
     {
      isNewCandle = true;
      timeLastTickProcessed = iTime(Symbol(), Period(), 0);
     }

   //This would mean a new candle hasn't formed
   if(isNewCandle = true)
     {
      ticksProcessedCount++;
      indicatorMetrics = "";
      StringConcatenate(indicatorMetrics, Symbol(), " Last processed: ", timeLastTickProcessed);
      
      //Strategy Trigger MACD: which will return Long or Short bias based on trigger event
      string openSignalMacd = GetMacdOpenSignal(); 
      StringConcatenate(indicatorMetrics, indicatorMetrics, "\n\r", " | MACD Bias: ", openSignalMacd);

      //Strategy Trigger EMA: which will return Long or Short bias based on trigger event
      string openSignalEMA = GetEMAOpenSignal(); 
      StringConcatenate(indicatorMetrics, indicatorMetrics, "\n\r", " | EMA Bias: ", openSignalEMA);
      
      //Strategy Trigger ATR: which will return ATR value based on trigger event
      double currentATR = getATRValue(); 
      StringConcatenate(indicatorMetrics, indicatorMetrics, "\n\r", " | ATR: ", currentATR);


      //===============================================================================================
      //Enter new trades


      if(openSignalMacd == "Long" && openSignalEMA == "Long" && tradeCount == false)
        {
          processTradeOpen(ORDER_TYPE_BUY, currentATR);
          Comment("Buy Trade Alert");
          tradeCount = true;
        };
      if(openSignalMacd == "Short" && openSignalEMA == "Short" && tradeCount == false)
        {
          processTradeOpen(ORDER_TYPE_SELL, currentATR);
          Comment("Sell Trade Alert");
          tradeCount = true;
        };
      if(openSignalMacd == "Long" && openSignalEMA == "Long" && tradeCount == true)
        {
          Alert("Buy Trade Ongoing Already");
          tradeCount = true;
          tradeCountTicks++;
        };
      if(openSignalMacd == "Short" && openSignalEMA == "Short" && tradeCount == true)
        {
          Alert("Sell Trade Ongoing Already");
          tradeCount = true;
          tradeCountTicks++;
        };




      if (tradeCountTicks == 5000)
      {
        tradeCount      = false;
        tradeCountTicks = 0;
      }
      

     };
     
    //Comment section on the chart
    Comment("\n\rExpert: Shosan Test5, with a magic number of ", inputMagicNumber,
           " _____>>>>MT5 Server Time: ", TimeCurrent(),
           " _____>>>>Number of ticks: ", ticksReceivedCount,
           " _____>>>>Symbols Traded: ", Symbol(),
           " _____>>>>", indicatorMetrics);

  };
//===============================================================================================
//===============================================================================================
//===============================================================================================
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//===============================================================================================
//===============================================================================================
//===============================================================================================







//===============================================================================================
//Custom function to get Macd signals


   string GetMacdOpenSignal()
   {
      string      currentSymbol = Symbol();
      const int   startCandle = 0;
      const int   requiredCandles = 3;
      
      const int   indexMacd = 0;
      const int   indexSignal = 1;
      double      bufferMacd[];
      double      bufferSignal[];
      
      bool        fillMacd = CopyBuffer(MacdHandle, indexMacd, startCandle, requiredCandles, bufferMacd);
      bool        fillSignal = CopyBuffer(MacdHandle, indexSignal, startCandle, requiredCandles, bufferSignal);
      
      if(fillMacd == false || fillSignal == false)
         return "Buffer not full";


      double      currentMacd       = NormalizeDouble(bufferMacd[1], 10);
      double      currentSignal     = NormalizeDouble(bufferSignal[1], 10);
      double      priorMacd         = NormalizeDouble(bufferMacd[0], 10);
      double      priorSignal       = NormalizeDouble(bufferMacd[0], 10);
      
      
      if(priorMacd <= priorSignal && currentMacd > currentSignal)
         return "Long";
         
      else if(priorMacd >= priorSignal && currentMacd < currentSignal)
         return "Short";
      
      else return "No Trade";
         
   };




//===============================================================================================
//Custom function to get EMA signals


   string GetEMAOpenSignal()
   {
    //Set symbol string and indicator buffers
    string    CurrentSymbol    = Symbol();
    const int startCandle      = 0;       //This indicates the start candle
    const int requiredCandles  = 2;       //How many candles are required to be stored in Expert 
    
    //Indicator Variables and Buffers
    const int IndexEma         = 0;       //EMA Line
    double    BufferEma [];               //[current confirmed,not confirmed]    

    //Define EMA, from not confirmed candle 0, for 2 candles, and store results 
    bool      FillEma   = CopyBuffer(HandleEMA, IndexEma, startCandle, requiredCandles, BufferEma);
    if(FillEma == false) 
        return "Buffer Not Full Ema";     //If buffers are not completely filled, return to end onTick

    //Gets the current confirmed EMA value
    double CurrentEma   = NormalizeDouble(BufferEma[1], 10);
    double CurrentClose = NormalizeDouble(iClose(Symbol(), Period(), 0), 10);

    //Submit Ema Long and Short Trades
    if(CurrentClose > CurrentEma)
        return("Long");
    else if (CurrentClose < CurrentEma)
        return("Short");
    else
        return("No Trade");
   };





//===============================================================================================
//Custom function to get ATR value


double getATRValue (){
  //Set symbol string and indicator buffers
  string    currentSymbol    = Symbol();             //Current symbol
  const int requiredCandles  = 3;                    //How many candles are required to be stored in Expert
  const int startCandle      = 0;                    //This indicates the start candle

  //Indicator Variables and Buffers
  const int indexATR         = 0;                    //This is the ATR value
  double    bufferATR[];                             //This array captures 3 candles for the ATR

  //Populate buffers for ATR value and checks for errors
  bool      fillATR          = CopyBuffer(HandleATR, indexATR, startCandle, requiredCandles, bufferATR);
  if (fillATR==false) return(0);
  
  //Finding ATR value for candle 1 only
  double    currentATR       = NormalizeDouble(bufferATR[1], 5);

  //Return ATR value
  return(currentATR);
  }








//===============================================================================================
//Function that processes open trades for buy and sell


   bool processTradeOpen(ENUM_ORDER_TYPE orderType, double currentATR)
   {
    //Set up variables
    string currentSymbol = Symbol();
    double price = 0;
    double stopLossPrice = 0;
    double takeProfitPrice = 0;
    
    
    if(orderType == ORDER_TYPE_BUY)
      {
          price = NormalizeDouble(SymbolInfoDouble(currentSymbol, SYMBOL_ASK), Digits());
          stopLossPrice = NormalizeDouble(price - currentATR*ATRMultStopLoss, Digits());
          takeProfitPrice = NormalizeDouble(price + currentATR*ATRMultTakeProfit, Digits());
      }
    else if(orderType == ORDER_TYPE_SELL)
      {
          price = NormalizeDouble(SymbolInfoDouble(currentSymbol, SYMBOL_BID), Digits());
          stopLossPrice = NormalizeDouble(price + currentATR*ATRMultStopLoss, Digits());
          takeProfitPrice = NormalizeDouble(price - currentATR*ATRMultTakeProfit, Digits());
      }
      
    //Function for determining lot size
    double lotSize = GetLotSize(currentSymbol, price, stopLossPrice);

    //Trade.PositionClose(currentSymbol);
    Trade.PositionOpen(currentSymbol, orderType, lotSize, price, stopLossPrice, takeProfitPrice, inputTradeComment);
    return true;    
    Print("Trade processed for: ", currentSymbol, "\\ Order Type: ", orderType, "\\ Lot Size: ", lotSize);

   }





//===============================================================================================
//Function that get optimized lot sizes on each market


double GetLotSize(string currentSymbol, double entryPrice, double stopLoss)
{
  //Set symblo string and calculate point value
  double tickSize      = SymbolInfoDouble(currentSymbol, SYMBOL_TRADE_TICK_SIZE);
  double tickValue     = SymbolInfoDouble(currentSymbol, SYMBOL_TRADE_TICK_VALUE);

  if (SymbolInfoInteger(currentSymbol, SYMBOL_DIGITS) <= 3) tickValue = tickValue/100;
  
  double pointAmount   = SymbolInfoDouble(currentSymbol, SYMBOL_POINT);
  double ticksPerPoint = tickSize/pointAmount;
  double pointValue    = tickValue/ticksPerPoint;


  //Calculate risk based off entry and stop loss levels by pips
  double riskPoints    = MathAbs((entryPrice - stopLoss)/tickSize);

  //Set risk model - Fixed or Compounding
  if (riskCompounding  == true)
  {
    currentEquityRisk  = AccountInfoDouble(ACCOUNT_EQUITY);
    currentEquity      = AccountInfoDouble(ACCOUNT_EQUITY);
  }
  
  else
  {
    currentEquityRisk  = startingEquity;
    currentEquity      = AccountInfoDouble(ACCOUNT_EQUITY);
  }

  //Calculate Total risk amount in dollars
  double riskAmount    = currentEquityRisk * MaxLossPercent;

  //Calculate lot size
  double riskLots      = NormalizeDouble(riskAmount/(riskPoints * pointValue), 2);


  //Print values in journal to see if working properly
  PrintFormat("tickSize = %f, tickValue = %f, pointAmount = %f, ticksPerPoint = %f, PointValue = %f,",
              tickSize, tickValue, pointAmount, ticksPerPoint, pointValue);
  PrintFormat("entryPrice = %f, stopLoss = %f, riskPoints = %f, riskAmount = %f, riskLots = %f,",
              entryPrice, stopLoss, riskPoints, riskAmount, riskLots);


  return riskLots;
};










