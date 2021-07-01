App = {
    Web3Provider:   null,
    contracts:      {},
    account:        '0x0',
    

    init: function() {
        return App.initWeb3();
    },

    initWeb3: function() {
        if (typeof web3 !== 'undefined') {
          // If a web3 instance is already provided by Meta Mask.
          App.web3Provider = web3.currentProvider;
          web3 = new Web3(web3.currentProvider);
        } else {
          // Specify default instance if no web3 instance provided
          App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
          web3 = new Web3(App.web3Provider);
        }
        return App.initContract();      
    },

    initContract: function() {
        $.getJSON("Passport.json", function(passport) {
            // Instantiate a new truffle contract from the artifact
            App.contracts.Passport = TruffleContract(passport);
            // Connect provider to interact with contract
            App.contracts.Passport.setProvider(App.web3Provider);
      
            App.listenForEvents();
      
            return App.render();
        });
    },

    // Listen for events emitted from the contract
    listenForEvents: function() {
      App.contracts.Passport.deployed().then(function(instance) {
        // Restart Chrome if you are unable to receive this event
        // This is a known issue with Metamask
        // https://github.com/MetaMask/metamask-extension/issues/2393
        instance.hashedEvent({}, {
          fromBlock: 'latest',
          toBlock: 'latest'
        }).watch(function(error, event) {
          console.log("event triggered", event)
          // Reload when a new vote is recorded
          App.render();
        });
      });
    },

    render: function() {
        var passportInstance;
        var loader = document.getElementById("loader");
        var content = document.getElementById("content");
    
        // loader.show;
        // content.show;
    
        // Load account data
        web3.eth.getCoinbase(function(err, account) {
          if (err === null) {
            App.account = account;
            $("#accountAddress").html("Your Account: " + account);
          }
          
          
        });
    
        //Load contract data
        App.contracts.Passport.deployed().then(function(instance) {
            passportInstance = instance;
            return passportInstance.passpCount();
        }).then(function(passpCount) {
          //document.getElementById("passCount").value = passpCount;
        });

        // App.contracts.Passport.deployed().then(function(instance) {
        //   return instance.isAccountAdmin( {from: App.account} );
        // }).then(function(result){
        //   console.log(result)
        //   if(result === true){ loader.hide; content.show; }
        //   else {loader.show; content.hide;}
        // })

    },

    savePassToChain: function() {
      

      var PassName = document.getElementById("fname").value;
      var passNumb = document.getElementById("passnumber").value;
      var PassExpire = parseInt(document.getElementById("syear").value);

      console.log(passNumb);
      console.log(PassName);
      console.log(PassExpire);


      App.contracts.Passport.deployed().then(function(instance){
        return instance.addPassport(passNumb, PassName, PassExpire, { from: App.account });
      }).then(function(result){
        // document.getElementById("content").show;
        // document.getElementById("loader").show;
        
    }).catch(function(err) {
      console.error(err);
      });
    },

    createNewAdmin: function() {

      var admName = document.getElementById("fname").value;
      var admAddress = document.getElementById("newaddress").value;

      console.log(admName);
      console.log(admAddress);

      App.contracts.Passport.deployed().then(function(instance){
        return instance.addAdmin(admAddress, admName, 0, { from: App.account });
      }).then(function(result){

      }).catch(function(err){
        console.error(err);
      })

    },

    controlPassport: function() {

      const date = new Date();
      const year = date.getFullYear();

      var PassName = document.getElementById("fname").value;
      var passNumb = document.getElementById("passnumber").value;
      var PassExpire = parseInt(document.getElementById("syear").value);

      console.log(passNumb);
      console.log(PassName);
      console.log(PassExpire);
      console.log(year);


      App.contracts.Passport.deployed().then(function(instance){
        return instance.controllPassport(passNumb, PassName, PassExpire, year, { from: App.account });
      }).then(function(result){
        document.getElementById("content").show;
        document.getElementById("loader").show;
        var popup = document.getElementById("popup");
        popup.classList.toggle("show");
        setTimeout(function(){ popup.classList.toggle("close"); }, 5000);
      }).catch(function(err) {
        console.error(err);
        var popup = document.getElementById("popuperr");
        popup.classList.toggle("show");
        setTimeout(function(){ popup.classList.toggle("close"); }, 5000);

      });

    }


}

$(function() {
  $(window).load(function() {
    App.init();
  });
});