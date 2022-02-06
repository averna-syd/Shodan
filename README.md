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

my $host = $shodan.host(ip => '8.8.8.8');

my $scan = $shodan.scan(
                           ips     => '8.8.8.8,1.1.1.1',
                           service => [[53, 'dns-udp'], [443, 'https']]
                       );

my $alert = $shodan.alert-create(
                                    name    => 'test',
                                    filters => {
                                                   ip => ['1.1.1.1', '8.8.8.8']
                                               },
                                    expires => 60
                                );

my $notifiers = $shodan.notifiers();

my $queries = $shodan.queries();

my $dns = $shodan.dns-domain(
                                domain  => 'google.com',
                                history => True,
                                type    => 'A',
                                page    => 1
                            );

my $headers = $shodan.tools-http-headers();

my $exploit = $shodan.exploit-count(query => '2011-0349');

$shodan.stream-alerts(callback => {say $_; done;});
```

REST API METHODS
----------------

Interface for the [Shodan REST API](https://developer.shodan.io/api).

### Search Methods

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Returns all services that have been found on the given host IP.
# Params:
# ip: [Str] Host IP address.
# history (optional): [Bool] Show all history (default: False).
# minify (optional): [Bool] Only return list of ports & host info (default: False).
$shodan.host(ip => '8.8.8.8');
$shodan.host(ip => '8.8.8.8', history => True, minify => True);

# Same as .host method except only returns the total number of results.
# Params:
# query: [Str] Shodan search query.
# facets (optional): [Str] Comma-separated list of properties to get info on.
$shodan.host-count(query => 'port:22');
$shodan.host-count(query => 'port:22', facets => 'org,os');

# Search Shodan, same query syntax as website. Use facets to get summary info.
# Params:
# query: [Str] Shodan search query.
# facets (optional): [Str] Comma-separated list of properties to get info on.
# page (optional): [UInt] Page num to page through results 100 per page (default: 1).
# minify (optional): [Bool] Whether or not to truncate larger fields (default: True).
$shodan.host-search(query => 'port:22');
$shodan.host-search(query => 'port:22', facets => 'org,os', page => 2, minify => True);

# Returns a list of facets to get a breakdown of the top values for a property.
$shodan.host-search-facets();

# Returns a list of search filters that can be used in the search query.
$shodan.host-search-filters();

# Shows which filters are used by query str & what params were provided to filters.
$shodan.search-tokens(query => 'Raspbian port:22');
```

### On-Demand Scanning

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Returns a list of port numbers that the crawlers are looking for.
$shodan.ports();

# List protocols that can be used with on-demand Internet scans via Shodan.
$shodan.protocols();

# Request Shodan to crawl a network.
# Params:
# ips: [Str] A comma-separated list of IPs or netblocks (CIDR) to get crawled.
# service (optional): [Array] List services to be scanned.
$shodan.scan(ips => '8.8.8.8,1.1.1.1');
$shodan.scan(ips => '8.8.8.8,1.1.1.1', service => [[53, 'dns-udp'], [443, 'https']]);

# Request Shodan to crawl the Internet for a specific port.
# Requires enterprise account.
# Params:
# port: [UInt] Port that Shodan should crawl the Internet for.
# protocol: [Str] Name of protocol to be used to interrogate the port.
$shodan.scan-internet(port => 80, protocol => 'http');

# Returns a list of all the scans that are currently active on the account.
$shodan.scans();

# Check the progress of a previously submitted scan request.
# Possible values for the status are: SUBMITTING, QUEUE, PROCESSING, DONE
# Params:
# id: [Str] The unique scan ID that was returned by /shodan/scan.
$shodan.scan-status(id => $scan-id);
```

### Network Alerts

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Create an alert to monitor a network range.
# Params:
# name: [Str] The name to describe the network alert.
# filters: [Hash] Specifying the criteria that an alert should trigger.
# filters{ip}: [Array] List of IPs or CIDR.
# expires (optional): [UInt] Number of seconds that the alert should be active.
my $alert = $shodan.alert-create(
                                    name    => 'test',
                                    filters => {
                                                   ip => ['1.1.1.1', '8.8.8.8']
                                               },
                                    expires => 60
                                );

# Get the details for a network alert.
# Params:
# id: [Str] Alert ID.
$shodan.alert-info(id => $alert{'id'});

# Update the networks monitored in an alert.
# Params:
# id: [Str] Alert ID.
# filters: [Hash] Specifying the criteria that an alert should trigger.
# filters{ip}: [Array] List of IPs or CIDR.
$alert{'filters'}{'ip'}[0] = '8.8.4.4';
$shodan.alert-update(id => $alert{'id'}, filters => $alert{'filters'});

# Enable a trigger to get notifications when the specified trigger is met.
# Params:
# id: [Str] Alert ID.
# trigger: [Str] Comma-separated list of trigger names.
$shodan.alert-trigger-create(id => $alert{'id'}, trigger => 'new_service,vulnerable');

# Ignore the specified service when it is matched for the trigger.
# Params:
# id: [Str] Alert ID.
# trigger: [Str] Trigger name.
# service: [Str] Service specified in the format "ip:port" (ex. "1.1.1.1:80").
$shodan.alert-trigger-service-ignore(
                                        id      => $alert{'id'},
                                        trigger => 'vulnerable',
                                        service => '1.1.1.1:80'
                                    );

# Start getting notifications again for the specified trigger.
# Params:
# id: [Str] Alert ID.
# trigger: [Str] Trigger name.
# service: [Str] Service specified in the format "ip:port" (ex. "1.1.1.1:80").
$shodan.alert-trigger-service-notify(
                                        id      => $alert{'id'},
                                        trigger => 'vulnerable',
                                        service => '1.1.1.1:80'
                                    );
# Add the notifier to the alert.
# Params:
# id: [Str] Alert ID.
# notifier-id: [Str] Notifier ID.
$shodan.alert-notifier-create(id => $alert{'id'}, notifier-id => 'default');

# Remove the notifier from the alert
# Params:
# id: [Str] Alert ID.
# notifier-id: [Str] Notifier ID.
$shodan.alert-notifier-delete(id => $alert{'id'}, notifier-id => 'default');

# Disable a trigger to stop getting notifications for the specified trigger.
# Params:
# trigger: [Str] Trigger name.
# service: [Str] Service specified in the format "ip:port" (ex. "1.1.1.1:80").
$shodan.alert-trigger-delete(id => $alert{'id'}, trigger => 'new_service,vulnerable');

# Delete an alert.
# Params:
# id: [Str] Alert ID.
$shodan.alert-delete(id => $alert{'id'});

# Returns a list of all the network alerts that are active on the account.
$shodan.alerts();

# Returns a list of all the triggers that can be enabled on network alerts.
$shodan.alert-triggers();
```

### Notifiers

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Get a list of all the notifiers that the user has created.
$shodan.notifiers();

# List of available notification providers.
$shodan.notifier-providers();

# Create a new notification service for the user.
# Params:
# provider: [Str] Provider name as returned by notifier-providers.
# description: [Str] Description of the notifier.
# args: [Hash] Arguments required by the provider.
my $notifier = $shodan.notifier-create(
                                          provider    => 'email',
                                          description => 'Email notifier',
                                          args        => {to => 'jmath@shodan.io'}
                                      );
# Get information about a notifier.
# Params:
# id: [Str] Notifier ID.
$shodan.notifier(id => $notifier{'id'});

# Update the parameters of a notifier.
# Params:
# id: [Str] Notifier ID.
# args: [Hash] Arguments required by the provider.
$shodan.notifier-update(id => $notifier{'id'}, args => {to => 'e@shodan.io'});

# Remove the notification service created for the user.
# Params:
# id: [Str] Notifier ID.
$shodan.notifier-delete(id => $notifier{'id'});
```

### Directory Methods

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# List the saved search queries.
# Params:
# page (optional): [UInt] Page number to iterate over results (10 per page).
# sort (optional): [Str] Sort the list based on a property. Possible values are: votes, timestamp.
# order (optional): [Str] Whether to sort the list in ascending or descending order. Possible values are: asc, desc.
$shodan.queries();
$shodan.queries(page => 1, sort => 'timestamp', order => 'asc');

# Search the directory of saved search queries.
# Params:
# query: [Str] What to search for in the directory of saved search queries.
# page (optional): [UInt] Page number to iterate over results (10 per page).
$shodan.query-search(query => 'webcam');
$shodan.query-search(query => 'webcam', page => 1);

# List the most popular tags.
# Params:
# size (optional): [UInt] The number of tags to return (default: 10).
$shodan.query-tags();
$shodan.query-tags(size => 10);
```

### Bulk Data

Requires enterprise account.

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Get a list of available datasets.
$shodan.data();

# List the files for a dataset.
# Params:
# dataset: [Str] Name of the dataset.
$shodan.data-dataset();
```

### Manage Organization

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Get information about your organization.
$shodan.org();

# Add a Shodan user to the organization.
# Params:
# user: [Str] Username or email of the Shodan user.
# notify (optional): [Bool] Whether or not to send an email notification.
$shodan.org-member-create(user => 'averna');

# Remove a member.
# Params:
user: [Str] Username or email of the Shodan user.
$shodan.org-member-delete(user => 'averna');
```

### Account Methods

```raku
# Returns information about the Shodan account linked to this API key.
$shodan.account-profile();
```

### DNS Methods

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Get all the subdomains and other DNS entries for the given domain.
# Params:
# domain: [Str] Domain name to lookup; example "cnn.com".
# history (optional): [Bool] Show historical DNS data (default: False).
# type (optional): [Str] DNS type, possible values are: A, AAAA, CNAME, NS, SOA, MX, TXT.
# page (optional): [UInt] The page number to page through results 100 at a time (default: 1).
$shodan.dns-domain(domain => 'google.com');
$shodan.dns-domain(domain => 'google.com', history => True, type => 'A', page => 1);

# Look up the IP address for the provided list of hostnames.
# Params:
# hostnames: [Str] Comma-separated list of hostnames; example "google.com,bing.com".
$shodan.dns-resolve(hostnames => 'google.com');

# Look up the hostnames that have been defined for the given list of IP addresses.
# Params:
# ips: [Str] Comma-separated list of IP addresses; example "74.125.227.230,204.79.197.200".
$shodan.dns-reverse(ips => '8.8.8.8');
```

### Utility Methods

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Shows the HTTP headers that your client sends when connecting to a webserver.
$shodan.tools-http-headers();

# Get your current IP address as seen from the Internet.
$shodan.tools-myip();
```

### API Status Methods

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Returns information about the API plan belonging to the given API key.
$shodan.api-info();
```

See [Shodan::API::REST](https://github.com/averna-syd/Shodan/blob/main/README_REST_API.md) readme for more information.

EXPLOIT API METHODS
-------------------

Interface for the [Shodan Exploit API](https://developer.shodan.io/api/exploits/rest).

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Search across a variety of data sources for exploits and use facets to get summary information.
# Params:
# query: [Str] Search the database of known exploits. See https://developer.shodan.io/api/exploits/rest for list.
# facets (optional): [Str] A comma-separated list of properties to get summary info on. See https://developer.shodan.io/api/exploits/rest for list.
# page (optional): [UInt] The page number to page through results 100 at a time.
$shodan.exploit-search(query => '2011-0349');

# Search for Exploits without Results.
# Params:
# query: [Str] Search the database of known exploits. See https://developer.shodan.io/api/exploits/rest for list.
# facets (optional): [Str] A comma-separated list of properties to get summary info on. See https://developer.shodan.io/api/exploits/rest for list.
# page (optional): [UInt] The page number to page through results 100 at a time.
$shodan.exploit-count(query => '2011-0349');
```

See [Shodan::API::Exploit](https://github.com/averna-syd/Shodan/blob/main/README_EXPLOIT_API.md) readme for more information.

STREAM API METHODS
------------------

Interface for the [Shodan Streaming API](https://developer.shodan.io/api/stream).

### Data Streams

Requires enterprise account.

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# This stream provides ALL of the data that Shodan collects.
# Params:
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-banners(callback => {say $_; done;});

# Filtered by ASN.
# Params:
# asn: [Str] Comma-separated list of ASNs; example "3303,32475".
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-asn(asn => '3303,32475', callback => {say $_; done;});

# Filtered by Country.
# Params:
# countries: [Str] Comma-separated list of countries indicated by their 2 letter code; example "DE,US".
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-countries(countries => 'DE,US', callback => {say $_; done;});

# Filtered by Ports.
# Params:
# ports: [Str] Comma-separated list of ports; example "22,443".
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-ports(ports => '22,443', callback => {say $_; done;});

# Filtered by Vulnerabilities.
# Params:
# vulns: [Str] Comma-separated list of case-insensitive vulns; example: "CVE-2017-7679,CVE-2018-15919".
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-vulns(vulns => 'CVE-2017-7679,CVE-2018-15919', callback => {say $_; done;});

# Filtered by Query
# Params:
# query: [Str] Space-separated list of key:value filters examplei: "port:22 SSH-2.0-OpenSSH_6.4"
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-custom(query => 'port:22 SSH-2.0-OpenSSH_6.4', callback => {say $_; done;});
```

### Network Alerts

```raku
my $shodan = Shodan.new(api-key => %*ENV{'SHODAN_API_KEY'});

# Subscribe to banners discovered on all IP ranges described in the network alerts.
# Params:
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-alerts(callback => {my $alert = $_; done;});

# Subscribe to banners discovered on the IP range defined in a specific network alert.
# Params:
# id: [Str] The unique ID of the network alert; example "OYPRB8IR9Z35AZPR".
# callback: [code] Code that's run within stream & passed stream data.
$shodan.stream-alert(id => 'ZLN92ZK9IHS22SDX', callback => {my $alert = $_; done;});
```

See [Shodan::API::Stream](https://github.com/averna-syd/Shodan/blob/main/README_STREAM_API.md) readme for more information.

DISCLAIMER
----------

This is an early version thus methods maybe subject to change. The author does not have access to an enterprise account. Therefore while ever effort was made to ensure enterprise method calls are correct, without adequate testing of enterprise calls the author can not be as confident when compared to method calls which can be adequately tested.

AUTHOR
======

"Sarah Fuller", `<"sarah at averna . id . au"> `

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Sarah Fuller

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

