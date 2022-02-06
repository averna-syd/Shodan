NAME
====

Shodan::API::REST

DESCRIPTION
===========

A [raku-lang](https://raku.org/) client for [Shodan](https://www.shodan.io/), a search engine for Internet-connected devices. This client provides an interface for the [Shodan REST API](https://developer.shodan.io/api).

METHODS
=======

### method host

```raku
method host(
    Str :$ip!,
    Bool :$history = Bool::False,
    Bool :$minify = Bool::False
) returns Hash
```

Returns all services that have been found on the given host IP.

### method host-count

```raku
method host-count(
    Str :$query!,
    Str :$facets = ""
) returns Hash
```

Returns the total number of results that matched the query and any facet info.

### method host-search

```raku
method host-search(
    Str :$query!,
    Str :$facets = "",
    Int :$page where { ... } = 1,
    Bool :$minify = Bool::True
) returns Hash
```

Search Shodan using the same query syntax as the website and use facets to get summary information for different properties.

### method host-search-facets

```raku
method host-search-facets() returns Array
```

Returns a list of facets that can be used to get a breakdown of the top values for a property.

### method host-search-filters

```raku
method host-search-filters() returns Array
```

Returns a list of all filters that can be used when searching.

### method search-tokens

```raku
method search-tokens(
    Str :$query!
) returns Hash
```

This method lets you determine which filters are being used by the query string and what parameters were provided to the filters.

### method ports

```raku
method ports() returns Array
```

Returns a list all ports that Shodan is crawling on the Internet.

### method protocols

```raku
method protocols() returns Hash
```

Returns a list all protocols that can be used when performing on-demand Internet scans.

### method scan

```raku
method scan(
    Str :$ips!,
    Array :$service
) returns Hash
```

Request Shodan to crawl an IP/ netblock. This method uses API scan credits.

### method scan-internet

```raku
method scan-internet(
    Int :$port! where { ... },
    Str :$protocol!
) returns Hash
```

Request Shodan to crawl the Internet for a specific port. This requires an enterprise data license.

### method scans

```raku
method scans() returns Hash
```

Returns list of all the created scans.

### method scan-status

```raku
method scan-status(
    Str :$id!
) returns Hash
```

Check the progress of a previously submitted scan request.

### method alert-create

```raku
method alert-create(
    Str :$name!,
    Hash :$filters!,
    Int :$expires where { ... }
) returns Hash
```

Creates a network alert for a defined IP/ netblock which can be used to subscribe to changes/ events that are discovered within that range.

### method alert-info

```raku
method alert-info(
    Str :$id!
) returns Hash
```

Returns the information about a specific network alert.

### method alert-delete

```raku
method alert-delete(
    Str :$id!
) returns Hash
```

Remove the specified network alert.

### method alert-update

```raku
method alert-update(
    Str :$id!,
    Hash :$filters!
) returns Hash
```

Permits edit a network alert with a new list of IPs/ networks to keep track of.

### method alerts

```raku
method alerts() returns Array
```

Returns a listing of all the network alerts that are currently active on the account.

### method alert-triggers

```raku
method alert-triggers() returns Array
```

Get notifications when the specified trigger is met.

### method alert-trigger-create

```raku
method alert-trigger-create(
    Str :$id!,
    Str :$trigger!
) returns Hash
```

Get notifications when the specified trigger is met.

### method alert-trigger-delete

```raku
method alert-trigger-delete(
    Str :$id!,
    Str :$trigger!
) returns Hash
```

Stop getting notifications for the specified trigger.

### method alert-trigger-service-ignore

```raku
method alert-trigger-service-ignore(
    Str :$id!,
    Str :$trigger!,
    Str :$service!
) returns Hash
```

Ignore the specified service when it is matched for the trigger.

### method alert-trigger-service-notify

```raku
method alert-trigger-service-notify(
    Str :$id!,
    Str :$trigger!,
    Str :$service!
) returns Hash
```

Start getting notifications again for the specified trigger.

### method alert-notifier-create

```raku
method alert-notifier-create(
    Str :$id!,
    Str :$notifier-id!
) returns Hash
```

Add the specified notifier to the network alert. Notifications are only sent if triggers have also been enabled. For each created user, there is a default notifier which will sent via email.

### method alert-notifier-delete

```raku
method alert-notifier-delete(
    Str :$id!,
    Str :$notifier-id!
) returns Hash
```

Remove the notification service from the alert. Notifications are only sent if triggers have also been enabled.

### method notifiers

```raku
method notifiers() returns Hash
```

Get a list of all the notifiers that the user has created.

### method notifier-providers

```raku
method notifier-providers() returns Hash
```

Get a list of all the notification providers that are available and the parameters to submit when creating them.

### method notifier-create

```raku
method notifier-create(
    Str :$provider!,
    Str :$description!,
    Hash :$args!
) returns Mu
```

Use this method to create a new notification service endpoint that Shodan services can send notifications through.

### method notifier-delete

```raku
method notifier-delete(
    Str :$id!
) returns Hash
```

Remove the notification service created for the user.

### method notifier

```raku
method notifier(
    Str :$id!
) returns Hash
```

Use this method to create a new notification service endpoint that Shodan services can send notifications through.

### method notifier-update

```raku
method notifier-update(
    Str :$id!,
    Hash :$args!
) returns Hash
```

Use this method to update the parameters of a notifier.

### method queries

```raku
method queries(
    Int :$page where { ... } = 1,
    Str :$sort = "timestamp",
    Str :$order = "desc"
) returns Hash
```

Use this method to obtain a list of search queries that users have saved in Shodan.

### method query-search

```raku
method query-search(
    Str :$query!,
    Int :$page where { ... } = 1
) returns Mu
```

Use this method to search the directory of search queries that users have saved in Shodan.

### method query-tags

```raku
method query-tags(
    Int :$size where { ... } = 10
) returns Mu
```

Use this method to obtain a list of popular tags for the saved search queries in Shodan.

### method data

```raku
method data() returns Array
```

Use this method to see a list of the datasets that are available for download.

### method data-dataset

```raku
method data-dataset(
    Str :$dataset!
) returns Array
```

Get a list of files that are available for download from the provided dataset.

### method org

```raku
method org() returns Hash
```

Get information about your organization such as the list of its members, upgrades, authorized domains and more.

### method org-member-create

```raku
method org-member-create(
    Str :$user!,
    Bool :$notify = Bool::False
) returns Hash
```

Add a Shodan user to the organization and upgrade them.

### method org-member-delete

```raku
method org-member-delete(
    Str :$user!
) returns Hash
```

Remove and downgrade the provided member from the organization.

### method account-profile

```raku
method account-profile() returns Hash
```

Returns information about the Shodan account linked to this API key.

### method dns-domain

```raku
method dns-domain(
    Str :$domain!,
    Bool :$history = Bool::False,
    Str :$type = "",
    Int :$page where { ... } = 1
) returns Hash
```

Get all the subdomains and other DNS entries for the given domain. Uses 1 query credit per lookup.

### method dns-resolve

```raku
method dns-resolve(
    Str :$hostnames!
) returns Hash
```

Look up the IP address for the provided list of hostnames.

### method dns-reverse

```raku
method dns-reverse(
    Str :$ips!
) returns Hash
```

Look up the hostnames that have been defined for the given list of IP addresses.

### method tools-http-headers

```raku
method tools-http-headers() returns Hash
```

Shows the HTTP headers that your client sends when connecting to a webserver.

### method tools-myip

```raku
method tools-myip() returns Str
```

Get your current IP address as seen from the Internet.

### method api-info

```raku
method api-info() returns Hash
```

Returns information about the API plan belonging to the given API key.

AUTHOR
======

"Sarah Fuller", `<"sarah at averna . id . au"> `

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Sarah Fuller This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

