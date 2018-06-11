# -*- coding: utf-8 -*-
#BEGIN_HEADER
# The header block is where all import statments should live
import os
from Bio import SeqIO
from pprint import pprint, pformat
from AssemblyUtil.AssemblyUtilClient import AssemblyUtil
from KBaseReport.KBaseReportClient import KBaseReport
from statemocker import StateMocker
#END_HEADER


class narrative_job_mock:
    '''
    Module Name:
    narrative_job_mock

    Module Description:
    A KBase module: narrative_job_mock
    '''

    ######## WARNING FOR GEVENT USERS ####### noqa
    # Since asynchronous IO can lead to methods - even the same method -
    # interrupting each other, you must be *very* careful when using global
    # state. A method could easily clobber the state set by another while
    # the latter method is running.
    ######################################### noqa
    VERSION = "0.0.1"
    GIT_URL = "https://github.com/briehl/narrative_job_mock.git"
    GIT_COMMIT_HASH = "f65ab0bdfcce7980fdc48cb5b1b46e8bd48f54cd"

    #BEGIN_CLASS_HEADER
    # Class variables and functions can be defined in this block
    #END_CLASS_HEADER

    # config contains contents of config file in a hash or None if it couldn't
    # be found
    def __init__(self, config):
        #BEGIN_CONSTRUCTOR

        # Any configuration parameters that are important should be parsed and
        # saved in the constructor.
        # self.callback_url = os.environ['SDK_CALLBACK_URL']
        self.shared_folder = config['scratch']
        self.cfg = config

        #END_CONSTRUCTOR
        pass


    def check_job(self, ctx, job_id):
        """
        Check if a job is finished and get results/error
        :param job_id: instance of type "job_id" (A job id.)
        :returns: instance of type "JobState" (job_id - id of job running
           method finished - indicates whether job is done (including
           error/cancel cases) or not, if the value is true then either of
           'returned_data' or 'detailed_error' should be defined; ujs_url -
           url of UserAndJobState service used by job service status - tuple
           returned by UserAndJobState.get_job_status method result - keeps
           exact copy of what original server method puts in result block of
           JSON RPC response; error - keeps exact copy of what original
           server method puts in error block of JSON RPC response; job_state
           - 'queued', 'in-progress', 'completed', or 'suspend'; position -
           position of the job in execution waiting queue; creation_time,
           exec_start_time and finish_time - time moments of submission,
           execution start and finish events in milliseconds since Unix
           Epoch, canceled - whether the job is canceled or not. cancelled -
           Deprecated field, please use 'canceled' field instead.) ->
           structure: parameter "job_id" of String, parameter "finished" of
           type "boolean" (@range [0,1]), parameter "ujs_url" of String,
           parameter "status" of unspecified object, parameter "result" of
           unspecified object, parameter "error" of type "JsonRpcError"
           (Error block of JSON RPC response) -> structure: parameter "name"
           of String, parameter "code" of Long, parameter "message" of
           String, parameter "error" of String, parameter "job_state" of
           String, parameter "position" of Long, parameter "creation_time" of
           Long, parameter "exec_start_time" of Long, parameter "finish_time"
           of Long, parameter "cancelled" of type "boolean" (@range [0,1]),
           parameter "canceled" of type "boolean" (@range [0,1]), parameter
           "sub_jobs" of unspecified object
        """
        # ctx is the context object
        # return variables are: job_state
        #BEGIN check_job
        mocker = StateMocker(self.cfg, ctx['token'])
        job_state = mocker.check_job(job_id)
        #END check_job

        # At some point might do deeper type checking...
        if not isinstance(job_state, dict):
            raise ValueError('Method check_job return value ' +
                             'job_state is not type dict as required.')
        # return the results
        return [job_state]

    def check_jobs(self, ctx, params):
        """
        :param params: instance of type "CheckJobsParams" -> structure:
           parameter "job_ids" of list of type "job_id" (A job id.),
           parameter "with_job_params" of type "boolean" (@range [0,1])
        :returns: instance of type "CheckJobsResults" (job_states - states of
           jobs, job_params - parameters of jobs, check_error - this map
           includes info about errors happening during job checking.) ->
           structure: parameter "job_states" of mapping from type "job_id" (A
           job id.) to type "JobState" (job_id - id of job running method
           finished - indicates whether job is done (including error/cancel
           cases) or not, if the value is true then either of 'returned_data'
           or 'detailed_error' should be defined; ujs_url - url of
           UserAndJobState service used by job service status - tuple
           returned by UserAndJobState.get_job_status method result - keeps
           exact copy of what original server method puts in result block of
           JSON RPC response; error - keeps exact copy of what original
           server method puts in error block of JSON RPC response; job_state
           - 'queued', 'in-progress', 'completed', or 'suspend'; position -
           position of the job in execution waiting queue; creation_time,
           exec_start_time and finish_time - time moments of submission,
           execution start and finish events in milliseconds since Unix
           Epoch, canceled - whether the job is canceled or not. cancelled -
           Deprecated field, please use 'canceled' field instead.) ->
           structure: parameter "job_id" of String, parameter "finished" of
           type "boolean" (@range [0,1]), parameter "ujs_url" of String,
           parameter "status" of unspecified object, parameter "result" of
           unspecified object, parameter "error" of type "JsonRpcError"
           (Error block of JSON RPC response) -> structure: parameter "name"
           of String, parameter "code" of Long, parameter "message" of
           String, parameter "error" of String, parameter "job_state" of
           String, parameter "position" of Long, parameter "creation_time" of
           Long, parameter "exec_start_time" of Long, parameter "finish_time"
           of Long, parameter "cancelled" of type "boolean" (@range [0,1]),
           parameter "canceled" of type "boolean" (@range [0,1]), parameter
           "sub_jobs" of unspecified object, parameter "job_params" of
           mapping from type "job_id" (A job id.) to type "RunJobParams"
           (method - service defined in standard JSON RPC way, typically it's
           module name from spec-file followed by '.' and name of funcdef
           from spec-file corresponding to running method (e.g.
           'KBaseTrees.construct_species_tree' from trees service); params -
           the parameters of the method that performed this call; Optional
           parameters: service_ver - specific version of deployed service,
           last version is used if this parameter is not defined rpc_context
           - context of current method call including nested call history
           remote_url - run remote service call instead of local command line
           execution. source_ws_objects - denotes the workspace objects that
           will serve as a source of data when running the SDK method. These
           references will be added to the autogenerated provenance. app_id -
           the id of the Narrative application running this job (e.g.
           repo/name) mapping<string, string> meta - user defined metadata to
           associate with the job. This data is passed to the User and Job
           State (UJS) service. wsid - a workspace id to associate with the
           job. This is passed to the UJS service, which will share the job
           based on the permissions of the workspace rather than UJS ACLs.)
           -> structure: parameter "method" of String, parameter "params" of
           list of unspecified object, parameter "service_ver" of String,
           parameter "rpc_context" of type "RpcContext" (call_stack -
           upstream calls details including nested service calls and parent
           jobs where calls are listed in order from outer to inner.) ->
           structure: parameter "call_stack" of list of type "MethodCall"
           (time - the time the call was started; method - service defined in
           standard JSON RPC way, typically it's module name from spec-file
           followed by '.' and name of funcdef from spec-file corresponding
           to running method (e.g. 'KBaseTrees.construct_species_tree' from
           trees service); job_id - job id if method is asynchronous
           (optional field).) -> structure: parameter "time" of type
           "timestamp" (A time in the format YYYY-MM-DDThh:mm:ssZ, where Z is
           either the character Z (representing the UTC timezone) or the
           difference in time to UTC in the format +/-HHMM, eg:
           2012-12-17T23:24:06-0500 (EST time) 2013-04-03T08:56:32+0000 (UTC
           time) 2013-04-03T08:56:32Z (UTC time)), parameter "method" of
           String, parameter "job_id" of type "job_id" (A job id.), parameter
           "run_id" of String, parameter "remote_url" of String, parameter
           "source_ws_objects" of list of type "wsref" (A workspace object
           reference of the form X/Y/Z, where X is the workspace name or id,
           Y is the object name or id, Z is the version, which is optional.),
           parameter "app_id" of String, parameter "meta" of mapping from
           String to String, parameter "wsid" of Long, parameter
           "check_error" of mapping from type "job_id" (A job id.) to type
           "JsonRpcError" (Error block of JSON RPC response) -> structure:
           parameter "name" of String, parameter "code" of Long, parameter
           "message" of String, parameter "error" of String
        """
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN check_jobs
        mocker = StateMocker(self.cfg, ctx['token'])
        get_params = True if params.get('with_job_params', 0) == 1 else False
        returnVal = mocker.check_jobs(params['job_ids'], get_params)
        #END check_jobs

        # At some point might do deeper type checking...
        if not isinstance(returnVal, dict):
            raise ValueError('Method check_jobs return value ' +
                             'returnVal is not type dict as required.')
        # return the results
        return [returnVal]
    def status(self, ctx):
        #BEGIN_STATUS
        returnVal = {'state': "OK",
                     'message': "",
                     'version': self.VERSION,
                     'git_url': self.GIT_URL,
                     'git_commit_hash': self.GIT_COMMIT_HASH}
        #END_STATUS
        return [returnVal]
