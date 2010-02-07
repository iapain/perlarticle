use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Publishr' }
BEGIN { use_ok 'Publishr::Controller::Dashboard' }

ok( request('/dashboard')->is_success, 'Request should succeed' );


