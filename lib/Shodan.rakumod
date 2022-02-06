use Shodan::API;
unit class Shodan does Shodan::API;

=begin pod

=head1 NAME

Shodan

=head1 DESCRIPTION

A L<raku-lang|https://raku.org/> client for L<Shodan|https://www.shodan.io/>,
a search engine for Internet-connected devices. This client provides an
interface for the L<Shodan API|https://developer.shodan.io>.

=head1 SYNOPSIS

=begin code :lang<raku>

use Shodan;

my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

my $api-info = $shodan.api-info();
say $api-info;

my $host = $shodan.host(ip => '8.8.8.8');
say $host;

my $scan = $shodan.scan(ips => '8.8.8.8,1.1.1.1', service => [[53, 'dns-udp'], [443, 'https']]);
say $scan;

my $alert = $shodan.alert-create(name => 'test', filters => {ip => ['1.1.1.1', '8.8.8.8']}, expires => 60);
say $alert;

my $notifiers = $shodan.notifiers();
say $notifiers;

my $queries = $shodan.queries();
say $queries;

my $dns = $shodan.dns-domain(domain => 'google.com', history => True, type => 'A', page => 1);
say $dns;

my $headers = $shodan.tools-http-headers();
say $headers;

my $exploit = $shodan.exploit-count(query => '2011-0349');
say $exploit;

$shodan.stream-alerts(callback => {say $_; done;});

=end code

=head2 REST API METHODS

L<SEE Shodan::API::REST README|https://github.com/averna-syd/Shodan/blob/main/README_REST_API.md>

=head2 EXPLOIT API METHODS

L<SEE Shodan::API::Exploit README|https://github.com/averna-syd/Shodan/blob/main/README_EXPLOIT_API.md>

=head2 STREAM API METHODS

L<SEE Shodan::API::Stream README|https://github.com/averna-syd/Shodan/blob/main/README_STREAM_API.md>

=head1 AUTHOR

"Sarah Fuller", C<< <"sarah at averna . id . au"> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Sarah Fuller

This library is free software; you can redistribute it and/or modify it
under the Artistic License 2.0.

=end pod
