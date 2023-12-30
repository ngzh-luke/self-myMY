""" helper.totalCal """


class totalCal():
    """ #Attribute:

        recived -> float(), \n
        spent -> float(), \n
        flow -> float(), \n
        currencyRate -> dict(), \n
        currencyList -> list() 
         """
    received = float()
    spent = float()
    flow = float()
    currencyRate = {"USD":0.03,"RMB":0.20,"THB":1}  # compare to 1THB
    currencyList = ['THB', 'RMB', 'USD', 'TWD'] # 

    def __init__(self, received=0.0, spent=0.0, flow=0.0) -> None:
        self.received = received
        self.spent = spent
        self.flow = flow

    def updateCurrencyRate(self, rate=1.0, currency='THB') -> bool | Exception:
        """ Add/Update exchange rate compared to THB (1THB=X[currency])

          'return' `True` if operation succeed """
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

          'return' `True` if operation succeed """
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

    def getCurrencyRate(self, currency="THB") -> float|None|Exception:
        """ Return current currency exchange rate 

          'return' `float()` or `None` if found, `Exception` if error """
        try:
            return self.currencyRate[currency]
        except Exception as e:
            return e
    
    def convertToTHB(self, currency="RMB", amount=0.0) -> float|Exception:
        """ Return the given currency money amount that approximately equals to THB 
        
        'return' `float` if convert successfully, `Exception` if error
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
        """ Return the sumarized amount of the given value(s) of the same currency to THB and initial currency amount
            
            Example returned dict: `{'initial_currency': 'RMB', 'initial_currency_sum': 5.0, 'sum': 25.0}`
            `Return dict explaination:`
            - `'initial_currency'` = Initial currency of receiving params
            - `'initial_currency_sum'` = Summarization of receiving params in initial currency 
            - `'sum'` = summarization of receiving params in `THB`
        
          'return' `dict` or `None` if operation succeed, `Exception` if failed """
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




t = totalCal()
t.updateCurrencyRate()
t.updateCurrencyRate(rate=0.20, currency='RMB')
# t.updateCurrencyRate(rate=2)
# t.updateCurrencyRate(rate=0.03, currency='USD')
# print(t.convertToTHB(amount=1, currency="RMB"))
# print(t.convertToTHB(amount=1, currency='USD'))
print(t.getSumAmount(a=1,b=1,c=1,d=2))
