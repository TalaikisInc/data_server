/*
 * Developed by Quantrade Ltd.
 * QUANTRADE.CO.UK
 * Copyright 2016 Quantrade Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 */

#property version "1.0"
#property indicator_chart_window

int             s;
int             i;
string          open, high, low, close, volume, date_time;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
{
//---- indicators

//----
    return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//----

//----
    return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
    int bars = IndicatorCounted() - 1;

    if (Refresh() == true)
    {
        DoExport();
    }

//----
    return(0);
}
//+------------------------------------------------------------------+

//update base only once a bar
bool Refresh()
{
    static datetime PrevBar;

    if (PrevBar != iTime(NULL, Period(), 0))
    {
        PrevBar = iTime(NULL, Period(), 0);
        return(true);
    }
    else
    {
        return(false);
    }
}

string make_symbol(string text)
{
    int final_;
    final_  = StringReplace(text, "_", "");
    final_ += StringReplace(text, "#", "");
    final_ += StringReplace(text, ".", "");
    final_ += StringReplace(text, "&", "");
    final_ += StringReplace(text, "-", "");

    return(text);
}

void DoExport()
{
    int    filehandle;

    string symbol  = make_symbol(Symbol());
    string company = AccountCompany();
    int    period;

    int day = 1440;

    if (StringLen(symbol) > 0 && StringLen(company))
    {
        filehandle = FileOpen("DATA_MODEL_" + company + "_" + symbol + "_1440.csv", FILE_WRITE | FILE_CSV);
    }
    else
    {
        filehandle = -999;
    }

    for (int i = 0; i <= iBars(Symbol(), day) - 1; i++)
    {
        date_time = TimeToStr(iTime(Symbol(), day, i), TIME_DATE | TIME_MINUTES | TIME_SECONDS);
        open      = DoubleToStr(iOpen(Symbol(), day, i), 5);
        high      = DoubleToStr(iHigh(Symbol(), day, i), 5);
        low       = DoubleToStr(iLow(Symbol(), day, i), 5);
        close     = DoubleToStr(iClose(Symbol(), day, i), 5);
        volume    = IntegerToString(iVolume(Symbol(), day, i));
        string buffer;

        if (i == 0)
        {
            if (filehandle != -999)
            {
                buffer = "DATE_TIME,OPEN,HIGH,LOW,CLOSE, VOLUME";
                FileWrite(filehandle, buffer);

                buffer = date_time + "," + open + "," + high + "," + low + "," + close + "," + volume;
                FileWrite(filehandle, buffer);
            }
        }
        else
        {
            if (filehandle != -999)
            {
                if (close != 0 && open != 0 && high != 0 && low != 0)
                {
                    buffer = date_time + "," + open + "," + high + "," + low + "," + close + "," + volume;

                    FileWrite(filehandle, buffer);
                }
            }
        }
    }
    if (filehandle != INVALID_HANDLE)
    {
        FileClose(filehandle);
        Print("Created file for " + symbol);
    }
    else
    {
        Print("Error in FileOpen. Error code=", GetLastError());
    }
}
