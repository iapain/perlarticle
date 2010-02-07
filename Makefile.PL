# IMPORTANT: if you delete this file your app will not work as
# expected.  you have been warned
use inc::Module::Install;

name 'Publishr';
all_from 'lib/Publishr.pm';

requires 'Catalyst::Runtime' => '5.80007';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::View::JSON';
requires 'parent';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

catalyst;

requires (
        'Catalyst::Plugin::Authentication' => '0',
        'Catalyst::Plugin::Session' => '0',
        'Catalyst::Plugin::Session::Store::FastMmap' => '0',
        'Catalyst::Plugin::Session::State::Cookie' => '0',
);

install_script glob('script/*.pl');
auto_install;
WriteAll;
