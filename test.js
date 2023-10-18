const util = require('util');

const coinsObj = [
	{
	    id: 3,
	    symbol: 'BNB',
	    amount: '862.01281000',
	},
	{
	    id: 4,
	    symbol: 'OKB',
	    amount: '5310.33065370',
	},
	{
	    id: 5,
	    symbol: 'ZB',
	    amount: '33038.16859000',
	}
];

main()
	.then(result => console.log(result))
	.catch(err => console.error(err));

function getCoinAmountID(symbol) {
	return new Promise((resolve, reject) => {
		for (let item of coinsObj) {
			if (item['symbol'] == symbol) {
				resolve(item['id']);
				break;
			}
		}
	});
}


async function main() {
	try {
		const coinID = await getCoinAmountID("OKB");
		return coinID;		
	} catch(error) {
		console.error(error);
	}
	
}

