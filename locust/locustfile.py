import sys, os, glob, pprint
import time

here = os.path.abspath(os.path.dirname(__file__))
sys.path.insert(0, os.path.join(here, '../client/python/socialcoffee/gen-py'))

from thrift import Thrift
from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol

from socialcoffee.thrift import SocialCoffeeService
from socialcoffee.thrift.ttypes import *

from locust import Locust, events, TaskSet, task

import random 

class ThriftClient():
    def __init__(self, host, port):
        self.transport        = TSocket.TSocket(host, port)
        self.framed_transport = TTransport.TFramedTransport(self.transport)
        self.protocol         = TBinaryProtocol.TBinaryProtocol(self.framed_transport)
        self.client           = SocialCoffeeService.Client(self.protocol)
        self.framed_transport.open()

    def __del__(self):
        self.framed_transport.close()

    def __getattr__(self, name):
        func = getattr(self.client, name)
        def wrapper(*args, **kwargs):
            start_time = time.time()
            try:
                result = func(*args, **kwargs)
            except Exception as e:
                pprint.pprint(e)
                total_time = int((time.time() - start_time) * 1000)
                events.request_failure.fire(request_type="thrift", name=name, response_time=total_time, exception=e)
            else: 
                total_time = int((time.time() - start_time) * 1000)
                events.request_success.fire(request_type="thrift", name=name, response_time=total_time, response_length=0)

        return wrapper

class ThriftLocust(Locust):
    def __init__(self, *args, **kwargs):
        super(ThriftLocust, self).__init__(*args, **kwargs)
        self.client = ThriftClient(self.host, 9090)

class ClientBehaviour(TaskSet):
    @task
    def ping(self):
        self.client.ping()

    @task
    def get_friends(self):
        self.client.get_friends(random.randint(0, 100))

    @task
    def create_friendship(self):
        self.client.create_friendship(random.randint(0, 100), random.randint(0, 100))

    @task
    def remove_friendship(self):
        self.client.remove_friendship(random.randint(0, 100), random.randint(0, 100))

class SocialCoffeeApiClient(ThriftLocust):
    task_set = ClientBehaviour
    min_wait = 0
    max_wait = 100
    host     = "srv01.platform.com"