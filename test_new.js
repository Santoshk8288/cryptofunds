const util = require('util');
const ccxt = require ('ccxt');
const cron = require('node-cron');

var fs = require("fs");

let hitbtc = new ccxt.hitbtc2(); 

// console.log(hitbtc.load_markets());
(async ()=>{
	
	/*cron.schedule("* * * * *", async()=> {
    let data = await hitbtc.fetchTicker()
    console.log(data)
  });*/
	
	let market = await hitbtc.load_markets()
	// let data = await hitbtc.fetchTicker('FT/USDT')
	
	// util.inspect(Object.keys(market))
	// console.log(util.inspect(Object.keys(market)))
	// console.log(Object.keys(market))
	
	/*fs.writeFile("temp.txt", JSON.stringify(market), (err) => {
	  if (err) console.log(err);
	  console.log("Successfully Written to File.");
	})*/
	/*Object.keys(market).forEach((key) =>{
		console.log('-------------------')
		// console.log(market[key])
		console.log('-------------------')
	})*/
	Object.keys(market).forEach((key)=>{
		if(market[key].symbol.includes("F")){
			console.log(market[key].symbol)
		}
	})
	
})()