use Cro::HTTP::Client;
use JSON::Fast;

unit class Shodan::HTTP is export;

has Str $.api-key    is required;
has Str $.base-uri   is required;
has Str $.user-agent is required;
has UInt $.max-retry is required;

constant HTTP_ERROR_CODE    = 3;
constant GENERAL_ERROR_CODE = 6;

method request(Str :$method, Str :$route, Hash :$query-params is copy,
               Any :$body-params, UInt :$retry-seconds = 10,
               Str :$content-type = 'application/json', Bool :$stream = False,
               Code :$callback = {say $_})
{
    my $client = Cro::HTTP::Client.new(
                                          base-uri     => $.base-uri,
                                          user-agent   => $.user-agent,
                                          content-type => $content-type,
                                      );
    my $response;

    $query-params{'key'} = $.api-key;

    given $method
    {
        when 'put'    {$response = await $client.put(
                                                          $route,
                                                          query   => $query-params,
                                                          body    => $body-params
                                                    )}
        when 'post'   {$response = await $client.post(
                                                          $route,
                                                          query   => $query-params,
                                                          body    => $body-params
                                                     )}
        when 'delete' {$response = await $client.delete(
                                                          $route,
                                                          query   => $query-params
                                                       )}
        default       {$response = await $client.get(
                                                          $route,
                                                          query   => $query-params
                                                    )}
    }

    if ($stream)
    {
        react
        {
            whenever $response.body-byte-stream -> $chunk
            {
                try
                {
                    $callback(from-json($chunk.decode()));
                }
            }
        }

        return True;
    }

    CATCH
    {
        when X::Cro::HTTP::Error
        {
            my $status = .response.status;

            if ($status == 429 && $retry-seconds < $.max-retry)
            {
                my $sec = $retry-seconds;
                say "Error 429 (too many connections). Retrying in $sec seconds... $_";
                sleep($sec);
                $sec++;
                return self.request(
                                       method        => $method,
                                       route         => $route,
                                       query-params  => $query-params,
                                       body-params   => $body-params,
                                       retry-seconds => $sec
                                   );
            }
            else
            {
                say "Error $status while requesting $route: $_";
                exit(HTTP_ERROR_CODE);
            }
        }
        default
        {
            say "Unexpected error while requesting $route: $_";
            exit(GENERAL_ERROR_CODE);
        }
    }

    my $result = await $response.body;

    return $result;
}
