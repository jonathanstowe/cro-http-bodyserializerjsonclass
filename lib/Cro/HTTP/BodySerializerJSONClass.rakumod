use Cro::HTTP::BodySerializers;
use JSON::Class;

class Cro::HTTP::BodySerializerJSONClass does Cro::HTTP::BodySerializer {
    method is-applicable(Cro::HTTP::Message $message, $body --> Bool) {
        with $message.content-type {
            (.type eq 'application' && .subtype eq 'json' || .suffix eq 'json') && ($body ~~ JSON::Class );
        }
        else {
            False
        }
    }

    method serialize(Cro::HTTP::Message $message, $body --> Supply) {
        my $json = $body.to-json( :!pretty).encode('utf-8');
        self!set-content-length($message, $json.bytes);
        supply { emit $json }
    }
}

# vim: ft=raku
