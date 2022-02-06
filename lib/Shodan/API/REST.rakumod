use JSON::Fast;
unit role Shodan::API::REST;

=begin pod
=head1 NAME

Shodan::API::REST

=head1 DESCRIPTION

A L<raku-lang|https://raku.org/> client for L<Shodan|https://www.shodan.io/>,
a search engine for Internet-connected devices. This client provides an
interface for the L<Shodan REST API|https://developer.shodan.io/api>.

=head1 METHODS
=end pod

#|(Returns all services that have been found on the given host IP.)
method host(Str :$ip!, Bool :$history = False, Bool :$minify = False --> Hash)
{
    return self!rest.request(
                                route        => "/shodan/host/$ip",
                                query-params => {
                                                    history => $history,
                                                    minify  => $minify
                                                }
                            );
}

#|(Returns the total number of results that matched the query and any facet info.)
method host-count(Str :$query!, Str :$facets = '' --> Hash)
{
    return self!rest.request(
                                route        => '/shodan/host/count',
                                query-params => {
                                                    query  => $query,
                                                    facets => $facets
                                                }
                            );
}

#|(Search Shodan using the same query syntax as the website and use facets to
get summary information for different properties.)
method host-search(Str :$query!, Str :$facets = '', UInt :$page = 1,
                   Bool :$minify = True --> Hash)
{
    return self!rest.request(
                                route        => '/shodan/host/search',
                                query-params => {
                                                    query  => $query,
                                                    facets => $facets,
                                                    page   => $page,
                                                    minify => $minify
                                                }
                            );
}

#|(Returns a list of facets that can be used to get a breakdown of the top
values for a property.)
method host-search-facets( --> Array)
{
    return self!rest.request(route => '/shodan/host/search/facets');
}

#|(Returns a list of all filters that can be used when searching.)
method host-search-filters( --> Array)
{
    return self!rest.request(route => '/shodan/host/search/filters');
}

#|(This method lets you determine which filters are being used by the query
string and what parameters were provided to the filters.)
method search-tokens(Str :$query! --> Hash)
{
    return self!rest.request(
                                route        => '/shodan/host/search/tokens',
                                query-params => {
                                                    query => $query
                                                }
                            );
}

#|(Returns a list all ports that Shodan is crawling on the Internet.)
method ports( --> Array)
{
    return self!rest.request(route => '/shodan/ports');
}

#|(Returns a list all protocols that can be used when performing on-demand
Internet scans.)
method protocols( --> Hash)
{
    return self!rest.request(route => '/shodan/protocols');
}

#|(Request Shodan to crawl an IP/ netblock. This method uses API scan credits.)
method scan(Str :$ips!, Array :$service --> Hash)
{
    my $ips-json;

    if $service
    {
        my $ips-data = {};

        for split(',', $ips).Array -> $ip
        {
            $ips-data{$ip} = $service;
        }

        $ips-json = to-json($ips-data).Str;
        $ips-json ~~ s:g|\n||;
    }

    return self!rest.request(
                                method       => 'post',
                                route        => '/shodan/scan',
                                content-type => 'application/x-www-form-urlencoded',
                                body-params  => {
                                                    ips => $service ?? $ips-json !! $ips
                                                }
                            );
}

#|(Request Shodan to crawl the Internet for a specific port. This requires
an enterprise data license.)
method scan-internet(UInt :$port!, Str :$protocol! --> Hash)
{
    return self!rest.request(
                                method       => 'post',
                                route        => '/shodan/scan/internet',
                                content-type => 'application/x-www-form-urlencoded',
                                body-params  => {
                                                    port     => $port,
                                                    protocol => $protocol
                                                }
                            );
}

#|(Returns list of all the created scans.)
method scans( --> Hash)
{
    return self!rest.request(route => '/shodan/scans');
}

#|(Check the progress of a previously submitted scan request.)
method scan-status(Str :$id! --> Hash)
{
    return self!rest.request(route => "/shodan/scan/$id");
}

#|(Creates a network alert for a defined IP/ netblock which can be used to
subscribe to changes/ events that are discovered within that range.)
method alert-create(Str :$name!, Hash :$filters!, UInt :$expires --> Hash)
{
    return self!rest.request(
                                method      => 'post',
                                route       => '/shodan/alert',
                                body-params => {
                                                   name    => $name,
                                                   filters => $filters,
                                                   expires => $expires
                                               }
                            );
}

#|(Returns the information about a specific network alert.)
method alert-info(Str :$id! --> Hash)
{
     return self!rest.request(route => "/shodan/alert/$id/info");
}

#|(Remove the specified network alert.)
method alert-delete(Str :$id! --> Hash)
{
    return self!rest.request(method => 'delete', route => "/shodan/alert/$id");
}

#|(Permits edit a network alert with a new list of IPs/ networks to keep track of.)
method alert-update(Str :$id!, Hash :$filters! --> Hash)
{
    return self!rest.request(
                                method      => 'post',
                                route       => "/shodan/alert/$id",
                                body-params => {
                                                   filters => $filters
                                               }
                            );
}

#|(Returns a listing of all the network alerts that are currently active on
the account.)
method alerts( --> Array)
{
    return self!rest.request(route => "/shodan/alert/info");
}

#|(Get notifications when the specified trigger is met.)
method alert-triggers( --> Array)
{
    return self!rest.request(route => "/shodan/alert/triggers");
}

#|(Get notifications when the specified trigger is met.)
method alert-trigger-create(Str :$id!, Str :$trigger! --> Hash)
{
    return self!rest.request(
                                method => 'put',
                                route  => "/shodan/alert/$id/trigger/$trigger"
                            );
}

#|(Stop getting notifications for the specified trigger.)
method alert-trigger-delete(Str :$id!, Str :$trigger! --> Hash)
{
    return self!rest.request(
                                method => 'delete',
                                route  => "/shodan/alert/$id/trigger/$trigger"
                            );
}

#|(Ignore the specified service when it is matched for the trigger.)
method alert-trigger-service-ignore(Str :$id!, Str :$trigger!, Str :$service! --> Hash)
{
    return self!rest.request(
                                method => 'put',
                                route  => "/shodan/alert/$id/trigger/$trigger/ignore/$service"
                            );
}

#|(Start getting notifications again for the specified trigger.)
method alert-trigger-service-notify(Str :$id!, Str :$trigger!, Str :$service! --> Hash)
{
    return self!rest.request(
                                method => 'delete',
                                route  => "/shodan/alert/$id/trigger/$trigger/ignore/$service"
                            );
}

#|(Add the specified notifier to the network alert.
Notifications are only sent if triggers have also been enabled.
For each created user, there is a default notifier which will sent via email.)
method alert-notifier-create(Str :$id!, Str :$notifier-id! --> Hash)
{
    return self!rest.request(
                                method => 'put',
                                route  => "/shodan/alert/$id/notifier/$notifier-id"
                            );
}

#|(Remove the notification service from the alert.
Notifications are only sent if triggers have also been enabled.)
method alert-notifier-delete(Str :$id!, Str :$notifier-id! --> Hash)
{
    return self!rest.request(
                                method => 'delete',
                                route  => "/shodan/alert/$id/notifier/$notifier-id"
                            );
}

#|(Get a list of all the notifiers that the user has created.)
method notifiers( --> Hash)
{
    return self!rest.request(route => '/notifier');
}

#|(Get a list of all the notification providers that are available and the
parameters to submit when creating them.)
method notifier-providers( --> Hash)
{
    return self!rest.request(route => '/notifier/provider');
}

#|(Use this method to create a new notification service endpoint that Shodan
services can send notifications through.)
method notifier-create(Str :$provider!, Str :$description!, Hash :$args!)
{
    $args{'provider'}    = $provider;
    $args{'description'} = $description;

    return self!rest.request(
                                method       => 'post',
                                route        => '/notifier',
                                content-type => 'application/x-www-form-urlencoded',
                                body-params  => $args
                            );
}

#|(Remove the notification service created for the user.)
method notifier-delete(Str :$id! --> Hash)
{
    return self!rest.request(method => 'delete', route => "/notifier/$id");
}

#|(Use this method to create a new notification service endpoint that Shodan
services can send notifications through.)
method notifier(Str :$id! --> Hash)
{
    return self!rest.request(route => "/notifier/$id");
}

#|(Use this method to update the parameters of a notifier.)
method notifier-update(Str :$id!, Hash :$args! --> Hash)
{
    return self!rest.request(
                                method       => 'put',
                                route        => "/notifier/$id",
                                content-type => 'application/x-www-form-urlencoded',
                                body-params  => $args
                            );
}

#|(Use this method to obtain a list of search queries that users have saved in Shodan.)
method queries(UInt :$page = 1, Str :$sort = 'timestamp', Str :$order = 'desc' --> Hash)
{
    return self!rest.request(
                                route        => '/shodan/query',
                                query-params => {
                                                    page  => $page,
                                                    sort  => $sort,
                                                    order => $order
                                                }
                            );
}

#|(Use this method to search the directory of search queries that users have saved in Shodan.)
method query-search(Str :$query!, UInt :$page = 1)
{
    return self!rest.request(
                                route        => '/shodan/query/search',
                                query-params => {
                                                    query => $query,
                                                    page  => $page
                                                }
                            );
}

#|(Use this method to obtain a list of popular tags for the saved search queries in Shodan.)
method query-tags(UInt :$size = 10)
{
    return self!rest.request(route => '/shodan/query/tags', query-params => {size => $size});
}

#|(Use this method to see a list of the datasets that are available for download.)
method data( --> Array)
{
     return self!rest.request(route => '/shodan/data');
}

#|(Get a list of files that are available for download from the provided dataset.)
method data-dataset(Str :$dataset! --> Array)
{
    return self!rest.request(route => "/shodan/data/$dataset");
}

#|(Get information about your organization such as the list of its members,
upgrades, authorized domains and more.)
method org( --> Hash)
{
    return self!rest.request(route => '/org');
}

#|(Add a Shodan user to the organization and upgrade them.)
method org-member-create(Str :$user!, Bool :$notify = False --> Hash)
{
    return self!rest.request(
                                method       => 'put',
                                route        => "/org/member/$user",
                                query-params => {
                                                    notify => $notify
                                                }
                            );
}

#|(Remove and downgrade the provided member from the organization.)
method org-member-delete(Str :$user! --> Hash)
{
    return self!rest.request(method => 'delete', route => "/org/member/$user");
}

#|(Returns information about the Shodan account linked to this API key.)
method account-profile( --> Hash)
{
    return self!rest.request(route => '/account/profile');
}

#|(Get all the subdomains and other DNS entries for the given domain.
Uses 1 query credit per lookup.)
method dns-domain(Str :$domain!, Bool :$history = False,
                  Str :$type = '', UInt :$page = 1 --> Hash)
{
     return self!rest.request(
                                route        => "/dns/domain/$domain",
                                query-params => {
                                                    history => $history,
                                                    type    => $type,
                                                    page    => $page
                                                }
                             );
}

#|(Look up the IP address for the provided list of hostnames.)
method dns-resolve(Str :$hostnames! --> Hash)
{
    return self!rest.request(
                                route        => '/dns/resolve',
                                query-params => {
                                                    hostnames => $hostnames
                                                }
                            );
}

#|(Look up the hostnames that have been defined for the given list of IP addresses.)
method dns-reverse(Str :$ips! --> Hash)
{
    return self!rest.request(route => '/dns/reverse', query-params => {ips => $ips});
}

#|(Shows the HTTP headers that your client sends when connecting to a webserver.)
method tools-http-headers( --> Hash)
{
    return self!rest.request(route => '/tools/httpheaders');
}

#|(Get your current IP address as seen from the Internet.)
method tools-myip( --> Str)
{
    return self!rest.request(route => '/tools/myip');
}

#|(Returns information about the API plan belonging to the given API key.)
method api-info( --> Hash)
{
    return self!rest.request(route => '/api-info');
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
