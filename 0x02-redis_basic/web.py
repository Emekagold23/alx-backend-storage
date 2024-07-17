#!/usr/bin/env python3
"""
web cache and tracker
"""
import requests
import redis
from functools import wraps

# Redis client instance
store = redis.Redis()

def count_url_access(method):
    """ Decorator counting how many times a URL is accessed """
    @wraps(method)
    def wrapper(url):
        # Cache key for storing HTML content
        cached_key = "cached:" + url
        cached_data = store.get(cached_key)
        if cached_data:
            return cached_data.decode("utf-8")

        # Count key for tracking URL accesses
        count_key = "count:" + url

        # Call the actual method to get HTML content
        html = method(url)

        # Increment access count and cache HTML content
        store.incr(count_key)
        store.set(cached_key, html)
        store.expire(cached_key, 10)  # Cache expires in 10 seconds
        return html
    return wrapper

@count_url_access
def get_page(url: str) -> str:
    """ Returns HTML content of a URL """
    res = requests.get(url)
    return res.text
