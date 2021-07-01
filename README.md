# Passcont
This project for me to understand Smart Contracts/Dapps better and learn how to interact with them.

The Project's purpose is prevent the fake passports. Basically there are some admins who has rights to add 
passport hashes to the blockchain. These people got their rights from gouvernment. 

We are getting the hashes of these three arguments: Passport Number, Full name of the passport's owner and the expire 
year of the passport. And the hash of these arguments will be compared with the existing hashes. This is our control mechanism. 

In order to take  the privacy of passports' owners under control we only hold hashes on the blockchain.

So admins can either add passport hashes to the blockchain or control the hashes with the existing hashes which are already on blockchain.
They can also create new admins but this is not good. Admin authority should be leveled.

# Installation and Running

To try this contract you should have truffle, blockchain provider at http://localhost:7545 (I used Ganache) and you should change the addresses 
of the admins from the Passpor.sol. MetaMask is also necessary to have it.

Then clone this repo. After that, type ``` npm install ``` under project dir.

Because of we changed Passport.sol we have to migrate again. Type

```
truffle migrate --reset
```

Then to run project, type 
```
npm run dev
```

You should good to go!
