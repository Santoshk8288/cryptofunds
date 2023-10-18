const request = require("request")
const mysql = require('mysql2');

const config = require('./config.json')
const environment = process.env.NODE_ENV || 'development';
const defaultConfig = config[environment];

const URL = 'https://api.hitbtc.com/api/2/public/ticker/'

const ccxt = require ('ccxt');
let hitbtc = new ccxt.hitbtc (); 
(async ()=>{
	data = await hitbtc.fetchTicker('BTC/TUSD')
	console.log(data)
})()

// let kraken = new ccxt.kraken ();

/*(async () => {
    let kraken = new ccxt.kraken ({ verbose: true }) // log HTTP requests
    await kraken.load_markets () // request markets
    console.log (kraken.markets['BTC/TUSD'])    // output single market details
    await kraken.load_markets () // return a locally cached version, no reload
    let reloadedMarkets = await kraken.load_markets (true) // force HTTP reload = true
}) ()*/

/*(async () => {
  console.log (await exchange.loadMarkets ())

  let btcusd1 = exchange.markets['BTC/TUSD']     // get market structure by symbol
  let btcusd2 = exchange.market ('BTC/TUSD')     // same result in a slightly different way

  let btcusdId = exchange.marketId ('BTC/TUSD')  // get market id by symbol

  let symbols = exchange.symbols                // get an array of symbols
  let symbols2 = Object.keys (exchange.markets) // same as previous line

  console.log (exchange.id, symbols)            // print all symbols

  let currencies = exchange.currencies          // a list of currencies

  let bitfinex = new ccxt.bitfinex ()
  await bitfinex.loadMarkets ()

  bitfinex.markets['BTC/TUSD']                   // symbol → market (get market by symbol)
  bitfinex.markets_by_id['XRPBTC']              // id → market (get market by id)

  bitfinex.markets['BTC/TUSD']['id']             // symbol → id (get id by symbol)
  bitfinex.markets_by_id['XRPBTC']['symbol']    // id → symbol (get symbol by id)
}) ();*/


/*(async () => {
	let pairs = await kraken.publicGetSymbolsDetails ()
	let marketIds = Object.keys (pairs['result'])
	let marketId = marketIds[0]
	let ticker = await kraken.publicGetTicker ({ pair: marketId })
	console.log (kraken.id, marketId, ticker)
}) ()*/

/*console.log(bitfinex.id, await bitfinex.fetchTicker ('BTC/USD'))
	const exchangeClass = ccxt['trueusd'];
	const exchange = new exchangeClass({
	apiKey: 'e8409c4221ee7a6302db2ad3a8ae80917e4c01c4',
	secret: 'f8760c95fad60f8907d34699c78cbe1ae93cd7d2',
	timeout: 30000,
	enableRateLimit: true
});*/

async function main(){
	if (!global.db) {
		global.db = await connectToDb();
	}

	const data = await getData()
	console.log(data)
	const updatedTable = await updateTable(data.last)
	console.log(updatedTable)
}


function getData() {
	return new Promise((resolve, reject) => {
		request.get(`${URL}BTCTUSD`, (error, response, body) => {
		  if(error){
		  	reject(error)
		  }
		  let json = JSON.parse(body);
		  resolve(json)
		});
	});
};

function updateTable(data){
	return new Promise((resolve, reject) => {
		const sql = `INSERT INTO \`coin_amount\`(\`component_id\`, \`amount\`) VALUES (?, ?)`
		global.db.execute(sql, [2,data], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function connectToDb() {
	return new Promise((resolve, reject) => {
		// create the connection to database
		const connection = mysql.createConnection({
		  host: defaultConfig["dbHost"],
		  user: defaultConfig['dbUser'],
		  password: defaultConfig['dbPassword'],
		  database: defaultConfig['dbName']
		});
		resolve(connection);
	});
};

// main()