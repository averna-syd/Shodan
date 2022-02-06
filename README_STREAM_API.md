NAME
====

Shodan::API::Stream

DESCRIPTION
===========

A [raku-lang](https://raku.org/) client for [Shodan](https://www.shodan.io/), a search engine for Internet-connected devices. This client provides an interface for the [Shodan Streaming API](https://developer.shodan.io/api/stream).

METHODS
=======

### method stream-banners

```raku
method stream-banners(
    Code :$callback = Code.new
) returns Any
```

This stream provides ALL of the data that Shodan collects. Use this stream if you need access to everything and/ or want to store your own Shodan database locally. If you only care about specific ports, please use the Ports stream.

### method stream-asn

```raku
method stream-asn(
    Str :$asn!,
    Code :$callback = Code.new
) returns Any
```

This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in devices located in certain ASNs.

### method stream-countries

```raku
method stream-countries(
    Str :$countries!,
    Code :$callback = Code.new
) returns Any
```

This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in devices located in certain countries.

### method stream-ports

```raku
method stream-ports(
    Str :$ports!,
    Code :$callback = Code.new
) returns Any
```

Only returns banner data for the list of specified ports. This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in a specific list of ports.

### method stream-vulns

```raku
method stream-vulns(
    Str :$vulns!,
    Code :$callback = Code.new
) returns Any
```

Only returns banner data for the list of specified vulnerabilities. This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in a specific list of vulnerabilities.

### method stream-custom

```raku
method stream-custom(
    Str :$query!,
    Code :$callback = Code.new
) returns Any
```

Only returns banner data for the specified query. This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in banners matching a specific query. It generally follows the query syntax of the main search engine except that here the query is case-sensitive! The list of available keys can be found at Search Filters. Put a "-" or "!" before the key to negate the filter terms.

### method stream-alerts

```raku
method stream-alerts(
    Code :$callback = Code.new
) returns Any
```

Subscribe to banners discovered on all IP ranges described in the network alerts. The network alerts are renewed periodically every 1 hour.

### method stream-alert

```raku
method stream-alert(
    Str :$id!,
    Code :$callback = Code.new
) returns Any
```

Subscribe to banners discovered on the IP range defined in a specific network alert. The network alert is renewed periodically every 1 hour.

AUTHOR
======

"Sarah Fuller", `<"sarah at averna . id . au"> `

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Sarah Fuller This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

