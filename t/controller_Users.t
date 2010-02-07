use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Publishr' }
BEGIN { use_ok 'Publishr::Controller::Users' }

ok( request('/users')->is_success, 'Request should succeed' );


