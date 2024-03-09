""" helper.totalCal """


class totalCal():
    """ 
    - default currency is `THB`

    ## Attributes:

        `recived` -> float(), \n
        `spent` -> float(), \n
        `flow` -> float(), \n
        `currencyRate` -> dict(), \n
        `currencyList` -> list() 
         """
    received = float()
    spent = float()
    flow = float()
    currencyRate = {"USD":0.03,"RMB":0.20,"THB":1.0,"TWD":0.90}  # compare to 1THB
    currencyList = ['THB', 'RMB', 'USD', 'TWD'] # 

    def __init__(self, received=0.0, spent=0.0, flow=0.0) -> None:
        self.received = received
        self.spent = spent
        self.flow = flow

    def updateCurrencyRate(self, rate=1.0, currency='THB') -> bool | Exception:
        """ Add/Update exchange rate compared to THB (1THB=X[currency])

          `return` `True` if operation succeed """
        try:
            for item in self.currencyList:
                if item == currency:
                    self.currencyRate[currency] = rate
                    return True
            return False
        except Exception as e:
            return e

    def updateCurrencyList(self, currency='THB', delete=False) -> bool | Exception:
        """ Add/Delete currency
            - `add` the given currency
            - `delete` the given currency

         # Returns
          `return` `True` if operation succeed """
        if delete == True:
            try:
                for item in self.currencyList:
                    if item == currency:
                        self.currencyList.remove(currency)
                        return True
                    
                return False
            except Exception as e:
                return e
        else:
            try:
                for item in self.currencyList:
                    if item == currency:
                        return False
                  
                self.currencyList.append(currency)
                return True
           
            except Exception as e:
                return e
        return False
    
    def isCurrencyAvailable(self, currency:str):
        """ Return `True` if given currency is defined in instance list, else `False` 
    
    """
        try:
            for item in self.currencyList:
                if item == currency:
                    return True
        except:
            return Exception
        return False

    def getCurrencyRate(self, currency="THB") -> float|Exception:
        """ Return current currency exchange rate 

         default rate is `THB`

         # Returns
          `return` `float()` or `None` if found, `Exception` if error """
        try:
            if self.isCurrencyAvailable(currency=currency):
                return self.currencyRate[currency]
            else:
                return Exception
        except Exception as e:
            return e

    def getCurrencyList(self):
        """ Return current instance currency list 
        
        # Returns
        `return` `list()` if succeed, else `None`
        """
        try:
            return self.currencyList
        except:
            return None

    def getCurrencyListAndRate(self, all=True, currency="THB"):
        """ Return a dictionary of all currency and its rate or only a pair of currency and its rate
        ## Arguments
        - `all`: `bool` = `True` -> assign `False` if want only given currency and its rate (must specify value for 'currency')
        - `currency`: `str()` -> assign to any currency (e.g. THB) to only get a pair of currency and its rate
        
        # Returns
          `return` `dict()` if succeed, `None` if failed """
        if all == True:
            currency = None
            try:
                return self.currencyRate
            except:
                return None
        else:
            try:
                if self.isCurrencyAvailable(currency=currency):
                    pair = {currency:self.currencyRate.get(currency)}
                else:
                    return None
                return pair
            except:
                return None

    def convertToTHB(self, currency="RMB", amount=0.0) -> float|Exception:
        """ Return the given currency money amount that approximately equals to THB 
        
        # Returns
        `return` `float` if convert successfully, `Exception` if error
        """
        try:
            foreign = self.getCurrencyRate(currency=currency)
        except Exception as e:
            return e
        try:
            converted = amount/foreign
            return converted
        except Exception as e:
            return e
        
    def getSumAmount(self, currency='RMB', **kwargs:float) -> dict | None | Exception:
        """ Returns the sumarized amount of the given value(s) of the same currency to THB and initial currency amount
            
        ## Arguments
        - `currency`: `str()` = `RMB` -> initial currency
        - `**kwargs`: `float`

        ## Returned dict: 
        E.x. `{'initial_currency': 'RMB', 'initial_currency_sum': 5.0, 'sum': 25.0}`
        ### Return dict explaination:
            - `'initial_currency'` = Initial currency of receiving params
            - `'initial_currency_sum'` = Summarization of receiving params in initial currency 
            - `'sum'` = summarization of receiving params in `THB`
        
        # Returns    
          `return` `dict` or `None` if operation succeed, `Exception` if failed """
        try :
            summ = 0.0
            iniCurSum = 0.0
            for key, value in kwargs.items():
                iniCurSum += kwargs[key] # sum the inital curr amount before get replaced by THB
                kwargs[key] = self.convertToTHB(currency=currency, amount=value)
                summ += float(kwargs[key])
            return {"initial_currency":currency,'initial_currency_sum':iniCurSum,"sum":summ, }
        except:
            return Exception
        
    def addOutcome(self, outcome:float, currency="THB"):
        """ Returns `True` if succeed, `False` otherwise.
        
        add outcome transaction with default currency is `THB`  
        
        Attempt to convert to `THB` if it is not."""
        if currency == "THB":
            try:
                self.spent += outcome
            except:
                return False
        else:
            try:
                self.spent += self.convertToTHB(currency=currency,amount=outcome)
            except:
                return False
        return True
            
    def addIncome(self, income:float, currency="THB"):
        """ Returns `True` if succeed, `False` otherwise.
        
        add income transaction with default currency is `THB` 
        
        Attempt to convert to `THB` if it is not."""
        if currency == "THB":
            try:
                self.received += income
            except:
                return False
        else:
            try:
                self.received += self.convertToTHB(currency=currency,amount=income)
            except:
                return False
        return True
    
    def calFlow(self):
        self.flow = self.received - self.spent

    def getFlow(self, ndigits: int | None = None) -> float:
        """
        # Argument
        - `ndigits`: `int()` or `None` -> number up to which the given number is rounded
        # Returns
        `return` `float` value of current instance's flow with a `ndigits` decimal places if `ndigits` is specified, otherwise, its raw value
        """
        self.calFlow()
        if (type(ndigits) == int):
            return round(number=self.flow, ndigits=ndigits)
        return self.flow
    
    def getOutcome(self, ndigits: int | None = None) -> float:
        """ 
        # Argument
        - `ndigits`: `int()` or `None` -> number up to which the given number is rounded
        # Returns
        `return` `float` value of current instance's outcome with a `ndigits` decimal places if `ndigits` is specified, otherwise, its raw value
        """
        if (type(ndigits) == int):
            return round(number=self.spent, ndigits=ndigits)
        return self.spent
    
    def getIncome(self, ndigits: int | None = None) -> float:
        """
        # Argument
        - `ndigits`: `int()` or `None` -> number up to which the given number is rounded
        # Returns
        `return` `float` value of current instance's income with a `ndigits` decimal places if `ndigits` is specified, otherwise, its raw value
        """
        if (type(ndigits) == int):
            return round(number=self.received, ndigits=ndigits)
        return self.received




# t = totalCal()
# t.updateCurrencyRate()
# t.updateCurrencyRate(rate=0.20, currency='RMB')
# t.updateCurrencyRate(rate=2)
# t.updateCurrencyRate(rate=0.03, currency='USD')
# print(t.convertToTHB(amount=1, currency="RMB"))
# print(t.convertToTHB(amount=1, currency='USD'))
# print(t.getSumAmount(a=1,b=1,c=1,d=2))
# t.updateCurrencyRate(rate=1.1,currency="TWD")
# print(t.getCurrencyRate("TWD"))
# t.addOutcome(outcome=4)
# t.addOutcome(outcome=4, currency="RMB")
# print(t.spent)
# print("list",t.getCurrencyList())
# print("rate", t.getCurrencyRate())
# print(t.getCurrencyListAndRate())
# print(t.getCurrencyListAndRate(all=False, currency="RMB"))
# print(t.addIncome(1000, currency='s'))
# print(t.addOutcome(100, currency='s'))
# print(t.getIncome(), t.getOutcome(), t.getFlow())
