use JSON::Fast;
unit role Shodan::API::Stream;

=begin pod
=head1 NAME

Shodan::API::Stream

=head1 DESCRIPTION

A L<raku-lang|https://raku.org/> client for L<Shodan|https://www.shodan.io/>,
a search engine for Internet-connected devices. This client provides an
interface for the L<Shodan Streaming API|https://developer.shodan.io/api/stream>.

=head1 METHODS
=end pod

#|(This stream provides ALL of the data that Shodan collects.
Use this stream if you need access to everything and/ or want to store your
own Shodan database locally.
If you only care about specific ports, please use the Ports stream.)
method stream-banners(Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route    => '/shodan/banners',
                                  stream   => True,
                                  callback => $callback
                              );
}

#|(This stream provides a filtered, bandwidth-saving view of the Banners
stream in case you are only interested in devices located in certain ASNs.)
method stream-asn(Str :$asn!, Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route    => "/shodan/asn/$asn",
                                  stream   => True,
                                  callback => $callback
                              );
}

#|(This stream provides a filtered, bandwidth-saving view of the Banners
stream in case you are only interested in devices located in certain countries.)
method stream-countries(Str :$countries!, Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route    => "/shodan/countries/$countries",
                                  stream   => True,
                                  callback => $callback
                              );
}

#|(Only returns banner data for the list of specified ports. This stream
provides a filtered, bandwidth-saving view of the Banners stream in case
you are only interested in a specific list of ports.)
method stream-ports(Str :$ports!, Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route    => "/shodan/ports/$ports",
                                  stream   => True,
                                  callback => $callback
                              );
}

#|(Only returns banner data for the list of specified vulnerabilities.
This stream provides a filtered, bandwidth-saving view of the Banners stream
in case you are only interested in a specific list of vulnerabilities.)
method stream-vulns(Str :$vulns!, Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route    => "/shodan/vulns/$vulns",
                                  stream   => True,
                                  callback => $callback
                              );
}

#|(Only returns banner data for the specified query. This stream provides a
filtered, bandwidth-saving view of the Banners stream in case you are only
interested in banners matching a specific query. It generally follows the
query syntax of the main search engine except that here the query is
case-sensitive! The list of available keys can be found at Search Filters.
Put a "-" or "!" before the key to negate the filter terms.)
method stream-custom(Str :$query!, Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route        => '/shodan/custom',
                                  stream       => True,
                                  callback     => $callback,
                                  query-params => {query => $query}
                              );
}

#|(Subscribe to banners discovered on all IP ranges described in the network alerts.
The network alerts are renewed periodically every 1 hour.)
method stream-alerts(Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route    => '/shodan/alert',
                                  stream   => True,
                                  callback => $callback
                              );
}

#|(Subscribe to banners discovered on the IP range defined in a specific network alert.
The network alert is renewed periodically every 1 hour.)
method stream-alert(Str :$id!, Code :$callback = {say $_} --> Any)
{
    return self!stream.request(
                                  route    => "/shodan/alert/$id",
                                  stream   => True,
                                  callback => $callback
                              );
}

=begin pod
=head1 AUTHOR

"Sarah Fuller", C<< <"sarah at averna . id . au"> >>

=head1 COPYRIGHT AND LICENSE
=begin para
Copyright 2022 Sarah Fuller
This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.
=end para
=end pod
