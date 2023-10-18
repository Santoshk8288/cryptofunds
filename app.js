const ccxt = require ('ccxt');
const util = require('util');
const mysql = require('mysql2');
const cron = require('node-cron');
const winston = require('winston');
require('winston-daily-rotate-file');
const CoinGecko = require('coingecko-api');

// require config env variables for application to run
const config = require('./config.json')
const environment = process.env.NODE_ENV || 'development';
const defaultConfig = config[environment];

// winston log rotator settings
const appLogRotator = new (winston.transports.DailyRotateFile)({
	filename: 'logs/app-%DATE%.log',
	datePattern: 'YYYY-MM-DD',
	zippedArchive: true,
	maxSize: '20m'
});

const exceptionsLogRotator = new (winston.transports.DailyRotateFile)({
	filename: 'logs/exceptions-%DATE%.log',
	datePattern: 'YYYY-MM-DD',
	zippedArchive: true,
	maxSize: '20m'
});

// create logger
const logger  = winston.createLogger({
	level: defaultConfig['logLevel'],
	format: winston.format.combine(
		winston.format.timestamp(),
		winston.format.json()
	),
	transports: [
		//
		// - Write to all logs with level `info` and below to `combined.log` 
		// - Write all logs error (and below) to `error.log`.
		//
		new winston.transports.File({ filename: './logs/error.log', level: 'error', format: winston.format.errors() }),
		appLogRotator
	],
	exceptionHandlers: [
		exceptionsLogRotator
	]
});


// If we're not in production then log to the `console` with the format:
// `${info.level}: ${info.message} JSON.stringify({ ...rest }) `

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
	level: 'info',
  	format: winston.format.combine(
  		winston.format.colorize(),
  		winston.format.simple()
  	),
  	handleExceptions: true
  }));
}

let db;

cron.schedule('*/5 * * * *', () => {
	console.log("running a task every 10th min.");
	updateNavUnits()
		.then(result => {
			logger.info("Fund nav units have been updated.");
		})
		.then(main)
		.then(results => console.log(results))
		.catch(error => {
			logger.error(error);
		});
});

// Update coins amount in exchange wallet
cron.schedule('55 2 * * *', () => {
	console.log("Running updateCoinAmtController...");

	updateCoinAmtController()
		.then(result => logger.info("Coins amount updated in database table."))
		.catch(err => logger.error(err));
});

// Test controller codes start

// updateNavUnits()
// 	.then(rows => {
// 		console.log(rows);
// 	})
// 	.catch(error => {
// 		console.error(error);
// // 	});
// updateNavUnits()
// 	.then(rows => console.log(rows))
// 	.then(main)
// 	.then(results => logger.info(`nav: ${results}`))
// 	.catch(error => {
// 		logger.error(error);
// 	});

// updateCoinAmtController()
// 	.then(result => logger.info("Coins amount updated in database table."))
// 	.catch(err => logger.error(err));

// (async () => {
//     global.db = await connectToDb();
//     const coinAmtObj = await getCoinAmtUpdateID(1);
//     logger.info(util.inspect(coinID, { showHidden: false, depth: null }));

//     // const biboxClass = ccxt['bibox'];
//     // const biboxExch = new exchangeClass({
//     // 	apiKey: 'e8409c4221ee7a6302db2ad3a8ae80917e4c01c4',
//     // 	secret: 'f8760c95fad60f8907d34699c78cbe1ae93cd7d2',
//     // 	timeout: 30000,
//     // 	enableRateLimit: true
//     // });
//     // // let markets = await exchange.load_markets();
//     // let bixBalance = await biboxExch.fetchBalance();
//     // logger.info(`bix balance: ${bixBalance['BIX']['total']}`);

//     // const kucoinExch = new ccxt['kucoin']({
//     // 	apiKey: '5c1a01939b5f45293b888fc8',
//     // 	secret: '59fb6837-2da5-4179-a0f9-47f4daee9bbd',
//     // 	timeout: 30000,
//     // 	enableRateLimit: true
//     // });

//     // let kcsBalance = await kucoinExch.fetchBalance();
//     // logger.info(`kcs balance: ${kcsBalance['KCS']['total']}`);

//     // logger.info(util.inspect(new ccxt.kucoin()), {showHidden: false, depth: null});
//     // let orderbook = await exchange.fetchOrderBook ("QASH/BTC");
//     // let bid = await orderbook.bids.length ? orderbook.bids[0][0] : undefined;
//     // let ask = await orderbook.asks.length ? orderbook.asks[0][0] : undefined;
//     // let spread = await (bid && ask) ? ask - bid : undefined;
//     // console.log (exchange.id, 'market price', { bid, ask, spread });
// }) ();

// Functions Starts
async function updateNavUnits() {
	try {
		if (!global.db) {
			global.db = await connectToDb();
		}

		const noOfFunds = await getFunds();
		for (let row in noOfFunds) {
			const fundID = noOfFunds[row]['id'];
			const subscription = await getFundUnitLedger(fundID, 'SUBSCRIBED');
			
			let subscribedUnits = 0;
			for (let x in subscription) {
				subscribedUnits += parseFloat(subscription[x]['amount']);
			}

			const redemption = await getFundUnitLedger(fundID, 'REDEEMED');

			let redeemedUnits = 0;
			for (let y in redemption) {
				redeemedUnits += parseFloat(redemption[y]['amount']);
			}

			const totalUnits = subscribedUnits - redeemedUnits;
			const result = await updateFundUnits(fundID, totalUnits.toFixedDown(2));
			return result;
		}
			
	} catch(err) {
		console.error(err);
	}
}

async function updateCoinAmtController() {
	try {
		
		if (!global.db) {
			global.db = await connectToDb();
		}

		const coinAmtObj = await getCoinAmtUpdateID(1);
		const bixID = await getCoinAmountID("BIX", coinAmtObj);
		const kcsID = await getCoinAmountID("KCS", coinAmtObj);

		const biboxClass = ccxt['bibox'];
	    const biboxExch = new biboxClass({
	    	apiKey: 'e8409c4221ee7a6302db2ad3a8ae80917e4c01c4',
	    	secret: 'f8760c95fad60f8907d34699c78cbe1ae93cd7d2',
	    	timeout: 30000,
	    	enableRateLimit: true
	    });


		// let markets = await exchange.load_markets();
		const bixBal = await biboxExch.fetchBalance();
		logger.info(`bix balance: ${bixBal['BIX']['total']}`);

		const results = await updateCoinBalance(bixID, bixBal['BIX']['total']);

		// const kcsClass = ccxt['kucoin'];
		// const kcsExch = new kcsClass ({
		// 	apiKey: '5c8df5e2134ab71c9d91ff5b',
		// 	secret: '16aa6edc-f3c5-4384-94ee-736cb7c13256',
		// 	password: '7w0kvKNJKRXao^i&I$Mn',
		// 	timeout: 30000,
		// 	enableRateLimit: true
		// });

		// const kcsBal = await kcsExch.fetchBalance();
		// logger.info(`kcs balance: ${kcsBal['KCS']['total']}`);
		// const results = await updateCoinBalance(kcsID, kcsBal['KCS']['total']);
		return results;

	} catch(err) {
		logger.error("updateCoinAmtController has errors.");
	}
}

async function main() {
	try {
		
		if (!global.db) {
			global.db = await connectToDb();
		}
		
		const rows = await getRateRows();
		// Update db rows with current rates
		for (let i = 0; i < rows.length; i++) {
			if(rows[i]['name_id']==='bitmax' || rows[i]['name_id']==='fcoin'){
				rows[i]['symbol'] = rows[i]['symbol']
			}
			else rows[i]['symbol'] = `${rows[i]['symbol'].toUpperCase()}/${rows[i]['quote'].toUpperCase()}`;
			rows[i]['currentRates'] = await loadMarkets(rows[i]['name_id'], rows[i]['symbol']);
			if (rows[i]['currentRates']) {
				const result = await updateRates(rows[i]['id'], rows[i]['currentRates']);
				// logger.info(`updateStatus: ${result}`);
			}
		}

		const amtRows = await getAmountWithLiveRatesForFund(1);
		const sumBTC = await totalBTC(amtRows);
		// logger.info(`totalBTC: ${sumBTC}`);
		
		// Get number of units 
		const fundUnits = await getFundUnits(1);
		// logger.info(`no of units: ${fundUnits[0]['units']}`);
		const nav = sumBTC / fundUnits[0]['units'];
		const insertNavStatus = await insertNavToDB(1, nav.toFixedDown(8));
		return nav.toFixedDown(8);

	} catch(error) {
		logger.error("main func block have errors.");	
	}
}


Number.prototype.toFixedDown = function(digits) {
	var re = new RegExp("(\\d+\\.\\d{" + digits + "})(\\d)"),
		m = this.toString().match(re);
	return m ? parseFloat(m[1]) : this.valueOf();
};

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

function getRateRows() {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `
			SELECT  \`coin_rates\`.\`id\`, \`coins\`.\`symbol\` ,\`coin_rates\`.\`quote\`, \`exchanges\`.\`name_id\`,\`coin_rates\`.\`updated\` 
			FROM \`coin_rates\` 
			INNER JOIN \`coins\` ON \`coin_rates\`.\`coin_id\` = \`coins\`.\`id\` 
			INNER JOIN \`exchanges\` ON \`coin_rates\`.\`exchange_id\` = \`exchanges\`.\`id\`
		`;
		global.db.query(sql, function(err, results, fields) {
			if (results) {
				// logger.info(results);
				resolve(results);
			} else {
				reject("No result found.");
			}
		});
	});
};

async function loadMarkets(exchangeID, symbol) {
	try {
		if (exchangeID === "bibox") {
			const exchID = exchangeID;
			const exchangeClass = ccxt[exchID];
			const exchange = new exchangeClass({
				apiKey: 'e8409c4221ee7a6302db2ad3a8ae80917e4c01c4',
				secret: 'f8760c95fad60f8907d34699c78cbe1ae93cd7d2',
				timeout: 30000,
				enableRateLimit: true
			});
			const markets = await exchange.load_markets();
			const price = await exchange.fetchTicker(symbol);
			const ask = await price.last;
			// logger.info(`${exchange.id}, market price ${ask}`);
			return ask;

		} 
		if(exchangeID === "bitmax" || exchangeID === "fcoin"){
			const exchange = new CoinGecko();
			const markets = await exchange.coins.markets();
			const price = await exchange.coins.fetchTickers(symbol);
			// const test = price['data']['tickers']
			await price.data.tickers.forEach((obj)=>{
				if(obj.target == 'BTC'){
					ask = obj.last
				}
		  })

			return ask
		}
		else {
			const exchange = new ccxt[exchangeID]
			const markets = await exchange.load_markets();
			const price = await exchange.fetchTicker(symbol);
			const ask = await price.last;
			// logger.info(`${exchange.id}, market price ${ask}`);
			return ask;
		}
	} catch(err) {
		logger.error("loadMarkets func block have errors.");
	}
	
}

function getCoinAmtUpdateID(fundID) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `
			SELECT \`coin_amount\`.\`id\`, \`coins\`.\`symbol\`, \`coin_amount\`.\`amount\`, \`coin_amount\`.\`updated\` FROM \`coin_amount\` 
			INNER JOIN \`fund_components\` ON \`coin_amount\`.\`component_id\` = \`fund_components\`.\`id\` 
			INNER JOIN \`coins\` ON \`fund_components\`.\`coin_id\` = \`coins\`.\`id\` 
			WHERE \`fund_components\`.\`fund_id\` = ?
		`;
		// Prepare statement
		global.db.execute(sql, [fundID], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function updateCoinBalance(coinAmountID, amount) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `
			UPDATE \`coin_amount\` 
			SET amount = ? 
			WHERE id = ?;
		`;
		// Prepare statement
		global.db.execute(sql, [amount, coinAmountID], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function updateRates(rowID, rate) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `
			UPDATE \`coin_rates\` 
			SET rate = ? 
			WHERE id = ?;
		`;
		// Prepare statement
		global.db.execute(sql, [rate, rowID], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function getAmountWithLiveRatesForFund(fundID) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `
			SELECT \`coin_amount\`.\`id\`, \`fund_components\`.\`fund_id\`, \`coins\`.\`symbol\` ,\`coin_amount\`.\`amount\`, \`coin_rates\`.\`quote\`, \`coin_rates\`.\`rate\`, \`coin_rates\`.\`updated\` 
			FROM \`coin_amount\` 
			INNER JOIN \`fund_components\` ON \`coin_amount\`.\`component_id\` = \`fund_components\`.\`id\` 
			INNER JOIN \`coins\` ON \`fund_components\`.\`coin_id\` = \`coins\`.\`id\` 
			INNER JOIN \`coin_rates\`ON \`fund_components\`.\`coin_id\` = \`coin_rates\`.\`coin_id\` 
			WHERE \`fund_components\`.\`fund_id\` = ?
		`;
		// Prepare statement
		global.db.execute(sql, [fundID], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function totalBTC(rows) {
	return new Promise((resolve, reject) => {
		const indexOfLastRow = rows.length - 1;
		let total = 0;
		for (let j = 0; j < rows.length; j++) {
			const totalValue = parseFloat(rows[j]['amount']) * parseFloat(rows[j]['rate']);
			rows[j]['totalValue'] = totalValue.toFixedDown(8);
			total += totalValue;
			// logger.info(`addBTC: ${total}`);
			if (indexOfLastRow === j) {
				// logger.info(`Last row reached. Total btc: ${total}`);
				resolve(total.toFixedDown(8));
			}
		}
	});
}

function updateFundUnits(fundID, units) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `
			UPDATE \`funds\` 
			SET units = ? 
			WHERE id = ?;
		`;
		// Prepare statement
		global.db.execute(sql, [units, fundID], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}


function getFundUnitLedger(fundID, txn) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `SELECT * FROM \`fund_unit_ledger\` WHERE \`fund_id\` = ? AND \`txn\` = ?;`;
		// Prepare statement
		global.db.execute(sql, [fundID, txn], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function getFunds() {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `SELECT * FROM \`funds\`;`;
		// Prepare statement
		global.db.execute(sql, [], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function getFundUnits(fundID) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `SELECT \`units\` FROM \`funds\` WHERE \`id\` = ? LIMIT 1;`;
		// Prepare statement
		global.db.execute(sql, [fundID], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function insertNavToDB(fundID, nav) {
	return new Promise((resolve, reject) => {
		// simple query
		const sql = `INSERT INTO \`fund_nav\`(\`fund_id\`, \`value\`) VALUES (?, ?)`;
		
		// Prepare statement
		global.db.execute(sql, [fundID, nav], function(err, results, fields) {
			if (err) {
				reject(err);
			}
			resolve(results);
		});
	});
}

function getCoinAmountID(symbol, coinsObj) {
	return new Promise((resolve, reject) => {
		for (let item of coinsObj) {
			if (item['symbol'] == symbol) {
				resolve(item['id']);
				break;
			}
		}
	});
}






























