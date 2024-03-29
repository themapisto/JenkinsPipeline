# -*- coding: utf-8 -*-
'''
Created on 1983. 08. 09.
@author: Hye-Churn Jang, Staff Solution Architect, Multi-Cloud Management, Korea/SEAK/APJ/VMware [jangh@vmware.com]
'''

#===============================================================================
# Rest SDK Implementation                                                      #
#===============================================================================
import ssl
import json as JSON
import typing
import urllib.error
import urllib.request
from email.message import Message

class Response(typing.NamedTuple):
    text: str
    headers: Message
    status: int
    def json(self) -> typing.Any:
        try: output = JSON.loads(self.text)
        except JSON.JSONDecodeError: output = ''
        return output
    def raise_for_status(self):
        if self.status >= 400: raise Exception('response error with status code {}'.format(self.status))
        return self

class requests:
    @classmethod
    def __headers__(cls, headers):
        headers = headers or {}
        if 'Accept' not in headers: headers['Accept'] = 'application/json'
        if 'Content-Type' not in headers: headers['Content-Type'] = 'application/json'
        return headers
    @classmethod
    def __payload__(cls, data, json):
        if data: return data.encode('utf-8')
        elif json: return JSON.dumps(json).encode('utf-8')
        else: return ''.encode('utf-8')
    @classmethod
    def __encode__(cls, url): return url.replace(' ', '%20').replace('$', '%24').replace("'", '%27').replace('[', '%5B').replace(']', '%5D')
    @classmethod
    def __call__(cls, httprequest):
        try:
            with urllib.request.urlopen(httprequest, context=ssl._create_unverified_context()) as httpresponse: response = Response(text=httpresponse.read().decode(httpresponse.headers.get_content_charset('utf-8')), headers=httpresponse.headers, status=httpresponse.status)
        except urllib.error.HTTPError as e: response = Response(text=e.fp.read().decode('utf-8'), headers=e.headers, status=e.code)
        return response
    @classmethod
    def get(cls, url:str, headers:dict=None) -> Response: return cls.__call__(urllib.request.Request(cls.__encode__(url), method='GET', headers=cls.__headers__(headers)))
    @classmethod
    def post(cls, url:str, headers:dict=None, data:str=None, json:dict=None) -> Response: return cls.__call__(urllib.request.Request(cls.__encode__(url), method='POST', headers=cls.__headers__(headers), data=cls.__payload__(data, json)))
    @classmethod
    def put(cls, url:str, headers:dict=None, data:str=None, json:dict=None) -> Response: return cls.__call__(urllib.request.Request(cls.__encode__(url), method='PUT', headers=cls.__headers__(headers), data=cls.__payload__(data, json)))
    @classmethod
    def patch(cls, url:str, headers:dict=None, data:str=None, json:dict=None) -> Response: return cls.__call__(urllib.request.Request(cls.__encode__(url), method='PATCH', headers=cls.__headers__(headers), data=cls.__payload__(data, json)))
    @classmethod
    def delete(cls, url:str, headers:dict=None) -> Response: return cls.__call__(urllib.request.Request(cls.__encode__(url), method='DELETE', headers=cls.__headers__(headers)))

class VraManager:
    def __init__(self, context, inputs):
        self.hostname = context.getSecret(inputs['VraManager']['hostname'])
        self.headers = {}
        data = self.post('/csp/gateway/am/api/login?access_token', {'username': context.getSecret(inputs['VraManager']['username']), 'password': context.getSecret(inputs['VraManager']['password'])})
        data = self.post('/iaas/api/login', {'refreshToken': data['refresh_token']})
        self.headers['Authorization'] = 'Bearer ' + data['token']
    def toJson(self, response):
        try: response.raise_for_status()
        except Exception as e:
            try: data = JSON.dumps(response.json(), indent=2)
            except: data = response.text
            raise Exception('{} : {}'.format(str(e), data))
        return response.json()
    def get(self, url:str) -> dict: return self.toJson(requests.get('https://{}{}'.format(self.hostname, url), headers=self.headers))
    def post(self, url:str, data:dict=None) -> dict: return self.toJson(requests.post('https://{}{}'.format(self.hostname, url), headers=self.headers, json=data))
    def put(self, url:str, data:dict=None) -> dict: return self.toJson(requests.put('https://{}{}'.format(self.hostname, url), headers=self.headers, json=data))
    def patch(self, url:str, data:dict=None) -> dict: return self.toJson(requests.patch('https://{}{}'.format(self.hostname, url), headers=self.headers, json=data))
    def delete(self, url:str) -> dict: return self.toJson(requests.delete('https://{}{}'.format(self.hostname, url), headers=self.headers))



#===============================================================================
# ABX Code Implementations                                                     #
#===============================================================================
# Import Libraries Here
import time

workflowId = 'a27272bf-e0e3-4725-97d1-7a4a1ea766b7'
workflowEp = '/vco/api/workflows/' + workflowId + '/executions'

# Implement Handler Here
def handler(context, inputs):
    # set common values
    vra = VraManager(context, inputs)
    
    # set default values
    name = inputs['name']
    if 'controller' not in inputs or not inputs['controller']: raise Exception('controller property must be required') # Required
    controller = inputs['controller']
    if 'serverCloud' not in inputs or not inputs['serverCloud']: raise Exception('serverCloud property must be required') # Required
    serverCloud = inputs['serverCloud']
    if 'address' not in inputs or not inputs['address']: raise Exception('address property must be required') # Required
    address = inputs['address']
    instances = inputs['instances']
    routes = inputs['routes']
    
    instanceElements = []
    for instance in instances:
        instanceElements.append({'string': {'value': instance}})
    
    routeElements = []
    for route in routes:
        routeProperty = []
        routeProperty.append({
            'key': 'protocol',
            'value': {'string': {'value': route['protocol']}}
        })
        routeProperty.append({
            'key': 'port',
            'value': {'string': {'value': route['port']}}
        })
        routeProperty.append({
            'key': 'instanceProtocol',
            'value': {'string': {'value': route['instanceProtocol']}}
        })
        routeElements.append({'properties': {'property': routeProperty}})
    
    res = vra.post(workflowEp, {
        'parameters': [{
            'name': 'name',
            'type': 'string',
            'value': {'string': {'value': name}}
        },{
            'name': 'controller',
            'type': 'string',
            'value': {'string': {'value': controller}}
        },{
            'name': 'serverCloud',
            'type': 'string',
            'value': {'string': {'value': serverCloud}}
        },{
            'name': 'address',
            'type': 'string',
            'value': {'string': {'value': address}}
        },{
            'name': 'instances',
            'type': 'Array/string',
            'value': {'array': {'elements': instanceElements}}
        },{
            'name': 'routes',
            'type': 'Array/Properties',
            'value': {'array': {'elements': routeElements}}
        }]
    })
    executionId = res['id']
    for _ in range(0, 300):
        res = vra.get(workflowEp + '/' + executionId + '/state')
        state = res['value']
        if state != 'running':
            res = vra.get(workflowEp + '/' + executionId)
            if state == 'completed':
                id = res['output-parameters'][0]['value']['string']['value']
                break
            elif state == 'failed': raise Exception(res['content-exception'])
        time.sleep(2)
    
    outputs = inputs
    outputs.pop('VraManager')
    outputs['id'] = id
    return outputs
