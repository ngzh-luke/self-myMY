""" unique id generator """
from uuid import *
from faker import *

# uuidIns= UUID()
fk = Faker()

def gen1():
    """ gen uuid1 """
    return uuid1()