""" Custom error class """

class confirmationError(Exception):
    """ User confirmation error """
    msg = str()
    def __init__(self, *args: object, msg="User confirmation error!") -> None:
        self.msg = msg
        super().__init__(*args)

class noTransactionsError(Exception):
    """ No transactions record error """
    msg = str()
    def __init__(self, *args: object, msg="No transactions record error!") -> None:
        self.msg = msg
        super().__init__(*args)