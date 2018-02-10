use strict;
use warnings;
use Plack::Builder;

my $app = sub {
    my $env = shift;
    [200, [], ["Hello world from PSGI!\n"]];
};

builder {
    enable 'ContentLength';
    $app;
};
