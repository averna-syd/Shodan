NAME
====

Shodan

DESCRIPTION
===========

A [raku-lang](https://raku.org/) client for [Shodan](https://www.shodan.io/), a search engine for Internet-connected devices. This client provides an interface for the [Shodan API](https://developer.shodan.io).

SYNOPSIS
========

```raku
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
```

REST API METHODS
----------------

[SEE Shodan::API::REST README](https://github.com/averna-syd/Shodan/blob/main/README_REST_API.md)

EXPLOIT API METHODS
-------------------

[SEE Shodan::API::Exploit README](https://github.com/averna-syd/Shodan/blob/main/README_EXPLOIT_API.md)

STREAM API METHODS
------------------

[SEE Shodan::API::Stream README](https://github.com/averna-syd/Shodan/blob/main/README_STREAM_API.md)

AUTHOR
======

"Sarah Fuller", `<"sarah at averna . id . au"> `

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Sarah Fuller

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

