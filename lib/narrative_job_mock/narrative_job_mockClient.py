# -*- coding: utf-8 -*-
############################################################
#
# Autogenerated by the KBase type compiler -
# any changes made here will be overwritten
#
############################################################

from __future__ import print_function
# the following is a hack to get the baseclient to import whether we're in a
# package or not. This makes pep8 unhappy hence the annotations.
try:
    # baseclient and this client are in a package
    from .baseclient import BaseClient as _BaseClient  # @UnusedImport
except:
    # no they aren't
    from baseclient import BaseClient as _BaseClient  # @Reimport


class narrative_job_mock(object):

    def __init__(
            self, url=None, timeout=30 * 60, user_id=None,
            password=None, token=None, ignore_authrc=False,
            trust_all_ssl_certificates=False,
            auth_svc='https://kbase.us/services/authorization/Sessions/Login'):
        if url is None:
            raise ValueError('A url is required')
        self._service_ver = None
        self._client = _BaseClient(
            url, timeout=timeout, user_id=user_id, password=password,
            token=token, ignore_authrc=ignore_authrc,
            trust_all_ssl_certificates=trust_all_ssl_certificates,
            auth_svc=auth_svc)

    def check_job(self, job_id, context=None):
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
           parameter "canceled" of type "boolean" (@range [0,1])
        """
        return self._client.call_method(
            'narrative_job_mock.check_job',
            [job_id], self._service_ver, context)

    def check_jobs(self, params, context=None):
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
           "job_params" of mapping from type "job_id" (A job id.) to type
           "RunJobParams" (method - service defined in standard JSON RPC way,
           typically it's module name from spec-file followed by '.' and name
           of funcdef from spec-file corresponding to running method (e.g.
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
        return self._client.call_method(
            'narrative_job_mock.check_jobs',
            [params], self._service_ver, context)

    def filter_contigs(self, params, context=None):
        """
        The actual function is declared using 'funcdef' to specify the name
        and input/return arguments to the function.  For all typical KBase
        Apps that run in the Narrative, your function should have the
        'authentication required' modifier.
        :param params: instance of type "FilterContigsParams" (A 'typedef'
           can also be used to define compound or container objects, like
           lists, maps, and structures.  The standard KBase convention is to
           use structures, as shown here, to define the input and output of
           your function.  Here the input is a reference to the Assembly data
           object, a workspace to save output, and a length threshold for
           filtering. To define lists and maps, use a syntax similar to C++
           templates to indicate the type contained in the list or map.  For
           example: list <string> list_of_strings; mapping <string, int>
           map_of_ints;) -> structure: parameter "assembly_input_ref" of type
           "assembly_ref" (A 'typedef' allows you to provide a more specific
           name for a type.  Built-in primitive types include 'string',
           'int', 'float'.  Here we define a type named assembly_ref to
           indicate a string that should be set to a KBase ID reference to an
           Assembly data object.), parameter "workspace_name" of String,
           parameter "min_length" of Long
        :returns: instance of type "FilterContigsResults" (Here is the
           definition of the output of the function.  The output can be used
           by other SDK modules which call your code, or the output
           visualizations in the Narrative.  'report_name' and 'report_ref'
           are special output fields- if defined, the Narrative can
           automatically render your Report.) -> structure: parameter
           "report_name" of String, parameter "report_ref" of String,
           parameter "assembly_output" of type "assembly_ref" (A 'typedef'
           allows you to provide a more specific name for a type.  Built-in
           primitive types include 'string', 'int', 'float'.  Here we define
           a type named assembly_ref to indicate a string that should be set
           to a KBase ID reference to an Assembly data object.), parameter
           "n_initial_contigs" of Long, parameter "n_contigs_removed" of
           Long, parameter "n_contigs_remaining" of Long
        """
        return self._client.call_method(
            'narrative_job_mock.filter_contigs',
            [params], self._service_ver, context)

    def status(self, context=None):
        return self._client.call_method('narrative_job_mock.status',
                                        [], self._service_ver, context)