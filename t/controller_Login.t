use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Publishr' }
BEGIN { use_ok 'Publishr::Controller::Login' }

ok( request('/login')->is_success, 'Request should succeed' );


