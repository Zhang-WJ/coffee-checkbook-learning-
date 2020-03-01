inquirer = require('inquirer')

Account = require('./account')
PromptFactory = require('./promptFactory')
utils = require('./utils')

# Define our logic for each prompt the user can reach
promptFactory = new PromptFactory({allAccounts: Account.allAccounts})

mainStep = ->
    inquirer.prompt(promptFactory.accountPrompt()).then(
        ({account}) ->
                if account is null
                    createAccountStep()
                else 
                    actionStep({account})
    ) 

createAccountStep = ->
    inquirer.prompt(promptFactory.newAccountPrompt()).then(
        ({name}) ->
                new Account({balance:0, name})
                Account.saveState()
                mainStep()
    ) 

actionStep = ({account}) ->
    inquirer.prompt(promptFactory.actionPrompt({account})).then(
        ({action}) ->
                postActionStep({account, action})
    ) 

postActionStep = ({account, action}) ->
    prompts = [promptFactory.amountPrompt({action})]
    if action is 'transfer'
        prompts.unshift promptFactory.toAccountPrompt({fromAccount: account})

    inquirer.prompt(prompts).then(
        ({amount, toAccount}) ->
                amount = utils.inputToNumber(amount)
                account[action]({amount, toAccount})
                mainStep()
    ) 

# Load Data
Account.loadState()

# show the first prompt
mainStep()