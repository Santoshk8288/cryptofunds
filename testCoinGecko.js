/*
	{ id: 'bmax', symbol: 'btmx', name: 'Bitmax Token' }
	{ id: 'fcoin-token', symbol: 'ft', name: 'FCoin Token' }

*/
//1. Import coingecko-api
const CoinGecko = require('coingecko-api');

//2. Initiate the CoinGecko API Client
const CoinGeckoClient = new CoinGecko();

//3. Make calls

(async()=>{
	/*let data = await CoinGeckoClient.coins.list();
  data.data.forEach((obj)=>{
		if(obj.name == 'FCoin Token') console.log(obj)
		if(obj.name == 'Bitmax Token') console.log(obj)
		// if(obj.name.includes('Bitmax Token'))console.log(obj)
  })*/
  let data = await CoinGeckoClient.coins.fetchTickers('bmax')
  await data.data.tickers.forEach((obj)=>{
		if(obj.target == 'BTC')console.log(obj.last)
  })
})()
