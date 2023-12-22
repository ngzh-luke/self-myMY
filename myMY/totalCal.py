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
    currencyRate = {"USD":0.03,"RMB":0.20}  # compare to 1THB
    currencyList = ['THB', 'RMB', 'USD', 'TWD'] # (ISO 3166-1 alpha-3 country code)

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

    def getCurrencyRate(self, currency="THB") -> float|str:
        """ Return current currency exchange rate 
            - `add` the given currency
            - `delete` the given currency

          'return' `True` if operation succeed """
        return self.currencyRate[currency]
    
    def convertToTHB(self, currency="RMB", amount=0.0) -> float|Exception:
        try:
            foreign = self.getCurrencyRate(currency=currency)
        except Exception as e:
            return e
        try:
            converted = amount/foreign
            return converted
        except Exception as e:
            return e
        
    
    
    



t = totalCal()
t.updateCurrencyRate()
t.updateCurrencyRate(rate=0.20, currency='RMB')
# t.updateCurrencyRate(rate=2)
t.updateCurrencyRate(rate=0.03, currency='USD')
print(t.convertToTHB(amount=1, currency="RMB"))
print(t.convertToTHB(amount=1, currency='USD'))
