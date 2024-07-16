#!/usr/bin/env python3
""" MongoDB Operations with Python using pymongo """
from pymongo import MongoClient


METHODS = ["GET", "POST", "PUT", "PATCH", "DELETE"]

def log_stats(mongo_collection):
    """ Provides some stats about Nginx logs stored in MongoDB """
    n_logs = mongo_collection.count_documents({})
    print(f'{n_logs} logs')

    print('Methods:')
    for method in METHODS:
        count = mongo_collection.count_documents({"method": method})
        print(f'\tmethod {method}: {count}')

    status_check = mongo_collection.count_documents(
        {"method": "GET", "path": "/status"}
    )
    print(f'{status_check} status check')

if __name__ == "__main__":
    client = MongoClient('mongodb://127.0.0.1:27017')
    nginx_collection = client.logs.nginx
    log_stats(nginx_collection)
