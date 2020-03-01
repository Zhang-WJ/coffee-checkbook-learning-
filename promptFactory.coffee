utils = require('./utils')

# PromptFactory defines the presentation of each prompt in the app

class PromptFactory
    constructor: ({@allAccounts}) ->

    accountPrompt: ->
        {
            name: 'account'
            message: 'Pick an Account:'
            type: 'list'
            choices: (for account in @allAccounts
                        {name: account.description(), value: account}
                        ).concat({name:'new Account', value: null})
        }

    newAccountPrompt: ->
        {
            name: 'name'
            message: "Enter a name for this account:"
            type: 'input'
            validate: (input) =>
                for account in @allAccounts
                    if account.name is input
                        return 'That account name is already taken!'
                true
        }

    actionPrompt: ({account}) ->
        {
            name:'action'
            message: 'Pick an action:'
            type:'list'
            choices: [
                {name: 'Deposit $ into this account', value: 'deposit'}
                {name: 'Withdraw $ from this account', value: 'withdraw'}
                {name: 'Transfer $ to another account', value: 'transfer'}
            ]
        }

    toAccountPrompt: ({fromAccount}) ->
        {
            name: 'toAccount'
            message: 'Pick an Account to transfer $ to:'
            type: 'list'
            choices: for account in @allAccounts
                {name: account.description(), value: account}
        }

    amountPrompt: ({action}) ->
        {
            name: 'amount'
            # message: "Enter the amount to #{action}"
            type: 'input'
            validate: (inp) =>
                if isNaN(utils.inputToNumber(inp))
                    return 'Please enter a numerical amount.'
                if utils.inputToNumber(inp) < 0
                    return 'Please enter non-negative amount'
                true
        }

module.exports = PromptFactory