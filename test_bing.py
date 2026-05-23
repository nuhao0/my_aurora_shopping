import urllib.request
import re

try:
    url = 'https://www.bing.com/images/search?q=elegant+evening+gown+fashion'
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
    html = urllib.request.urlopen(req).read().decode('utf-8')
    matches = re.findall(r'https://tse[0-9]\.mm\.bing\.net/th/id/[A-Za-z0-9_-]+', html)
    print("Found bing:", matches[:5])
except Exception as e:
    print("Error:", e)
