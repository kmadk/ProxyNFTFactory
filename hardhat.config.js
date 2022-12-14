require('@nomiclabs/hardhat-waffle')
require('@nomiclabs/hardhat-web3')
require('solidity-coverage')
require('dotenv').config()
// Include the Etherscan contract verifier.
require('@nomiclabs/hardhat-etherscan');
module.exports = {
	networks: {
		// --- EVM
		hardhat: {},
		mainnet: {
			url: process.env.MAINNET_RPC || '',
			accounts: process.env.MAINNET_PRIVATE_KEY ? [process.env.MAINNET_PRIVATE_KEY] : [],
		},
		avm: {
			url: process.env.AVM_RPC || '',
			accounts: process.env.AVM_PRIVATE_KEY ? [process.env.AVM_PRIVATE_KEY] : [],
		},
		rinkeby: {
			url: process.env.RINKEBY_RPC || '',
			accounts: process.env.RINKEBY_PRIVATE_KEY ? [process.env.RINKEBY_PRIVATE_KEY] : [],
		},
		rinkeby_avm: {
			url: process.env.RINKEBY_AVM_RPC || '',
			accounts: process.env.RINKEBY_AVM_PRIVATE_KEY ? [process.env.RINKEBY_AVM_PRIVATE_KEY] : [],
		}
	},
	solidity: {
		version:  "0.8.2",
		settings: {
			optimizer: {
			enabled: true,
			runs: 200,
			}
		},
	},
	paths: {
		sources: './contracts',
		tests: './test',
		cache: './cache',
		artifacts: './build/contracts',
	},
	etherscan: {
		apiKey:
		process.env.ETHERSCAN_API_KEY
	}
}