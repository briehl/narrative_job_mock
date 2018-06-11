# -*- coding: utf-8 -*-
import unittest
import os  # noqa: F401
import json  # noqa: F401
import time
import requests

from os import environ
try:
    from ConfigParser import ConfigParser  # py2
except:
    from configparser import ConfigParser  # py3

from pprint import pprint  # noqa: F401

from biokbase.workspace.client import Workspace as workspaceService
from narrative_job_mock.narrative_job_mockImpl import narrative_job_mock
from narrative_job_mock.narrative_job_mockServer import MethodContext
from narrative_job_mock.authclient import KBaseAuth as _KBaseAuth


class narrative_job_mockTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        token = environ.get('KB_AUTH_TOKEN', None)
        config_file = environ.get('KB_DEPLOYMENT_CONFIG', None)
        cls.cfg = {}
        config = ConfigParser()
        config.read(config_file)
        for nameval in config.items('narrative_job_mock'):
            cls.cfg[nameval[0]] = nameval[1]
        # Getting username from Auth profile for token
        authServiceUrl = cls.cfg['auth-service-url']
        auth_client = _KBaseAuth(authServiceUrl)
        user_id = auth_client.get_user(token)
        # WARNING: don't call any logging methods on the context object,
        # it'll result in a NoneType error
        cls.ctx = MethodContext(None)
        cls.ctx.update({'token': token,
                        'user_id': user_id,
                        'provenance': [
                            {'service': 'narrative_job_mock',
                             'method': 'please_never_use_it_in_production',
                             'method_params': []
                             }],
                        'authenticated': 1})
        cls.serviceImpl = narrative_job_mock(cls.cfg)
        cls.scratch = cls.cfg['scratch']
        cls.job_ids = ["5ad7ec09e4b0a7033d0286cf", "5b1e95fde4b0d417818a2b85"] #"5afde6e1e4b0ac08e8b58f50"]

    def getImpl(self):
        return self.__class__.serviceImpl

    def getContext(self):
        return self.__class__.ctx

    def test_check_job_ok(self):
        state = self.getImpl().check_job(self.getContext(), self.job_ids[0])[0]
        self.assertIsNotNone(state)
        self.assertEqual(state.get('job_id'), self.job_ids[0])

    def test_check_batch_job_ok(self):
        state = self.getImpl().check_job(self.getContext(), self.job_ids[1])[0]
        self.assertIsNotNone(state)
        self.assertEqual(state.get('job_id'), self.job_ids[1])
        self.assertIn('sub_jobs', state)
        self.assertTrue(2 == len(state['sub_jobs']))

    def test_check_jobs_ok(self):
        state = self.getImpl().check_jobs(self.getContext(), {'job_ids': self.job_ids, 'with_job_params': 1})[0]
        self.assertIsNotNone(state)
        self.assertIn('job_states', state)
        self.assertIn('job_params', state)
        self.assertIn(self.job_ids[0], state['job_states'])
        self.assertIn(self.job_ids[1], state['job_states'])
        self.assertIn('sub_jobs', state['job_states'][self.job_ids[1]])

    def test_check_jobs_no_params_ok(self):
        state = self.getImpl().check_jobs(self.getContext(), {'job_ids': self.job_ids, 'with_job_params': 0})[0]
        self.assertIsNotNone(state)
        self.assertIn('job_states', state)
        self.assertNotIn('job_params', state)
        self.assertIn(self.job_ids[0], state['job_states'])
        self.assertIn(self.job_ids[1], state['job_states'])
        self.assertIn('sub_jobs', state['job_states'][self.job_ids[1]])
        pprint(state)
