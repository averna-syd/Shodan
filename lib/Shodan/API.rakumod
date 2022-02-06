use Shodan::HTTP;
use Shodan::API::REST;
use Shodan::API::Stream;
use Shodan::API::Exploit;

unit role Shodan::API
    does Shodan::API::REST
    does Shodan::API::Stream
    does Shodan::API::Exploit;

has Str $.api-key          is required;
has Str $.rest-base-uri    is default('https://api.shodan.io');
has Str $.stream-base-uri  is default('https://stream.shodan.io');
has Str $.exploit-base-uri is default('https://exploits.shodan.io');
has Str $.user-agent       is default('RakuClient - https://www.raku.org');
has UInt $.max-retry       is default(30);

has $.rest    = Shodan::HTTP.new: :$!api-key, base-uri => $!rest-base-uri, :$!user-agent, :$!max-retry;
has $.stream  = Shodan::HTTP.new: :$!api-key, base-uri => $!stream-base-uri, :$!user-agent, :$!max-retry;
has $.exploit = Shodan::HTTP.new: :$!api-key, base-uri => $!exploit-base-uri, :$!user-agent, :$!max-retry;

# let roles use these
method !rest {$.rest}
method !stream {$.stream}
method !exploit {$.exploit}
