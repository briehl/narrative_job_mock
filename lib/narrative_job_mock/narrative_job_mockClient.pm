package narrative_job_mock::narrative_job_mockClient;

use JSON::RPC::Client;
use POSIX;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
my $get_time = sub { time, 0 };
eval {
    require Time::HiRes;
    $get_time = sub { Time::HiRes::gettimeofday() };
};

use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

narrative_job_mock::narrative_job_mockClient

=head1 DESCRIPTION


A KBase module: narrative_job_mock


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => narrative_job_mock::narrative_job_mockClient::RpcClient->new,
	url => $url,
	headers => [],
    };

    chomp($self->{hostname} = `hostname`);
    $self->{hostname} ||= 'unknown-host';

    #
    # Set up for propagating KBRPC_TAG and KBRPC_METADATA environment variables through
    # to invoked services. If these values are not set, we create a new tag
    # and a metadata field with basic information about the invoking script.
    #
    if ($ENV{KBRPC_TAG})
    {
	$self->{kbrpc_tag} = $ENV{KBRPC_TAG};
    }
    else
    {
	my ($t, $us) = &$get_time();
	$us = sprintf("%06d", $us);
	my $ts = strftime("%Y-%m-%dT%H:%M:%S.${us}Z", gmtime $t);
	$self->{kbrpc_tag} = "C:$0:$self->{hostname}:$$:$ts";
    }
    push(@{$self->{headers}}, 'Kbrpc-Tag', $self->{kbrpc_tag});

    if ($ENV{KBRPC_METADATA})
    {
	$self->{kbrpc_metadata} = $ENV{KBRPC_METADATA};
	push(@{$self->{headers}}, 'Kbrpc-Metadata', $self->{kbrpc_metadata});
    }

    if ($ENV{KBRPC_ERROR_DEST})
    {
	$self->{kbrpc_error_dest} = $ENV{KBRPC_ERROR_DEST};
	push(@{$self->{headers}}, 'Kbrpc-Errordest', $self->{kbrpc_error_dest});
    }

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my %arg_hash2 = @args;
	if (exists $arg_hash2{"token"}) {
	    $self->{token} = $arg_hash2{"token"};
	} elsif (exists $arg_hash2{"user_id"}) {
	    my $token = Bio::KBase::AuthToken->new(@args);
	    if (!$token->error_message) {
	        $self->{token} = $token->token;
	    }
	}
	
	if (exists $self->{token})
	{
	    $self->{client}->{token} = $self->{token};
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




=head2 check_job

  $job_state = $obj->check_job($job_id)

=over 4

=item Parameter and return types

=begin html

<pre>
$job_id is a narrative_job_mock.job_id
$job_state is a narrative_job_mock.JobState
job_id is a string
JobState is a reference to a hash where the following keys are defined:
	job_id has a value which is a string
	finished has a value which is a narrative_job_mock.boolean
	ujs_url has a value which is a string
	status has a value which is an UnspecifiedObject, which can hold any non-null object
	result has a value which is an UnspecifiedObject, which can hold any non-null object
	error has a value which is a narrative_job_mock.JsonRpcError
	job_state has a value which is a string
	position has a value which is an int
	creation_time has a value which is an int
	exec_start_time has a value which is an int
	finish_time has a value which is an int
	cancelled has a value which is a narrative_job_mock.boolean
	canceled has a value which is a narrative_job_mock.boolean
boolean is an int
JsonRpcError is a reference to a hash where the following keys are defined:
	name has a value which is a string
	code has a value which is an int
	message has a value which is a string
	error has a value which is a string

</pre>

=end html

=begin text

$job_id is a narrative_job_mock.job_id
$job_state is a narrative_job_mock.JobState
job_id is a string
JobState is a reference to a hash where the following keys are defined:
	job_id has a value which is a string
	finished has a value which is a narrative_job_mock.boolean
	ujs_url has a value which is a string
	status has a value which is an UnspecifiedObject, which can hold any non-null object
	result has a value which is an UnspecifiedObject, which can hold any non-null object
	error has a value which is a narrative_job_mock.JsonRpcError
	job_state has a value which is a string
	position has a value which is an int
	creation_time has a value which is an int
	exec_start_time has a value which is an int
	finish_time has a value which is an int
	cancelled has a value which is a narrative_job_mock.boolean
	canceled has a value which is a narrative_job_mock.boolean
boolean is an int
JsonRpcError is a reference to a hash where the following keys are defined:
	name has a value which is a string
	code has a value which is an int
	message has a value which is a string
	error has a value which is a string


=end text

=item Description

Check if a job is finished and get results/error

=back

=cut

 sub check_job
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function check_job (received $n, expecting 1)");
    }
    {
	my($job_id) = @args;

	my @_bad_arguments;
        (!ref($job_id)) or push(@_bad_arguments, "Invalid type for argument 1 \"job_id\" (value was \"$job_id\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to check_job:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'check_job');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "narrative_job_mock.check_job",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'check_job',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method check_job",
					    status_line => $self->{client}->status_line,
					    method_name => 'check_job',
				       );
    }
}
 


=head2 check_jobs

  $return = $obj->check_jobs($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a narrative_job_mock.CheckJobsParams
$return is a narrative_job_mock.CheckJobsResults
CheckJobsParams is a reference to a hash where the following keys are defined:
	job_ids has a value which is a reference to a list where each element is a narrative_job_mock.job_id
	with_job_params has a value which is a narrative_job_mock.boolean
job_id is a string
boolean is an int
CheckJobsResults is a reference to a hash where the following keys are defined:
	job_states has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JobState
	job_params has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.RunJobParams
	check_error has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JsonRpcError
JobState is a reference to a hash where the following keys are defined:
	job_id has a value which is a string
	finished has a value which is a narrative_job_mock.boolean
	ujs_url has a value which is a string
	status has a value which is an UnspecifiedObject, which can hold any non-null object
	result has a value which is an UnspecifiedObject, which can hold any non-null object
	error has a value which is a narrative_job_mock.JsonRpcError
	job_state has a value which is a string
	position has a value which is an int
	creation_time has a value which is an int
	exec_start_time has a value which is an int
	finish_time has a value which is an int
	cancelled has a value which is a narrative_job_mock.boolean
	canceled has a value which is a narrative_job_mock.boolean
JsonRpcError is a reference to a hash where the following keys are defined:
	name has a value which is a string
	code has a value which is an int
	message has a value which is a string
	error has a value which is a string
RunJobParams is a reference to a hash where the following keys are defined:
	method has a value which is a string
	params has a value which is a reference to a list where each element is an UnspecifiedObject, which can hold any non-null object
	service_ver has a value which is a string
	rpc_context has a value which is a narrative_job_mock.RpcContext
	remote_url has a value which is a string
	source_ws_objects has a value which is a reference to a list where each element is a narrative_job_mock.wsref
	app_id has a value which is a string
	meta has a value which is a reference to a hash where the key is a string and the value is a string
	wsid has a value which is an int
RpcContext is a reference to a hash where the following keys are defined:
	call_stack has a value which is a reference to a list where each element is a narrative_job_mock.MethodCall
	run_id has a value which is a string
MethodCall is a reference to a hash where the following keys are defined:
	time has a value which is a narrative_job_mock.timestamp
	method has a value which is a string
	job_id has a value which is a narrative_job_mock.job_id
timestamp is a string
wsref is a string

</pre>

=end html

=begin text

$params is a narrative_job_mock.CheckJobsParams
$return is a narrative_job_mock.CheckJobsResults
CheckJobsParams is a reference to a hash where the following keys are defined:
	job_ids has a value which is a reference to a list where each element is a narrative_job_mock.job_id
	with_job_params has a value which is a narrative_job_mock.boolean
job_id is a string
boolean is an int
CheckJobsResults is a reference to a hash where the following keys are defined:
	job_states has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JobState
	job_params has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.RunJobParams
	check_error has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JsonRpcError
JobState is a reference to a hash where the following keys are defined:
	job_id has a value which is a string
	finished has a value which is a narrative_job_mock.boolean
	ujs_url has a value which is a string
	status has a value which is an UnspecifiedObject, which can hold any non-null object
	result has a value which is an UnspecifiedObject, which can hold any non-null object
	error has a value which is a narrative_job_mock.JsonRpcError
	job_state has a value which is a string
	position has a value which is an int
	creation_time has a value which is an int
	exec_start_time has a value which is an int
	finish_time has a value which is an int
	cancelled has a value which is a narrative_job_mock.boolean
	canceled has a value which is a narrative_job_mock.boolean
JsonRpcError is a reference to a hash where the following keys are defined:
	name has a value which is a string
	code has a value which is an int
	message has a value which is a string
	error has a value which is a string
RunJobParams is a reference to a hash where the following keys are defined:
	method has a value which is a string
	params has a value which is a reference to a list where each element is an UnspecifiedObject, which can hold any non-null object
	service_ver has a value which is a string
	rpc_context has a value which is a narrative_job_mock.RpcContext
	remote_url has a value which is a string
	source_ws_objects has a value which is a reference to a list where each element is a narrative_job_mock.wsref
	app_id has a value which is a string
	meta has a value which is a reference to a hash where the key is a string and the value is a string
	wsid has a value which is an int
RpcContext is a reference to a hash where the following keys are defined:
	call_stack has a value which is a reference to a list where each element is a narrative_job_mock.MethodCall
	run_id has a value which is a string
MethodCall is a reference to a hash where the following keys are defined:
	time has a value which is a narrative_job_mock.timestamp
	method has a value which is a string
	job_id has a value which is a narrative_job_mock.job_id
timestamp is a string
wsref is a string


=end text

=item Description



=back

=cut

 sub check_jobs
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function check_jobs (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to check_jobs:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'check_jobs');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "narrative_job_mock.check_jobs",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'check_jobs',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method check_jobs",
					    status_line => $self->{client}->status_line,
					    method_name => 'check_jobs',
				       );
    }
}
 


=head2 filter_contigs

  $output = $obj->filter_contigs($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a narrative_job_mock.FilterContigsParams
$output is a narrative_job_mock.FilterContigsResults
FilterContigsParams is a reference to a hash where the following keys are defined:
	assembly_input_ref has a value which is a narrative_job_mock.assembly_ref
	workspace_name has a value which is a string
	min_length has a value which is an int
assembly_ref is a string
FilterContigsResults is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string
	assembly_output has a value which is a narrative_job_mock.assembly_ref
	n_initial_contigs has a value which is an int
	n_contigs_removed has a value which is an int
	n_contigs_remaining has a value which is an int

</pre>

=end html

=begin text

$params is a narrative_job_mock.FilterContigsParams
$output is a narrative_job_mock.FilterContigsResults
FilterContigsParams is a reference to a hash where the following keys are defined:
	assembly_input_ref has a value which is a narrative_job_mock.assembly_ref
	workspace_name has a value which is a string
	min_length has a value which is an int
assembly_ref is a string
FilterContigsResults is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string
	assembly_output has a value which is a narrative_job_mock.assembly_ref
	n_initial_contigs has a value which is an int
	n_contigs_removed has a value which is an int
	n_contigs_remaining has a value which is an int


=end text

=item Description

The actual function is declared using 'funcdef' to specify the name
and input/return arguments to the function.  For all typical KBase
Apps that run in the Narrative, your function should have the
'authentication required' modifier.

=back

=cut

 sub filter_contigs
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function filter_contigs (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to filter_contigs:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'filter_contigs');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "narrative_job_mock.filter_contigs",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'filter_contigs',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method filter_contigs",
					    status_line => $self->{client}->status_line,
					    method_name => 'filter_contigs',
				       );
    }
}
 
  
sub status
{
    my($self, @args) = @_;
    if ((my $n = @args) != 0) {
        Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
                                   "Invalid argument count for function status (received $n, expecting 0)");
    }
    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
        method => "narrative_job_mock.status",
        params => \@args,
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
                           code => $result->content->{error}->{code},
                           method_name => 'status',
                           data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
                          );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method status",
                        status_line => $self->{client}->status_line,
                        method_name => 'status',
                       );
    }
}
   

sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
        method => "narrative_job_mock.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'filter_contigs',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method filter_contigs",
            status_line => $self->{client}->status_line,
            method_name => 'filter_contigs',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for narrative_job_mock::narrative_job_mockClient\n";
    }
    if ($sMajor == 0) {
        warn "narrative_job_mock::narrative_job_mockClient version is $svr_version. API subject to change.\n";
    }
}

=head1 TYPES



=head2 boolean

=over 4



=item Description

@range [0,1]


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 timestamp

=over 4



=item Description

A time in the format YYYY-MM-DDThh:mm:ssZ, where Z is either the
character Z (representing the UTC timezone) or the difference
in time to UTC in the format +/-HHMM, eg:
    2012-12-17T23:24:06-0500 (EST time)
    2013-04-03T08:56:32+0000 (UTC time)
    2013-04-03T08:56:32Z (UTC time)


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 job_id

=over 4



=item Description

A job id.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 wsref

=over 4



=item Description

A workspace object reference of the form X/Y/Z, where
X is the workspace name or id,
Y is the object name or id,
Z is the version, which is optional.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 JsonRpcError

=over 4



=item Description

Error block of JSON RPC response


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
name has a value which is a string
code has a value which is an int
message has a value which is a string
error has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
name has a value which is a string
code has a value which is an int
message has a value which is a string
error has a value which is a string


=end text

=back



=head2 MethodCall

=over 4



=item Description

time - the time the call was started;
method - service defined in standard JSON RPC way, typically it's
    module name from spec-file followed by '.' and name of funcdef
    from spec-file corresponding to running method (e.g.
    'KBaseTrees.construct_species_tree' from trees service);
job_id - job id if method is asynchronous (optional field).


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
time has a value which is a narrative_job_mock.timestamp
method has a value which is a string
job_id has a value which is a narrative_job_mock.job_id

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
time has a value which is a narrative_job_mock.timestamp
method has a value which is a string
job_id has a value which is a narrative_job_mock.job_id


=end text

=back



=head2 RpcContext

=over 4



=item Description

call_stack - upstream calls details including nested service calls and
    parent jobs where calls are listed in order from outer to inner.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
call_stack has a value which is a reference to a list where each element is a narrative_job_mock.MethodCall
run_id has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
call_stack has a value which is a reference to a list where each element is a narrative_job_mock.MethodCall
run_id has a value which is a string


=end text

=back



=head2 RunJobParams

=over 4



=item Description

method - service defined in standard JSON RPC way, typically it's
    module name from spec-file followed by '.' and name of funcdef
    from spec-file corresponding to running method (e.g.
    'KBaseTrees.construct_species_tree' from trees service);
params - the parameters of the method that performed this call;

Optional parameters:
service_ver - specific version of deployed service, last version is
    used if this parameter is not defined
rpc_context - context of current method call including nested call
    history
remote_url - run remote service call instead of local command line
    execution.
source_ws_objects - denotes the workspace objects that will serve as a
    source of data when running the SDK method. These references will
    be added to the autogenerated provenance.
app_id - the id of the Narrative application running this job (e.g.
    repo/name)
mapping<string, string> meta - user defined metadata to associate with
    the job. This data is passed to the User and Job State (UJS)
    service.
wsid - a workspace id to associate with the job. This is passed to the
    UJS service, which will share the job based on the permissions of
    the workspace rather than UJS ACLs.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
method has a value which is a string
params has a value which is a reference to a list where each element is an UnspecifiedObject, which can hold any non-null object
service_ver has a value which is a string
rpc_context has a value which is a narrative_job_mock.RpcContext
remote_url has a value which is a string
source_ws_objects has a value which is a reference to a list where each element is a narrative_job_mock.wsref
app_id has a value which is a string
meta has a value which is a reference to a hash where the key is a string and the value is a string
wsid has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
method has a value which is a string
params has a value which is a reference to a list where each element is an UnspecifiedObject, which can hold any non-null object
service_ver has a value which is a string
rpc_context has a value which is a narrative_job_mock.RpcContext
remote_url has a value which is a string
source_ws_objects has a value which is a reference to a list where each element is a narrative_job_mock.wsref
app_id has a value which is a string
meta has a value which is a reference to a hash where the key is a string and the value is a string
wsid has a value which is an int


=end text

=back



=head2 JobState

=over 4



=item Description

job_id - id of job running method
finished - indicates whether job is done (including error/cancel cases) or not,
    if the value is true then either of 'returned_data' or 'detailed_error'
    should be defined;
ujs_url - url of UserAndJobState service used by job service
status - tuple returned by UserAndJobState.get_job_status method
result - keeps exact copy of what original server method puts
    in result block of JSON RPC response;
error - keeps exact copy of what original server method puts
    in error block of JSON RPC response;
job_state - 'queued', 'in-progress', 'completed', or 'suspend';
position - position of the job in execution waiting queue;
creation_time, exec_start_time and finish_time - time moments of submission, execution
    start and finish events in milliseconds since Unix Epoch,
canceled - whether the job is canceled or not.
cancelled - Deprecated field, please use 'canceled' field instead.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
job_id has a value which is a string
finished has a value which is a narrative_job_mock.boolean
ujs_url has a value which is a string
status has a value which is an UnspecifiedObject, which can hold any non-null object
result has a value which is an UnspecifiedObject, which can hold any non-null object
error has a value which is a narrative_job_mock.JsonRpcError
job_state has a value which is a string
position has a value which is an int
creation_time has a value which is an int
exec_start_time has a value which is an int
finish_time has a value which is an int
cancelled has a value which is a narrative_job_mock.boolean
canceled has a value which is a narrative_job_mock.boolean

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
job_id has a value which is a string
finished has a value which is a narrative_job_mock.boolean
ujs_url has a value which is a string
status has a value which is an UnspecifiedObject, which can hold any non-null object
result has a value which is an UnspecifiedObject, which can hold any non-null object
error has a value which is a narrative_job_mock.JsonRpcError
job_state has a value which is a string
position has a value which is an int
creation_time has a value which is an int
exec_start_time has a value which is an int
finish_time has a value which is an int
cancelled has a value which is a narrative_job_mock.boolean
canceled has a value which is a narrative_job_mock.boolean


=end text

=back



=head2 CheckJobsParams

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
job_ids has a value which is a reference to a list where each element is a narrative_job_mock.job_id
with_job_params has a value which is a narrative_job_mock.boolean

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
job_ids has a value which is a reference to a list where each element is a narrative_job_mock.job_id
with_job_params has a value which is a narrative_job_mock.boolean


=end text

=back



=head2 CheckJobsResults

=over 4



=item Description

job_states - states of jobs,
job_params - parameters of jobs,
check_error - this map includes info about errors happening during job checking.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
job_states has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JobState
job_params has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.RunJobParams
check_error has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JsonRpcError

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
job_states has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JobState
job_params has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.RunJobParams
check_error has a value which is a reference to a hash where the key is a narrative_job_mock.job_id and the value is a narrative_job_mock.JsonRpcError


=end text

=back



=head2 assembly_ref

=over 4



=item Description

A 'typedef' allows you to provide a more specific name for
a type.  Built-in primitive types include 'string', 'int',
'float'.  Here we define a type named assembly_ref to indicate
a string that should be set to a KBase ID reference to an
Assembly data object.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 FilterContigsParams

=over 4



=item Description

A 'typedef' can also be used to define compound or container
objects, like lists, maps, and structures.  The standard KBase
convention is to use structures, as shown here, to define the
input and output of your function.  Here the input is a
reference to the Assembly data object, a workspace to save
output, and a length threshold for filtering.

To define lists and maps, use a syntax similar to C++ templates
to indicate the type contained in the list or map.  For example:

    list <string> list_of_strings;
    mapping <string, int> map_of_ints;


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
assembly_input_ref has a value which is a narrative_job_mock.assembly_ref
workspace_name has a value which is a string
min_length has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
assembly_input_ref has a value which is a narrative_job_mock.assembly_ref
workspace_name has a value which is a string
min_length has a value which is an int


=end text

=back



=head2 FilterContigsResults

=over 4



=item Description

Here is the definition of the output of the function.  The output
can be used by other SDK modules which call your code, or the output
visualizations in the Narrative.  'report_name' and 'report_ref' are
special output fields- if defined, the Narrative can automatically
render your Report.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string
assembly_output has a value which is a narrative_job_mock.assembly_ref
n_initial_contigs has a value which is an int
n_contigs_removed has a value which is an int
n_contigs_remaining has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string
assembly_output has a value which is a narrative_job_mock.assembly_ref
n_initial_contigs has a value which is an int
n_contigs_removed has a value which is an int
n_contigs_remaining has a value which is an int


=end text

=back



=cut

package narrative_job_mock::narrative_job_mockClient::RpcClient;
use base 'JSON::RPC::Client';
use POSIX;
use strict;

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $headers, $obj) = @_;
    my $result;


    {
	if ($uri =~ /\?/) {
	    $result = $self->_get($uri);
	}
	else {
	    Carp::croak "not hashref." unless (ref $obj eq 'HASH');
	    $result = $self->_post($uri, $headers, $obj);
	}

    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $headers, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	@$headers,
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
