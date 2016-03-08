#!/usr/bin/env python

import docker
import sys

import pprint
pp = pprint.PrettyPrinter()

from docker import Client
cli = Client(base_url='unix://var/run/docker.sock')

try:
    # For Python 3.0 and later
    from urllib.request import urlopen
except ImportError:
    # Fall back to Python 2's urllib2
    from urllib2 import urlopen
    import json

def get_jsonparsed_data(url):
    """Receive the content of ``url``, parse it as JSON and return the
       object.
    """
    response = urlopen(url)
    data = str(response.read())
    return json.loads(data)

def findLayers(list,search_layer):
  for tag,layer in list.iteritems():
    if layer == search_layer:
      yield tag

images = get_jsonparsed_data('https://registry.access.redhat.com/v1/search?q=*')
for image in images['results']:
  name = image['name']
  if (("beta" not in name) and ("rhcloud" not in name)):
    print(name)
    tags = get_jsonparsed_data('https://registry.access.redhat.com/v1/repositories/'+name+'/tags')
    latest = tags['latest']
    for tag in findLayers(tags,latest):
      print "  Pulling tag: "+tag
      for line in cli.pull(repository='registry.access.redhat.com/'+name,tag=tag,stream=True):
        print("    "+line)
