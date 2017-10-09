# data_server

data_server is WebDAV service for Metatrader 4.

## Who uses it

* [Quantrade](https://github.com/xenu256/Quantrade)
* [QuantBoard](https://github.com/xenu256/QuantBoard)

## How to use

1. Put z4_DATA_MODEL_to_CSV_1.0.mq4 and z4_Symbol_Properties_to_MySQL_1.0.mq4 into some chart. Symbol properties require database table (see below).
2. Configure and start WebDAV server.
3. Voila, your MT4 data is available through internet.

## Symbols table (for storing current sym properties)

```text
CREATE TABLE IF NOT EXISTS symbols (id bigint(20) NOT NULL AUTO_INCREMENT,
symbol varchar(20) NOT NULL,
description varchar(120) DEFAULT NULL,
spread decimal(10,5) DEFAULT NULL,
tick_value decimal(10,5) DEFAULT NULL,
tick_size decimal(8,5) DEFAULT NULL,
margin_initial decimal(10,2) DEFAULT NULL,
digits decimal(8,5) DEFAULT NULL,
profit_calc int(2) DEFAULT NULL,
profit_currency varchar(10) DEFAULT NULL,
price_at_calc_time decimal(20,5) DEFAULT NULL,
commission decimal(15,5) DEFAULT NULL,
broker varchar(40) NOT NULL,
points decimal(8,5) DEFAULT NULL,
PRIMARY KEY (id), UNIQUE KEY symbol (symbol) )
ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

ALTER TABLE collector_symbols ADD UNIQUE (symbol, broker);
```

